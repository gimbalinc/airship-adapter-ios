/* Copyright Airship and Contributors */

import Foundation

#if canImport(AirshipCore)
import AirshipCore
#endif

/// Message center message.
@objc(UAMessageCenterMessage)
public final class MessageCenterMessage: NSObject, Sendable {
    /// The message title.
    @objc
    public let title: String
    
    /// The Airship message ID.
    /// This ID may be used to match an incoming push notification to a specific message.
    @objc
    public let id: String
    
    /// The message's extra dictionary.
    /// This dictionary can be populated with arbitrary key-value data at the time the message is composed.
    @objc
    public let extra: [String: String]
    
    /// The URL for the message body itself.
    /// This URL may only be accessed with Basic Auth credentials set to the user ID and password.
    @objc
    public let bodyURL: URL
    
    /// The date and time the message will expire.
    /// A nil value indicates it will never expire.
    @objc
    public let expirationDate: Date?
    
    /// The date and time the message was sent (UTC).
    @objc
    public let sentDate: Date
    
    /// The unread status of the message.
    /// `true` if the message is unread, otherwise `false`.
    @objc
    public let unread: Bool

    /// The reporting data of the message.
    let messageReporting: AirshipJSON?
    
    /// The URL for the message.
    /// This URL may only be accessed with Basic Auth credentials set to the user ID and password.
    let messageURL: URL
    
    /// The raw message dictionary.
    /// This is the dictionary that originally created the message.
    /// It can contain more values than the message.
    let rawMessageObject: AirshipJSON

    init(
        title: String,
        id: String,
        extra: [String: String],
        bodyURL: URL,
        expirationDate: Date?,
        messageReporting: [String: Any]?,
        unread: Bool,
        sentDate: Date,
        messageURL: URL,
        rawMessageObject: [String: Any]
    ) {
        self.title = title
        self.id = id
        self.extra = extra
        self.bodyURL = bodyURL
        self.expirationDate = expirationDate
        self.messageReporting = try? AirshipJSON.wrap(messageReporting)
        self.unread = unread
        self.sentDate = sentDate
        self.messageURL = messageURL
        self.rawMessageObject = (try? AirshipJSON.wrap(rawMessageObject))  ?? AirshipJSON.null
    }

    public override func isEqual(_ object: Any?) -> Bool {

        guard
            let object = object as? MessageCenterMessage,
            self.title == object.title,
            self.id == object.id,
            self.bodyURL == object.bodyURL,
            self.expirationDate == object.expirationDate,
            self.unread == object.unread,
            self.sentDate == object.sentDate,
            self.messageURL == object.messageURL,
            self.extra == object.extra,
            self.messageReporting == object.messageReporting,
            self.rawMessageObject == object.rawMessageObject
        else {
            return false
        }

        return true
    }
}

extension MessageCenterMessage {

    /// The list icon of the message. `nil` if there is none.
    @objc
    public var listIcon: String? {
        guard
            let rawMessage = self.rawMessageObject.unWrap() as? [String: Any],
            let icons = rawMessage["icons"] as? [String: String],
            let listIcon = icons["list_icon"]
        else {
            return nil
        }
            
        return listIcon
    }

    /// The subtitle of the message. `nil` if there is none.
    @objc
    public var subtitle: String? {
        return self.extra["com.urbanairship.listing.field1"]
    }

    /// Parses the message ID.
    /// - Parameters:
    ///     - userInfo: The notification user info.
    /// - Returns: The message ID.
    @objc
    public static func parseMessageID(userInfo: [AnyHashable: Any]) -> String? {
        guard let uamid = userInfo["_uamid"] else {
            return nil
        }

        if let uamid = uamid as? [String] {
            return uamid.first
        } else if let uamid = uamid as? String {
            return uamid
        } else {
            return nil
        }
    }

    /// Tells if the message is expired.
    /// `true` if the message is expired, otherwise `false`.
    @objc
    public var isExpired: Bool {
        if let messageExpiration = self.expirationDate {
            let result = messageExpiration.compare(AirshipDate().now)
            return (result == .orderedAscending || result == .orderedSame)
        }
        return false
    }
}
