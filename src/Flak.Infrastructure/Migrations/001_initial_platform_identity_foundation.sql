create extension if not exists pgcrypto;

create table if not exists user_accounts (
    id uuid primary key default gen_random_uuid(),
    username text not null,
    email text not null,
    password_hash text not null,
    is_active boolean not null default true,
    created_utc timestamptz not null default now(),
    updated_utc timestamptz not null default now()
);
create unique index if not exists ux_user_accounts_username on user_accounts(username);
create unique index if not exists ux_user_accounts_email on user_accounts(email);

create table if not exists roles (id uuid primary key default gen_random_uuid(), name text not null, description text, created_utc timestamptz not null default now());
create unique index if not exists ux_roles_name on roles(name);
create table if not exists permissions (id uuid primary key default gen_random_uuid(), name text not null, description text, created_utc timestamptz not null default now());
create unique index if not exists ux_permissions_name on permissions(name);
create table if not exists user_roles (id uuid primary key default gen_random_uuid(), user_id uuid not null references user_accounts(id), role_id uuid not null references roles(id), created_utc timestamptz not null default now());
create table if not exists role_permissions (id uuid primary key default gen_random_uuid(), role_id uuid not null references roles(id), permission_id uuid not null references permissions(id), created_utc timestamptz not null default now());
create table if not exists platform_services (id uuid primary key default gen_random_uuid(), key text not null, name text not null, metadata jsonb not null default '{}'::jsonb, created_utc timestamptz not null default now());
create unique index if not exists ux_platform_services_key on platform_services(key);
create table if not exists service_access (id uuid primary key default gen_random_uuid(), user_id uuid not null references user_accounts(id), platform_service_id uuid not null references platform_services(id), created_utc timestamptz not null default now());
create table if not exists api_keys (id uuid primary key default gen_random_uuid(), key_hash text not null, subject_type text not null, subject_id uuid not null, expires_utc timestamptz, created_utc timestamptz not null default now());
create index if not exists ix_api_keys_key_hash on api_keys(key_hash);
create table if not exists user_sessions (id uuid primary key default gen_random_uuid(), user_id uuid not null references user_accounts(id), session_token_hash text not null, expires_utc timestamptz not null, created_utc timestamptz not null default now());
create index if not exists ix_user_sessions_user_id on user_sessions(user_id);
create table if not exists audit_logs (id uuid primary key default gen_random_uuid(), actor_user_id uuid, action text not null, entity_type text not null, entity_id text, payload jsonb not null default '{}'::jsonb, created_utc timestamptz not null default now());
create index if not exists ix_audit_logs_created_utc on audit_logs(created_utc);
create table if not exists schema_migrations (id text primary key, applied_utc timestamptz not null);
