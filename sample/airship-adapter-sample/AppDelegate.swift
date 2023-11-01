//
//  AppDelegate.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/17/22.
//

import UIKit
import GimbalAirshipAdapter
import AirshipKit
import CoreLocation
import Gimbal

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
                window?.rootViewController = EventsViewController()
                window?.makeKeyAndVisible()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        Airship.takeOff(launchOptions: launchOptions)
        Airship.push.userPushNotificationsEnabled = true
        Airship.push.defaultPresentationOptions = [.badge, .sound, .list, .banner]
        AirshipAdapter.shared.shouldTrackCustomEntryEvents = true
        AirshipAdapter.shared.shouldTrackCustomExitEvents = false
        AirshipAdapter.shared.shouldTrackRegionEvents = true
//        AirshipAdapter.shared.set(userAnalyticsId: "YOUR_ANALYTICS_ID")
        AirshipAdapter.shared.start("YOUR_GIMBAL_API_KEY")
        AirshipAdapter.shared.restore()
        
        // Uncomment the following lines for more detailed logging
//        Debugger.enableDebugLogging()
//        Debugger.enableBeaconSightingsLogging()
//        Debugger.enablePlaceLogging()
        
        print("My Application Channel ID: \(String(describing: Airship.channel.identifier))")
            
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        self.notifyAndSavePlaceEventWith(
            firstDescriptor: "Background Notification Received",
            secondDescriptor: Date().toFormattedLocalString()
        )
    }
    
    private func notifyAndSavePlaceEventWith(firstDescriptor: String, secondDescriptor: String) {
        let newEvent = AdapterEvent(firstDescriptor: firstDescriptor, secondDescriptor: secondDescriptor)
        DefaultsService.shared().save(event: newEvent)
        
        NotificationCenter.default.post(name: .didReceiveNewGimbalEvent, object: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        self.notifyAndSavePlaceEventWith(
            firstDescriptor: "Foreground Notification Received",
            secondDescriptor: Date().toFormattedLocalString()
        )
        completionHandler([.banner, .list, .sound])
    }
}

