import SwiftUI

struct AccountDetailView: View {
    let account: Account
    @ObservedObject var vm: AccountsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false
    @State private var showDeleteConfirm = false
    @State private var showLogIncome = false

    var accountTransactions: [Transaction] {
        vm.transactions.filter { $0.accountRef == account.id }
    }

    var body: some View {
        List {
            Section("Balance") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Current Balance").font(.caption).foregroundColor(.secondary)
                            Text(String(format: "$%.2f", account.currentBalance)).font(.largeTitle.bold())
                        }
                        Spacer()
                        Image(systemName: account.type.icon).font(.system(size: 32)).foregroundColor(.blue)
                    }
                    if account.targetAmount > 0 {
                        ProgressView(value: account.progress).tint(.blue)
                        Text("\(Int(account.progress * 100))% of $\(String(format: "%.0f", account.targetAmount)) goal")
                            .font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
                LabeledContent("Type", value: account.type.displayName)
            }

            Section {
                Button { showLogIncome = true } label: {
                    Label("Log Income", systemImage: "plus.circle.fill").foregroundColor(.green)
                }
            }

            Section("Transactions") {
                if accountTransactions.isEmpty {
                    Text("No transactions yet").foregroundColor(.secondary)
                } else {
                    ForEach(accountTransactions) { txn in
                        HStack {
                            Image(systemName: txn.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                .foregroundColor(txn.type == .income ? .green : .red)
                            VStack(alignment: .leading) {
                                Text(txn.description).font(.subheadline)
                                Text(txn.date).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: "$%.2f", txn.amount))
                                if txn.taxWithholding > 0 {
                                    Text(String(format: "Tax: $%.2f", txn.taxWithholding)).font(.caption2).foregroundColor(.orange)
                                }
                            }
                        }
                    }
                    .onDelete { idx in
                        Task {
                            for i in idx { await vm.deleteTransaction(transactionId: accountTransactions[i].id) }
                        }
                    }
                }
            }
        }
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { showEdit = true } label: { Image(systemName: "pencil") }
                Button(role: .destructive) { showDeleteConfirm = true } label: { Image(systemName: "trash") }
            }
        }
        .sheet(isPresented: $showEdit) { EditAccountView(vm: vm, account: account) }
        .sheet(isPresented: $showLogIncome) { LogIncomeView(vm: vm, preselectedAccountId: account.id) }
        .confirmationDialog("Delete \(account.name)?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { Task { await vm.deleteAccount(accountId: account.id); dismiss() } }
            Button("Cancel", role: .cancel) {}
        } message: { Text("This will permanently delete this vault.") }
    }
}
