import SwiftUI
struct AddAccountView: View {
    @ObservedObject var vm: AccountsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var type = AccountType.sinkingFund
    @State private var target = ""
    var body: some View {
        NavigationStack {
            Form {
                Section { TextField("Vault Name", text: $name) }
                Section { Picker("Type", selection: $type) { ForEach(AccountType.allCases, id: \.self) { Text($0.displayName) } }.pickerStyle(.segmented) }
                Section { HStack { Text("$"); TextField("Target Amount", text: $target).keyboardType(.decimalPad) } }
            }
            .navigationTitle("New Vault")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { Task { await vm.addAccount(name: name, type: type, target: Double(target) ?? 0); dismiss() } }
                        .disabled(name.isEmpty)
                }
            }
        }
    }
}
