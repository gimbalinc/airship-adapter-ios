/* Copyright Airship and Contributors */

import Combine
import Foundation

class ThomasEnvironment: ObservableObject {
    private let delegate: ThomasDelegate
    let extensions: ThomasExtensions?
    let imageLoader: AirshipImageLoader


    let defaultFormState = FormState(identifier: "",
                                     formType: .form,
                                     formResponseType: "")

    let defaultViewState = ViewState()

    let defaultPagerState = PagerState(identifier: "")



    var isDismissed = false
    @Published
    var focusedID: String? = nil
    private var onDismiss: (() -> Void)

    private var subscriptions: Set<AnyCancellable> = Set()

    @Published private(set) var keyboardHeight: Double = 0
    @Published private(set) var keyboardState: KeyboardState = .hidden

    @MainActor
    init(
        delegate: ThomasDelegate,
        extensions: ThomasExtensions?,
        onDismiss: @escaping () -> Void
    ) {
        self.delegate = delegate
        self.extensions = extensions
        self.onDismiss = onDismiss
        self.imageLoader = AirshipImageLoader(
            imageProvider: extensions?.imageProvider
        )

        #if !os(tvOS) && !os(watchOS)
        self.subscribeKeyboard()
        #endif
    }

    func submitForm(_ formState: FormState, layoutState: LayoutState) {
        guard !formState.isSubmitted else {
            return
        }

        self.delegate.onFormSubmitted(
            formResult: formState.toFormResult(),
            layoutContext: layoutState.toLayoutContext()
        )

        let channelEditor = Airship.channel.editAttributes()
        let contactEditor = Airship.contact.editAttributes()

        formState.data.attributes()
            .forEach {
                let attributeName = $0.0
                let attributeValue = $0.1

                if let attribute = attributeName.channel {
                    channelEditor.set(
                        attributeValue: attributeValue,
                        attribute: attribute
                    )
                }

                if let attribute = attributeName.contact {
                    contactEditor.set(
                        attributeValue: attributeValue,
                        attribute: attribute
                    )
                }
            }

        channelEditor.apply()
        contactEditor.apply()
    }

    func formDisplayed(_ formState: FormState, layoutState: LayoutState) {
        self.delegate.onFormDisplayed(
            formInfo: formState.toFormInfo(),
            layoutContext: layoutState.toLayoutContext()
        )
    }

    func buttonTapped(
        buttonIdentifier: String,
        reportingMetatda: Any?,
        layoutState: LayoutState
    ) {
        self.delegate.onButtonTapped(
            buttonIdentifier: buttonIdentifier,
            metadata: reportingMetatda,
            layoutContext: layoutState.toLayoutContext()
        )
    }

    func pageViewed(_ pagerState: PagerState, layoutState: LayoutState) {
        self.delegate.onPageViewed(
            pagerInfo: pagerState.toPagerInfo(),
            layoutContext: layoutState.toLayoutContext()
        )
    }

    func dismiss(
        buttonIdentifier: String,
        buttonDescription: String,
        cancel: Bool,
        layoutState: LayoutState
    ) {
        tryDismiss {
            self.delegate.onDismissed(
                buttonIdentifier: buttonIdentifier,
                buttonDescription: buttonDescription,
                cancel: cancel,
                layoutContext: layoutState.toLayoutContext()
            )
        }
    }

    func dismiss(layoutState: LayoutState? = nil) {
        tryDismiss {
            self.delegate.onDismissed(
                layoutContext: layoutState?.toLayoutContext()
            )
        }
    }

    func timedOut(layoutState: LayoutState? = nil) {
        tryDismiss {
            self.delegate.onTimedOut(
                layoutContext: layoutState?.toLayoutContext()
            )
        }
    }
    
    func pageGesture(
        identifier: String?,
        reportingMetatda: Any?,
        layoutState: LayoutState
    ) {
        if let identifier {
            self.delegate.onPageGesture(
                identifier: identifier,
                metadata: reportingMetatda,
                layoutContext: layoutState.toLayoutContext()
            )
        }
    }
    
    func pageAutomated(
        identifier: String?,
        reportingMetatda: Any?,
        layoutState: LayoutState
    ) {
        if let identifier {
            self.delegate.onPageAutomatedAction(
                identifier: identifier,
                metadata: reportingMetatda,
                layoutContext: layoutState.toLayoutContext()
            )
        }
    }
    
    func pageSwiped(
        _ pagerState: PagerState,
        fromIndex: Int,
        toIndex: Int,
        layoutState: LayoutState
    ) {
        self.delegate.onPageSwiped(
            from: pagerState.toPagerInfo(index: fromIndex),
            to: pagerState.toPagerInfo(index: toIndex),
            layoutContext: layoutState.toLayoutContext()
        )
    }

    private func tryDismiss(callback: () -> Void) {
        if !self.isDismissed {
            self.isDismissed = true
            callback()
            onDismiss()
        }
    }

    func runActions(_ actionsPayload: ActionsPayload?, layoutState: LayoutState)
    {
        guard let actionsPayload = actionsPayload else {
            return
        }

        let layoutContext = layoutState.toLayoutContext()

        let permissionReceiver: @Sendable (
            AirshipPermission,
            AirshipPermissionStatus,
            AirshipPermissionStatus
        ) -> Void = { permission, start, end in
            self.delegate.onPromptPermissionResult(
                permission: permission,
                startingStatus: start,
                endingStatus: end,
                layoutContext: layoutContext
            )
        }
        
        Task {
            await ActionRunner.run(
                actionsPayload: actionsPayload.value,
                situation: .manualInvocation,
                metadata: [
                    PromptPermissionAction.resultReceiverMetadataKey: permissionReceiver
                ]
            )
        }
    }

    #if !os(tvOS) && !os(watchOS)
    @MainActor
    private func subscribeKeyboard() {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(
                    for: UIResponder.keyboardWillShowNotification
                )
                .map {
                    $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                        as? CGRect
                        ?? CGRect.zero
                }
                .map { Double($0.height) },
            NotificationCenter.default
                .publisher(
                    for: UIResponder.keyboardWillHideNotification
                )
                .map { _ in 0.0 }
        )
        .subscribe(on: DispatchQueue.main)
        .assign(to: \.self.keyboardHeight, on: self)
        .store(in: &self.subscriptions)

        Publishers.Merge3(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardDidShowNotification)
                .map { _ in
                    return KeyboardState.visible
                },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { notification in
                    let duration =
                        notification.userInfo?[
                            UIResponder.keyboardAnimationDurationUserInfoKey
                        ] as? Double
                    return KeyboardState.displaying(duration ?? 0.25)
                },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardDidHideNotification)
                .map { _ in
                    return KeyboardState.hidden
                }
        )
        .removeDuplicates()
        .subscribe(on: DispatchQueue.main)
        .assign(to: \.self.keyboardState, on: self)
        .store(in: &self.subscriptions)
    }

    #endif
}

enum DismissReason {
    case button(String, Bool)
    case timedOut
    case other
}

extension FormState {
    fileprivate func toFormInfo() -> ThomasFormInfo {
        ThomasFormInfo(
            identifier: self.identifier,
            submitted: self.isSubmitted,
            formType: self.formTypeString,
            formResponseType: self.formResponseType
        )
    }

    fileprivate var formTypeString: String {
        switch self.formType {
        case .form:
            return "form"
        case .nps(_):
            return "nps"
        }
    }

    fileprivate func toFormResult() -> ThomasFormResult {
        return ThomasFormResult(
            identifier: self.identifier,
            formData: self.data.toPayload() ?? [:]
        )

    }
}

extension PagerState {
    fileprivate func toPagerInfo(index: Int? = nil) -> ThomasPagerInfo {
        let index = index ?? self.pageIndex
        var pageId: String = ""
        if index < self.pages.count {
            pageId = self.pages[index].identifier
        }

        return ThomasPagerInfo(
            identifier: self.identifier,
            pageIndex: index,
            pageIdentifier: pageId,
            pageCount: self.pages.count,
            completed: self.completed
        )
    }
}

extension ButtonState {
    fileprivate func toButtonInfo() -> ThomasButtonInfo {
        return ThomasButtonInfo(identifier: self.identifier)
    }
}

extension LayoutState {
    fileprivate func toLayoutContext() -> ThomasLayoutContext {
        ThomasLayoutContext(
            formInfo: self.formState?.toFormInfo(),
            pagerInfo: self.pagerState?.toPagerInfo(),
            buttonInfo: self.buttonState?.toButtonInfo()
        )
    }
}

extension AttributesEditor {
    fileprivate func set(attributeValue: AttributeValue, attribute: String) {
        switch attributeValue {
        case .string(let value):
            self.set(string: value, attribute: attribute)

        case .number(let value):
            self.set(double: value, attribute: attribute)
        }
    }
}

enum KeyboardState: Equatable {
    case hidden
    case displaying(Double)
    case visible
}
