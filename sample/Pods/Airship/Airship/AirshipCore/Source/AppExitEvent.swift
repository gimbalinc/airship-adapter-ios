/* Copyright Airship and Contributors */

/// - Note: For Internal use only :nodoc:
class AppExitEvent: NSObject, AirshipEvent {
    private lazy var analytics = Airship.requireComponent(
        ofType: AnalyticsProtocol.self
    )

    convenience init(analytics: AnalyticsProtocol) {
        self.init()
        self.analytics = analytics
    }

    @objc
    public var priority: EventPriority {
        return .normal
    }

    @objc
    public var eventType: String {
        return "app_exit"
    }

    @objc
    public var data: [AnyHashable: Any] {
        return self.gatherData()
    }

    open func gatherData() -> [AnyHashable: Any] {
        var data: [AnyHashable: Any] = [:]

        data["push_id"] = self.analytics.conversionSendID
        data["metadata"] = self.analytics.conversionPushMetadata
        #if !os(watchOS)
        data["connection_type"] = AirshipUtils.connectionType()
        #endif

        return data
    }

}
