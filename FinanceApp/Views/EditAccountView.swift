import SwiftUI

struct EditAccountView: View {
    @ObservedObject var vm: AccountsViewModel
    let account: Account
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var target: String
    @State private var balance: String
    @State private var loading = false; @State private var error: String? = nil

    init(vm: AccountsViewModel, account: Account) {
        self.vm = vm; self.account = account
        _name    = State(initialValue: account.name)
        _target  = State(initialValue: String(account.targetAmount))
        _balance = State(initialValue: String(account.currentBalance))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section { TextField("Vault Name", text: $name) }
                Section("Amounts") {
                    HStack { Text("Target"); Spacer(); Text("$"); TextField("0", text: $target).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                    HStack { Text("Balance"); Spacer(); Text("$"); TextField("0", text: $balance).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                }
                if let e = error { Section { Text(e).foregroundColor(.red).font(.caption) } }
            }
            .navigationTitle("Edit Vault").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.disabled(name.isEmpty || loading)
                }
            }
        }
    }

    func save() {
        loading = true; error = nil
        Task {
            do {
                try await vm.updateAccount(accountId: account.id, name: name, targetAmount: Double(target) ?? 0, currentBalance: Double(balance) ?? 0)
                dismiss()
            } catch { self.error = error.localizedDescription }
            loading = false
        }
    }
}
