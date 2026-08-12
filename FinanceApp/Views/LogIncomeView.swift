import SwiftUI

struct LogIncomeView: View {
    @ObservedObject var vm: AccountsViewModel
    @Environment(\.dismiss) private var dismiss
    var preselectedAccountId: String = ""
    @State private var amount = ""; @State private var description = ""; @State private var category = "freelance"
    @State private var selectedAccount = ""; @State private var txType = TransactionType.income
    @State private var loading = false

    let categories = ["freelance","salary","gig","rsu","contract","rental","other"]
    let txTypes: [TransactionType] = [.income, .expense, .allocation]

    var body: some View {
        NavigationStack {
            Form {
                Section("Type") {
                    Picker("Type", selection: $txType) {
                        ForEach(txTypes, id: \.self) { Text($0.rawValue.capitalized) }
                    }.pickerStyle(.segmented)
                }
                Section(txType == .income ? "Income" : "Expense") {
                    HStack { Text("$"); TextField("Amount", text: $amount).keyboardType(.decimalPad) }
                    TextField("Description", text: $description)
                    Picker("Category", selection: $category) { ForEach(categories, id: \.self) { Text($0.capitalized) } }
                }
                Section("Vault") {
                    Picker("Vault", selection: $selectedAccount) {
                        Text("No vault").tag("")
                        ForEach(vm.accounts) { a in Text(a.name).tag(a.id) }
                    }
                }
                if txType == .income, let amt = Double(amount), amt > 0 {
                    Section("Tax Withholding (25%)") {
                        LabeledContent("Set aside", value: String(format: "$%.2f", amt * 0.25)).foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle(txType == .income ? "Log Income" : "Log Expense").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Log") {
                        Task {
                            let amt = Double(amount) ?? 0
                            if txType == .income {
                                await vm.logIncome(amount: amt, description: description, category: category, accountId: selectedAccount)
                            } else {
                                await vm.logExpense(amount: amt, description: description, category: category, accountId: selectedAccount)
                            }
                            dismiss()
                        }
                    }
                    .disabled(amount.isEmpty || description.isEmpty || loading)
                }
            }
            .onAppear { selectedAccount = preselectedAccountId }
        }
    }
}
