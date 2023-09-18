/* Copyright Airship and Contributors */

import Foundation
import SwiftUI

private struct OrientationKey: EnvironmentKey {
    static let defaultValue: Orientation? = nil
}

private struct WindowSizeKey: EnvironmentKey {
    static let defaultValue: WindowSize? = nil
}

private struct VisibleEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct LayoutStateEnvironmentKey: EnvironmentKey {
    static let defaultValue: LayoutState = LayoutState.empty
}

extension EnvironmentValues {
    var orientation: Orientation? {
        get { self[OrientationKey.self] }
        set { self[OrientationKey.self] = newValue }
    }

    var windowSize: WindowSize? {
        get { self[WindowSizeKey.self] }
        set { self[WindowSizeKey.self] = newValue }
    }

    var isVisible: Bool {
        get { self[VisibleEnvironmentKey.self] }
        set { self[VisibleEnvironmentKey.self] = newValue }
    }

    var layoutState: LayoutState {
        get { self[LayoutStateEnvironmentKey.self] }
        set { self[LayoutStateEnvironmentKey.self] = newValue }
    }

}

extension View {
    func setVisible(_ visible: Bool) -> some View {
        environment(\.isVisible, visible)
    }
}
