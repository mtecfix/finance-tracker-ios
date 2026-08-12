import SwiftUI

struct ContentView: View {
    @StateObject private var vm   = AccountsViewModel()
    @StateObject private var auth = AuthService.shared
    @StateObject private var notif = NotificationManager.shared
    var body: some View {
        if auth.isAuthenticated {
            TabView {
                DashboardView(vm: vm).tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }
                AccountsView(vm: vm).tabItem { Label("Vaults", systemImage: "lock.shield.fill") }
                TransactionsView(vm: vm).tabItem { Label("Income", systemImage: "arrow.down.circle.fill") }
                FinanceChartsView(vm: vm).tabItem { Label("Charts", systemImage: "chart.bar.fill") }
            }
            .task { await vm.load() }
        } else {
            LoginView()
        }
    }
}
