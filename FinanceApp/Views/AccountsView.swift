import SwiftUI

struct AccountsView: View {
    @ObservedObject var vm: AccountsViewModel
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            List(vm.accounts) { account in
                NavigationLink(destination: AccountDetailView(account: account, vm: vm)) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: account.type.icon).foregroundColor(.blue)
                            Text(account.name).font(.headline)
                            Spacer()
                            Text(account.type.displayName).font(.caption).foregroundColor(.secondary)
                        }
                        HStack {
                            Text(String(format: "$%.2f", account.currentBalance)).font(.subheadline.bold())
                            Spacer()
                            if account.targetAmount > 0 {
                                Text(String(format: "Goal: $%.0f", account.targetAmount)).font(.caption).foregroundColor(.secondary)
                            }
                        }
                        if account.targetAmount > 0 { ProgressView(value: account.progress).tint(.blue) }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Vaults")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button { showAdd = true } label: { Image(systemName: "plus") } } }
            .sheet(isPresented: $showAdd) { AddAccountView(vm: vm) }
        }
    }
}
