import SwiftUI
struct LogIncomeView: View {
    @ObservedObject var vm: AccountsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var amount = ""
    @State private var description = ""
    @State private var selectedAccount = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("Income") {
                    HStack { Text("$"); TextField("Amount", text: $amount).keyboardType(.decimalPad) }
                    TextField("Description (e.g. Client payment)", text: $description)
                }
                Section("Allocate to Vault") {
                    Picker("Vault", selection: $selectedAccount) {
                        Text("No vault").tag("")
                        ForEach(vm.accounts) { a in Text(a.name).tag(a.id) }
                    }
                }
                if let amt = Double(amount), amt > 0 {
                    Section("Tax Withholding (25%)") {
                        LabeledContent("Reserve", value: "$\(String(format: "%.2f", amt * 0.25))")
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Log Income")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Log") { Task { await vm.logIncome(amount: Double(amount) ?? 0, description: description, accountId: selectedAccount); dismiss() } }
                        .disabled(amount.isEmpty || description.isEmpty)
                }
            }
        }
    }
}
