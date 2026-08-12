import SwiftUI

@main struct FinanceApp: App {
    @StateObject private var notif = NotificationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { Task { await notif.requestPermission() } }
        }
    }
}
