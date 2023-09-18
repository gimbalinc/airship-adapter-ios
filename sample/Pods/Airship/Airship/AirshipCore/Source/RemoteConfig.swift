/* Copyright Airship and Contributors */

// NOTE: For internal use only. :nodoc:
struct RemoteConfig: Codable, Equatable {

    public let remoteDataURL: String?
    public let deviceAPIURL: String?
    public let analyticsURL: String?
    public let chatURL: String?
    public let chatWebSocketURL: String?

    enum CodingKeys: String, CodingKey {
        case remoteDataURL = "remote_data_url"
        case deviceAPIURL = "device_api_url"
        case analyticsURL = "analytics_url"
        case chatURL = "chat_url"
        case chatWebSocketURL = "chat_web_socket_url"
    }

    init(
        remoteDataURL: String?,
        deviceAPIURL: String?,
        analyticsURL: String?,
        chatURL: String?,
        chatWebSocketURL: String?
    ) {

        self.remoteDataURL = RemoteConfig.normalizeURL(remoteDataURL)
        self.deviceAPIURL = RemoteConfig.normalizeURL(deviceAPIURL)
        self.analyticsURL = RemoteConfig.normalizeURL(analyticsURL)
        self.chatURL = RemoteConfig.normalizeURL(chatURL)
        self.chatWebSocketURL = RemoteConfig.normalizeURL(chatWebSocketURL)
    }

    static func normalizeURL(_ urlString: String?) -> String? {
        guard var url = urlString,
            url.hasSuffix("/")
        else {
            return urlString
        }

        url.removeLast()
        return url
    }
}
