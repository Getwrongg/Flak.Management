namespace Flak.Shared.Options; public sealed class TestingOptions { public bool UseMockAuth {get;set;}
public bool UseMockCache {get;set;}
public bool UseMockWorkers {get;set;}
public bool UseMockExternalServices {get;set;}
public bool SeedDemoData {get;set;}
public bool AllowUnsafeTestEndpoints {get;set;} }