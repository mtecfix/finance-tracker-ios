import SwiftUI
struct DashboardView: View {
    @ObservedObject var vm: AccountsViewModel
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Balance").font(.caption).foregroundColor(.secondary)
                                Text("$\(vm.totalBalance, specifier: "%.2f")").font(.largeTitle.bold())
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Tax Reserve").font(.caption).foregroundColor(.secondary)
                                Text("$\(vm.taxReserve, specifier: "%.2f")").font(.title2.bold()).foregroundColor(.orange)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                Section("Vaults") {
                    ForEach(vm.accounts) { account in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: account.type.icon).foregroundColor(.blue)
                                Text(account.name).font(.headline)
                                Spacer()
                                Text("$\(account.currentBalance, specifier: "%.2f")").font(.subheadline.bold())
                            }
                            if account.targetAmount > 0 {
                                ProgressView(value: account.progress)
                                    .tint(.blue)
                                Text("\(Int(account.progress * 100))% of $\(account.targetAmount, specifier: "%.0f") goal")
                                    .font(.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                Section("Recent Transactions") {
                    ForEach(vm.transactions.prefix(5)) { txn in
                        HStack {
                            Image(systemName: txn.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                .foregroundColor(txn.type == .income ? .green : .red)
                            VStack(alignment: .leading) {
                                Text(txn.description).font(.subheadline)
                                Text(txn.date).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(txn.type == .income ? "+" : "-")$\(txn.amount, specifier: "%.2f")")
                                    .foregroundColor(txn.type == .income ? .green : .red)
                                if txn.taxWithholding > 0 {
                                    Text("Tax: $\(txn.taxWithholding, specifier: "%.2f")").font(.caption2).foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Finance Dashboard")
            .refreshable { await vm.load() }
        }
    }
}
