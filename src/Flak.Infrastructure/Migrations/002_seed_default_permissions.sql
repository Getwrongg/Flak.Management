insert into permissions (name, description) values
('admin.users.manage','Manage user accounts'),
('admin.roles.manage','Manage roles'),
('platform.services.view','View services'),
('platform.services.manage','Manage services'),
('cache.read','Read cache'),
('cache.write','Write cache'),
('gameservers.view','View game servers'),
('gameservers.manage','Manage game servers'),
('gameservers.rcon.send','Send RCON commands'),
('monitoring.view','View monitoring')
on conflict do nothing;

insert into roles (name, description) values
('PlatformAdmin','Full platform administration'),
('ServiceAdmin','Service management operations'),
('Viewer','Read-only platform access')
on conflict do nothing;
