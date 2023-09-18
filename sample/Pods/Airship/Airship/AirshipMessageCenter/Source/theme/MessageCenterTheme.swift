/* Copyright Urban Airship and Contributors */

import Foundation
import SwiftUI
import UIKit

#if canImport(AirshipCore)
import AirshipCore
#endif

public enum SeparatorStyle {
    case none
    case singleLine
}

/// Model object representing a custom theme to be applied to the default message center.
///
/// To customise the message center theme:
///
///     MessageCenterView(
///         controller: messageCenterController
///     )
///     .messageCenterTheme(theme)
///
public struct MessageCenterTheme {

    /// The tint color of the "pull to refresh" control
    public var refreshTintColor: Color? = nil

    /// Whether icons are enabled. Defaults to `NO`.
    public var iconsEnabled: Bool = false

    /// An optional placeholder image to use when icons haven't fully loaded.
    public var placeholderIcon: Image? = nil

    /// The font to use for message cell titles.
    public var cellTitleFont: Font? = .headline

    /// The font to use for message cell dates.
    public var cellDateFont: Font? = .subheadline

    /// The regular color for message cells
    public var cellColor: Color? = nil

    /// The regular color for message cell titles.
    public var cellTitleColor: Color? = .primary

    /// The regular color for message cell dates.
    public var cellDateColor: Color? = .secondary

    /// The message cell separator style.
    public var cellSeparatorStyle: SeparatorStyle?

    /// The message cell separator color.
    public var cellSeparatorColor: Color? = Color(UIColor.separator)

    /// The message cell tint color.
    public var cellTintColor: Color? = nil

    /// The background color for the unread indicator.
    public var unreadIndicatorColor: Color? = nil

    /// The title color for the "Select All" button.
    public var selectAllButtonTitleColor: Color? = nil

    /// The title color for the "Delete" button.
    public var deleteButtonTitleColor: Color? = nil

    /// The title color for the "Mark Read" button.
    public var markAsReadButtonTitleColor: Color? = nil
    
    /// Whether the delete message button from the message view is enabled. Defaults to `NO`.
    public var hideDeleteButton: Bool? = false
    
    /// The title color for the "Edit" button.
    public var editButtonTitleColor: Color? = nil

    /// The title color for the "Cancel" button.
    public var cancelButtonTitleColor: Color? = nil

    /// The title color for the "Done" button.
    public var backButtonColor: Color? = nil

    /// The navigation bar title
    public var navigationBarTitle: String? = nil

    public init(refreshTintColor: Color? = nil, iconsEnabled: Bool = false, placeholderIcon: Image? = nil, cellTitleFont: Font? = nil, cellDateFont: Font? = nil, cellColor: Color? = nil, cellTitleColor: Color? = nil, cellDateColor: Color? = nil, cellSeparatorStyle: SeparatorStyle? = nil, cellSeparatorColor: Color? = nil, cellTintColor: Color? = nil, unreadIndicatorColor: Color? = nil, selectAllButtonTitleColor: Color? = nil, deleteButtonTitleColor: Color? = nil, markAsReadButtonTitleColor: Color? = nil, hideDeleteButton: Bool? = nil, editButtonTitleColor: Color? = nil, cancelButtonTitleColor: Color? = nil, backButtonColor: Color? = nil, navigationBarTitle: String? = nil) {
        self.refreshTintColor = refreshTintColor
        self.iconsEnabled = iconsEnabled
        self.placeholderIcon = placeholderIcon
        self.cellTitleFont = cellTitleFont
        self.cellDateFont = cellDateFont
        self.cellColor = cellColor
        self.cellTitleColor = cellTitleColor
        self.cellDateColor = cellDateColor
        self.cellSeparatorStyle = cellSeparatorStyle
        self.cellSeparatorColor = cellSeparatorColor
        self.cellTintColor = cellTintColor
        self.unreadIndicatorColor = unreadIndicatorColor
        self.selectAllButtonTitleColor = selectAllButtonTitleColor
        self.deleteButtonTitleColor = deleteButtonTitleColor
        self.markAsReadButtonTitleColor = markAsReadButtonTitleColor
        self.hideDeleteButton = hideDeleteButton
        self.editButtonTitleColor = editButtonTitleColor
        self.cancelButtonTitleColor = cancelButtonTitleColor
        self.backButtonColor = backButtonColor
        self.navigationBarTitle = navigationBarTitle
    }
}

extension View {
    /// Overrides the message center theme
    /// - Parameters:
    ///     - theme: The message center theme
    public func messageCenterTheme(_ theme: MessageCenterTheme) -> some View {
        environment(\.airshipMessageCenterTheme, theme)
    }
}

struct MessageCenterThemeKey: EnvironmentKey {
    static let defaultValue = MessageCenterTheme()
}

extension EnvironmentValues {
    /// Airship message center theme environment value
    public var airshipMessageCenterTheme: MessageCenterTheme {
        get { self[MessageCenterThemeKey.self] }
        set { self[MessageCenterThemeKey.self] = newValue }
    }
}

extension MessageCenterTheme {
    /// Loads a message center theme from a plist file
    /// - Parameters:
    ///     - plist: The name of the plist in the bundle
    public static func fromPlist(_ plist: String) throws -> MessageCenterTheme {
        return try MessageCenterThemeLoader.fromPlist(plist)
    }
}
