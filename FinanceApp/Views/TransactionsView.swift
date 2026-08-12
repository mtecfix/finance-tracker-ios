import SwiftUI
struct TransactionsView: View {
    @ObservedObject var vm: AccountsViewModel
    @State private var showLog = false
    var body: some View {
        NavigationStack {
            List(vm.transactions) { txn in
                HStack {
                    Image(systemName: txn.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                        .foregroundColor(txn.type == .income ? .green : .red)
                    VStack(alignment: .leading) {
                        Text(txn.description).font(.headline)
                        Text("\(txn.category) · \(txn.date)").font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("$\(txn.amount, specifier: "%.2f")").font(.headline)
                        if txn.taxWithholding > 0 { Text("Tax: $\(txn.taxWithholding, specifier: "%.2f")").font(.caption2).foregroundColor(.orange) }
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button { showLog = true } label: { Image(systemName: "plus") } } }
            .sheet(isPresented: $showLog) { LogIncomeView(vm: vm) }
        }
    }
}
