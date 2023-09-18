/* Copyright Airship and Contributors */

import Foundation

/// - Note: For internal use only. :nodoc:
public final class AirshipLock: Sendable {
    private let lock = NSRecursiveLock()

    public init() {}

    public func sync(closure: () -> Void) {
        self.lock.lock()
        closure()
        self.lock.unlock()
    }
}
