//___FILEHEADER___

#import "NetworkDeviceLocator.h"

#import <DeviceDiscoveryExtension/DeviceDiscoveryExtension.h>
#import <Network/Network.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>


@implementation NetworkDeviceLocator {
    nw_browser_t _browser;
    NSMutableArray <DDDevice *> *_knownDevices;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // An example Bonjour service type for the device for which to scan.
        // This must match a value contained within the NSBonjourServices array in the extension's Info.plist.
        char *exampleServiceType = "_example._tcp";
        
        // Create a network browser to search for devices.
        
        nw_parameters_t parameters = nw_parameters_create();
        nw_parameters_set_include_peer_to_peer(parameters, true);
        
        _browser = nw_browser_create(nw_browse_descriptor_create_bonjour_service(exampleServiceType, NULL), parameters);
        nw_browser_set_queue(_browser, dispatch_get_main_queue());
    }
    return self;
}

@synthesize eventHandler = _eventHandler;

/// Start scanning for devices using the network browser.
- (void)startScanning
{
    nw_browser_set_browse_results_changed_handler(_browser, ^(nw_browse_result_t  _Nonnull old_result, nw_browse_result_t  _Nonnull new_result, bool batch_complete) {
        nw_browse_result_change_t changes = nw_browse_result_get_changes(old_result, new_result);
        if (changes & nw_browse_result_change_result_added) {
            nw_endpoint_t endpoint = nw_browse_result_copy_endpoint(new_result);
            if (nw_endpoint_get_type(endpoint) == nw_endpoint_type_bonjour_service) {
                [self didDiscoverDeviceWithEndpoint:endpoint];
            }
        }
    });
    
    _knownDevices = [NSMutableArray array];
    nw_browser_start(_browser);
}

/// Stop scanning for devices using the network browser.
- (void)stopScanning
{
    nw_browser_cancel(_browser);
    
    nw_browser_set_browse_results_changed_handler(_browser, NULL);
    
    if (_eventHandler) {
        for (DDDevice *device in _knownDevices) {
            DDDeviceEvent *event = [[DDDeviceEvent alloc] initWithEventType:DDEventTypeDeviceLost device:device];
            _eventHandler(event);
        }
    }
    [_knownDevices removeAllObjects];
}

- (void)didDiscoverDeviceWithEndpoint:(nw_endpoint_t)endpoint
{
    // If no event handler is set, don't report anything.
    
    if (_eventHandler == nil) {
        return;
    }
    
    // An example device identifier and name for the discovered device.
    // It's important that this come from or be associated with the device itself.
    NSUUID *exampleDeviceUUID = [NSUUID UUID];
    NSString *exampleDeviceIdentifier = exampleDeviceUUID.UUIDString;
    const char *exampleDeviceNameCString = nw_endpoint_get_bonjour_service_name(endpoint);
    NSString *exampleDeviceName = [NSString stringWithUTF8String:exampleDeviceNameCString];
    
    // An example protocol for the discovered device.
    // This must match the type declared in the extension's Info.plist.
    UTType *exampleDeviceProtocol = [UTType typeWithIdentifier:@"com.example.example-protocol"];
    NSAssert(exampleDeviceProtocol != nil, @"Misconfiguration: UTType for protocol not defined.");
    
    // Create a DDDevice instance representing the device.
    DDDevice *device = [[DDDevice alloc] initWithDisplayName:exampleDeviceName category:DDDeviceCategoryTV protocolType:exampleDeviceProtocol identifier:exampleDeviceIdentifier];
    device.networkEndpoint = endpoint;
    
    [_knownDevices addObject:device];
    
    // Pass it to the event handler.
    
    DDDeviceEvent *event = [[DDDeviceEvent alloc] initWithEventType:DDEventTypeDeviceFound device:device];
    _eventHandler(event);
}

@end
