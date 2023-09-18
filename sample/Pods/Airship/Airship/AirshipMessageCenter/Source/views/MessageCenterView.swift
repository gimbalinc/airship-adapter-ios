/* Copyright Urban Airship and Contributors */

import Combine
import Foundation
import SwiftUI

#if canImport(AirshipCore)
import AirshipCore
#endif

/// Message Center View
public struct MessageCenterView: View {

    /// The message center state
    @ObservedObject
    private var controller: MessageCenterController

    @Environment(\.messageCenterDismissAction)
    private var dismissAction: (() -> Void)?

    @Environment(\.airshipMessageCenterTheme)
    private var theme

    @State
    var editMode: EditMode = .inactive

    /// Default constructor
    /// - Parameters:
    ///     - controller: Controls navigation within the view
    public init(controller: MessageCenterController) {
        self.controller = controller
    }

    @ViewBuilder
    private func makeBackButton() -> some View {
        Button(action: {
            self.dismissAction?()
        }) {
            Image(systemName: "chevron.backward")
                .scaleEffect(0.68)
                .font(Font.title.weight(.medium))
                .foregroundColor(theme.backButtonColor)
        }
    }

    @ViewBuilder
    public var body: some View {
        let content = MessageCenterListView(
            controller: self.controller
        )
        .applyIf(self.dismissAction != nil) { view in
            view.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    makeBackButton()
                }
            }
        }
        .environment(\.editMode, $editMode)
        .navigationTitle(
            theme.navigationBarTitle ?? "ua_message_center_title".messageCenterlocalizedString
        )

        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}


private struct MessageCenterDismissActionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}


extension EnvironmentValues {
    var messageCenterDismissAction: (() -> Void)? {
        get { self[MessageCenterDismissActionKey.self] }
        set { self[MessageCenterDismissActionKey.self] = newValue }
    }
}


extension View {
    func addMessageCenterDismissAction(action: (() -> Void)?) -> some View {
        environment(\.messageCenterDismissAction, action)
    }
}
