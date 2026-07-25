import Combine
import Foundation
import WatchConnectivity

@MainActor
final class WatchHabitStore: NSObject, ObservableObject {
    @Published private(set) var habits: [Habit] = Habit.starterHabits

    private let storageKey = "phone-watch-test.watch.habits"
    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    override init() {
        super.init()

        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? HabitCodec.decode(data) {
            habits = saved
        }

        session?.delegate = self
        session?.activate()

        if let data = session?.receivedApplicationContext["habits"] as? Data {
            apply(data)
        }
    }

    func toggle(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].toggle()
        persist()

        let payload: [String: Any] = [
            "action": "toggle",
            "habitID": id.uuidString
        ]

        if session?.isReachable == true {
            session?.sendMessage(payload, replyHandler: nil) { [weak self] _ in
                self?.session?.transferUserInfo(payload)
            }
        } else {
            session?.transferUserInfo(payload)
        }
    }

    private func apply(_ data: Data) {
        guard let received = try? HabitCodec.decode(data) else { return }
        habits = received
        persist()
    }

    private func persist() {
        guard let data = try? HabitCodec.encode(habits) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

extension WatchHabitStore: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

    nonisolated func sessionDidDeactivate(_ session: WCSession) {}

    nonisolated func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        guard let data = applicationContext["habits"] as? Data else { return }
        Task { @MainActor [weak self] in
            self?.apply(data)
        }
    }
}
