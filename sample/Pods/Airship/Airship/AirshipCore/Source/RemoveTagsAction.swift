/* Copyright Airship and Contributors */

/// Removes tags.
///
/// Expected argument values: `String` (single tag), `[String]` (single or multiple tags), or an object.
/// An example tag group JSON payload:
/// {
///     "channel": {
///         "channel_tag_group": ["channel_tag_1", "channel_tag_2"],
///         "other_channel_tag_group": ["other_channel_tag_1"]
///     },
///     "named_user": {
///         "named_user_tag_group": ["named_user_tag_1", "named_user_tag_2"],
///         "other_named_user_tag_group": ["other_named_user_tag_1"]
///     },
///     "device": [ "tag", "another_tag"]
/// }
///
/// Valid situations: `ActionSituation.foregroundPush`, `ActionSituation.launchedFromPush`
/// `ActionSituation.webViewInvocation`, `ActionSituation.foregroundInteractiveButton`,
/// `ActionSituation.backgroundInteractiveButton`, `ActionSituation.manualInvocation` and
/// `ActionSituation.automation`
public final class RemoveTagsAction: AirshipAction {

    /// Default names - "remove_tags_action", "^-t"
    public static let defaultNames = ["remove_tags_action", "^-t"]

    /// Default predicate - rejects foreground pushes with visible display options
    public static let defaultPredicate: @Sendable (ActionArguments) -> Bool = { args in
        return args.metadata[ActionArguments.isForegroundPresentationMetadataKey] as? Bool != true
    }

    private let channel: @Sendable () -> AirshipChannelProtocol
    private let contact: @Sendable () -> AirshipContactProtocol

    @objc
    public convenience init() {
        self.init(
            channel: Airship.componentSupplier(),
            contact: Airship.componentSupplier()
        )
    }

    init(
        channel: @escaping @Sendable () -> AirshipChannelProtocol,
        contact: @escaping @Sendable () -> AirshipContactProtocol
    ) {
        self.channel = channel
        self.contact = contact
    }


    public func accepts(arguments: ActionArguments) async -> Bool {
        guard arguments.situation != .backgroundPush else {
            return false
        }
        return true
    }

    public func perform(arguments: ActionArguments) async throws -> AirshipJSON? {
        let unwrapped = arguments.value.unWrap()
        if let tag = unwrapped as? String {
            channel().editTags { editor in
                editor.remove(tag)
            }
        } else if let tags = arguments.value.unWrap() as? [String] {
            channel().editTags { editor in
                editor.remove(tags)
            }
        } else if let args: TagsActionsArgs = try arguments.value.decode() {
            if let channelTagGroups = args.channel {
                channel().editTagGroups { editor in
                    channelTagGroups.forEach { group, tags in
                        editor.remove(tags, group: group)
                    }
                }
            }

            if let contactTagGroups = args.namedUser {
                contact().editTagGroups { editor in
                    contactTagGroups.forEach { group, tags in
                        editor.remove(tags, group: group)
                    }
                }
            }

            if let deviceTags = args.device {
                channel().editTags() { editor in
                    editor.remove(deviceTags)
                }
            }
        }
        return nil
    }
}

