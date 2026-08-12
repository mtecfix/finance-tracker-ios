import Foundation
@MainActor class AccountsViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    var totalBalance: Double { accounts.reduce(0) { $0 + $1.currentBalance } }
    var taxReserve: Double { accounts.filter { $0.type == .taxReserve }.reduce(0) { $0 + $1.currentBalance } }
    func load() async {
        isLoading = true; error = nil
        async let a = APIService.shared.getAccounts()
        async let t = APIService.shared.getTransactions()
        do { (accounts, transactions) = try await (a, t) }
        catch { self.error = error.localizedDescription }
        isLoading = false
    }
    func addAccount(name: String, type: AccountType, target: Double) async {
        do { let a = try await APIService.shared.createAccount(.init(name: name, type: type, targetAmount: target)); accounts.insert(a, at: 0) }
        catch { self.error = error.localizedDescription }
    }
    func logIncome(amount: Double, description: String, accountId: String) async {
        let r = CreateTransactionRequest(accountId: accountId, type: .income, amount: amount, description: description, category: "income", date: nil)
        do { let t = try await APIService.shared.createTransaction(r); transactions.insert(t, at: 0) }
        catch { self.error = error.localizedDescription }
    }
}
