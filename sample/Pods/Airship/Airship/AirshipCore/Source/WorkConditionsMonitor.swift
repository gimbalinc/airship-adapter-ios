import Combine

struct WorkConditionsMonitor: @unchecked Sendable {
    private let cancellable: AnyCancellable
    private let conditionsSubject = PassthroughSubject<Void, Never>()
    private let networkMonitor: NetworkMonitor

    init(
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.networkMonitor = networkMonitor
        self.cancellable = Publishers.CombineLatest(
            NotificationCenter.default.publisher(
                for: AppStateTracker.didBecomeActiveNotification
            ),
            NotificationCenter.default.publisher(
                for: AppStateTracker.didEnterBackgroundNotification
            )
        )
        .sink { [conditionsSubject] _ in
            conditionsSubject.send()
        }
        
        networkMonitor.connectionUpdates = { [conditionsSubject] _ in
            conditionsSubject.send()
        }
    }

    @MainActor
    func checkConditions(workRequest: AirshipWorkRequest) -> Bool {
        if workRequest.requiresNetwork == true {
            return networkMonitor.isConnected
        }

        return true
    }

    @MainActor
    private func waitConditionsUpdate() async {
        return await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable? = nil
            cancellable = self.conditionsSubject
                .first()
                .sink { _ in
                    continuation.resume()
                    cancellable?.cancel()
                }
        }
    }

    @MainActor
    func awaitConditions(workRequest: AirshipWorkRequest) async {
        while checkConditions(workRequest: workRequest) == false {
            await waitConditionsUpdate()
        }
    }
}
