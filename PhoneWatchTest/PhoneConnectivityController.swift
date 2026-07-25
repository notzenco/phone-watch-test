import Foundation
import WatchConnectivity

final class PhoneConnectivityController: NSObject, WCSessionDelegate {
    var onToggle: ((UUID) -> Void)?

    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    func activate() {
        session?.delegate = self
        session?.activate()
    }

    func send(habits: [Habit]) {
        guard let data = try? HabitCodec.encode(habits) else { return }
        try? session?.updateApplicationContext(["habits": data])
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        handle(message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        handle(userInfo)
    }

    private func handle(_ payload: [String: Any]) {
        guard payload["action"] as? String == "toggle",
              let rawID = payload["habitID"] as? String,
              let id = UUID(uuidString: rawID) else {
            return
        }
        onToggle?(id)
    }
}

