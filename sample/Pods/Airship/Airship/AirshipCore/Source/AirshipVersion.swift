// Copyright Airship and Contributors

import Foundation

@objc(UAirshipVersion)
public class AirshipVersion: NSObject {
    public static let version = "17.2.2"

    @objc
    public class func get() -> String {
        return version
    }
}
