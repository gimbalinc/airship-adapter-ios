/* Copyright Airship and Contributors */

import Combine
import Foundation

/// Airship Channel protocol.
@objc(UAChannelProtocol)
public protocol BaseAirshipChannelProtocol: Sendable {
    /**
     * The Channel ID.
     */
    var identifier: String? { get }

    /**
     * Device tags
     */
    @objc
    var tags: [String] { get set }

    /**
     * Allows setting tags from the device. Tags can be set from either the server or the device, but
     * not both (without synchronizing the data), so use this flag to explicitly enable or disable
     * the device-side flags.
     *
     * Set this to `false` to prevent the device from sending any tag information to the server when using
     * server-side tagging. Defaults to `true`.
     */
    @objc
    var isChannelTagRegistrationEnabled: Bool { get set }

    /**
     * Edits channel tags.
     * - Returns: Tag editor.
     */
    @objc
    func editTags() -> TagEditor

    /**
     * Edits channel tags.
     * - Parameters:
     *   - editorBlock: The editor block with the editor. The editor will `apply` will be called after the block is executed.
     */
    @objc
    func editTags(_ editorBlock: (TagEditor) -> Void)

    /**
     * Edits channel tags groups.
     * - Returns: Tag group editor.
     */
    @objc
    func editTagGroups() -> TagGroupsEditor

    /**
     * Edits channel tag groups tags.
     * - Parameters:
     *   - editorBlock: The editor block with the editor. The editor will `apply` will be called after the block is executed.
     */
    @objc
    func editTagGroups(_ editorBlock: (TagGroupsEditor) -> Void)

    /**
     * Edits channel subscription lists.
     * - Returns: Subscription list editor.
     */
    @objc
    func editSubscriptionLists() -> SubscriptionListEditor

    /**
     * Edits channel subscription lists.
     * - Parameters:
     *   - editorBlock: The editor block with the editor. The editor will `apply` will be called after the block is executed.
     */
    @objc
    func editSubscriptionLists(_ editorBlock: (SubscriptionListEditor) -> Void)

    /**
     * Fetches current subscription lists.
     * - Returns: The subscription lists
     */
    @objc
    func fetchSubscriptionLists() async throws -> [String]

    /**
     * Edits channel attributes.
     * - Returns: Attribute editor.
     */
    @objc
    func editAttributes() -> AttributesEditor

    /**
     * Edits channel attributes.
     * - Parameters:
     *   - editorBlock: The editor block with the editor. The editor will `apply` will be called after the block is executed.
     */
    @objc
    func editAttributes(_ editorBlock: (AttributesEditor) -> Void)

    /**
     * Enables channel creation if channelCreationDelayEnabled was set to `YES` in the config.
     */
    @objc
    func enableChannelCreation()
}

public protocol AirshipChannelProtocol: BaseAirshipChannelProtocol {

}

// NOTE: For internal use only. :nodoc:
public protocol InternalAirshipChannelProtocol: AirshipChannelProtocol {
    func addRegistrationExtender(
        _ extender: @escaping (ChannelRegistrationPayload) async -> ChannelRegistrationPayload
    )

    /**
     * Updates channel registration if needed. Applications should not need to call this method.
     */
    func updateRegistration()

    // NOTE: For internal use only. :nodoc:
    func updateRegistration(forcefully: Bool)

    func clearSubscriptionListsCache()
}
