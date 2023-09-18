/* Copyright Airship and Contributors */

import Foundation

protocol AppStateTrackerAdapter {
    @MainActor
    var state: ApplicationState { get }

    @MainActor
    func watchAppLifeCycleEvents(
        eventHandler: @MainActor @Sendable @escaping (AppLifeCycleEvent) -> Void
    )
}

enum AppLifeCycleEvent: Sendable {
    case didBecomeActive
    case willResignActive
    case willEnterForeground
    case didEnterBackground
    case willTerminate
}


#if os(watchOS)
final class DefaultAppStateTrackerAdapter: AppStateTrackerAdapter, Sendable {
    var state: ApplicationState {
        let appState = WKExtension.shared().applicationState
        switch appState {
        case .active:
            return .active
        case .inactive:
            return .inactive
        case .background:
            return .background
        @unknown default:
            AirshipLogger.error("Unknown application state \(appState)")
            return .background
        }
    }
    
    func watchAppLifeCycleEvents(
        eventHandler: @MainActor @escaping (AppLifeCycleEvent) -> Void
    ) {
        let notificationCenter = NotificationCenter.default
        
        // active
        notificationCenter.addObserver(
            forName: WKExtension.applicationDidBecomeActiveNotification,
            object: nil,
            queue: nil,
            using: { _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.didBecomeActive)
                }
            }
        )

        // inactive
        notificationCenter.addObserver(
            forName: WKExtension.applicationWillResignActiveNotification,
            object: nil,
            queue: nil,
            using: { _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.willResignActive)
                }
            }
        )

        // foreground
        notificationCenter.addObserver(
            forName: WKExtension.applicationWillEnterForegroundNotification,
            object: nil,
            queue: nil,
            using: { _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.willEnterForeground)
                }
            }
        )
        
        // background
        notificationCenter.addObserver(
            forName: WKExtension.applicationDidEnterBackgroundNotification,
            object: nil,
            queue: nil,
            using: { _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.didEnterBackground)
                }
            }
        )
    }

    @MainActor(unsafe)
    static func runUnsafe(_ block: @MainActor () -> Void) {
        block()
    }
}
#else
final class DefaultAppStateTrackerAdapter: AppStateTrackerAdapter, Sendable {
    var state: ApplicationState {
        let appState = UIApplication.shared.applicationState
        switch appState {
        case .active:
            return .active
        case .inactive:
            return .inactive
        case .background:
            return .background
        @unknown default:
            AirshipLogger.error("Unknown application state \(appState)")
            return .background
        }
    }
    
    func watchAppLifeCycleEvents(
        eventHandler: @MainActor @escaping (AppLifeCycleEvent) -> Void
    ) {
        
        let notificationCenter = NotificationCenter.default
        
        // active
        notificationCenter.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil,
            using: {  _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.didBecomeActive)
                }
            }
        )

        // inactive
        notificationCenter.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: nil,
            using: {  _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.willResignActive)
                }
            }
        )

        // foreground
        notificationCenter.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: nil,
            using: {  _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.willEnterForeground)
                }
            }
        )
        
        // background
        notificationCenter.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil,
            using: { _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.didEnterBackground)
                }
            }
        )
        
        // terminate
        notificationCenter.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: nil,
            using: {  _ in
                DefaultAppStateTrackerAdapter.runUnsafe {
                    eventHandler(.willTerminate)
                }
            }
        )
    }

    @MainActor(unsafe)
    static func runUnsafe(_ block: @MainActor () -> Void) {
        block()
    }
}

#endif

