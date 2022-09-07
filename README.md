# Airship iOS Gimbal Adapter

The Airship Gimbal Adapter is a drop-in class that allows users to integrate Gimbal place events with Airship.

## Resources
- [Gimbal Developer Guide](https://gimbal.com/doc/iosdocs/v2/devguide.html)
- [Gimbal Manager Portal](https://manager.gimbal.com)
- [Airship Getting Started guide](http://docs.airship.com/build/ios.html)

## Installation

The Airship Gimbal Adapter is available through CocoaPods. To install it, simply add the following line to your Podfile:

`pod "GimbalAirshipAdapter"`

## Usage

### Importing

#### Swift

```
import AirshipAdapter
```

#### Obj-C

```
@import AirshipAdapter
```

### Enabling Event Tracking

#### RegionEvents
To enable or disable the tracking of Airship `RegionEvent` objects, use the  `shouldTrackRegionEvents` property:

```
AirshipAdapter.shared.shouldTrackRegionEvents = true // enabled
AirshipAdapter.shared.shouldTrackRegionEvents = false // disabled
```

#### CustomEvents

To enable or disable the tracking of Airship `CustomEvent` objects, use the `shouldTrackCustomEntryEvents` and `shouldTrackCustomExitEvents` properties to track events upon place entry and exit, respectively:
```
AirshipAdapter.shared.shouldTrackCustomExitEvents = true // CustomEvent tracking enabled for place exits
AirshipAdapter.shared.shouldTrackCustomExitEvents = false // CustomEvent tracking disabled for place exits
AirshipAdapter.shared.shouldTrackCustomEntryEvents = true // CustomEvent tracking enabled for place entries
AirshipAdapter.shared.shouldTrackCustomEntryEvents = false // CustomEvent tracking disabled for place entries
```

### Restoring the adapter

In your application delegate call `restore` during `didFinishLaunchingWithOptions`:

#### Swift

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

   // after Airship.takeOff   
   AirshipGimbalAdapter.shared.restore()

   ...
}
```

#### Obj-C

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   // after UAirship.takeOff
   [[AirshpGimbalAdapter shared] restore];

   ...
}
```

Restore will automatically resume the adapter on application launch.


### Starting the adapter

#### Swift

```
AirshipGimbalAdapter.shared.start("## PLACE YOUR API KEY HERE ##")
```

#### Obj-C

```
[[AirshpGimbalAdapter shared] start:@"## PLACE YOUR API KEY HERE ##"];
```

### Stopping the adapter

#### Swift

```
AirshipGimbalAdapter.shared.stop()
```

#### Obj-C

```
[[AirshpGimbalAdapter shared] stop];
```

### Enabling Bluetooth Warning

In the event that Bluetooth is disabled during place monitoring, the Gimbal Adapter can prompt users with an alert view
to enable Bluetooth. This functionality is disabled by default, but can be enabled by setting AirshipGimbalAdapter's
`bluetoothPoweredOffAlertEnabled` property to true:

#### Swift

```
AirshipGimbalAdapter.shared.bluetoothPoweredOffAlertEnabled = true
```

#### Obj-C

```
[AirshpGimbalAdapter shared].bluetoothPoweredOffAlertEnabled = YES;
```

## AirshipGimbalAdapter Migration

The `AirshipGimbalAdapter` is an older version of this adapter; if you previously used the `AirshipGimblAdapter` and would like to migrate, see the following steps:
- If using Cocoapods, change the name of the pod from `AirshipGimbalAdapter` to `GimbalAirshipAdapter`
- In your code, references to the `AirshipGimbalAdapter` class should be changed to `AirshipAdapter`
