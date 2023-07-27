//___FILEHEADER___

#import "___FILEBASENAME___.h"

#import "NetworkDeviceLocator.h"
#import "BluetoothDeviceLocator.h"

@implementation ___FILEBASENAME:identifier___ {
    id <DeviceLocator> _networkDeviceLocator;
    id <DeviceLocator> _bluetoothDeviceLocator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkDeviceLocator = [[NetworkDeviceLocator alloc] init];
        _bluetoothDeviceLocator = [[BluetoothDeviceLocator alloc] init];
    }
    return self;
}

- (void)startDiscoveryWithSession:(DDDiscoverySession *)session
{
    // Set up an event handler so the device locators can inform the session about devices.
    
    DDEventHandler eventHandler = ^(DDDeviceEvent *event) {
        [session reportEvent:event];
    };
    
    _networkDeviceLocator.eventHandler = eventHandler;
    _bluetoothDeviceLocator.eventHandler = eventHandler;
    
    // Start scanning for devices.
    
    [_networkDeviceLocator startScanning];
    [_bluetoothDeviceLocator startScanning];
}

- (void)stopDiscoveryWithSession:(DDDiscoverySession *)session
{
    // Stop scanning for devices.
    
    [_networkDeviceLocator stopScanning];
    [_bluetoothDeviceLocator stopScanning];
    
    // Ensure no more events are reported.
    
    _networkDeviceLocator.eventHandler = nil;
    _bluetoothDeviceLocator.eventHandler = nil;
}

@end
