import SwiftUI
struct ContentView: View {
    @StateObject private var vm = AccountsViewModel()
    var body: some View {
        TabView {
            DashboardView(vm: vm).tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }
            AccountsView(vm: vm).tabItem { Label("Vaults", systemImage: "lock.shield.fill") }
            TransactionsView(vm: vm).tabItem { Label("Income", systemImage: "arrow.down.circle.fill") }
        }
        .task { await vm.load() }
    }
}
