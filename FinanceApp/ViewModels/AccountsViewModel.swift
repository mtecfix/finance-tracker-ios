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

    func updateAccount(accountId: String, name: String, targetAmount: Double, currentBalance: Double) async throws {
        try await APIService.shared.updateAccount(accountId: accountId, name: name, targetAmount: targetAmount, currentBalance: currentBalance)
        if let idx = accounts.firstIndex(where: { $0.id == accountId }) {
            accounts[idx].name = name; accounts[idx].targetAmount = targetAmount; accounts[idx].currentBalance = currentBalance
        }
    }

    func deleteAccount(accountId: String) async {
        do { try await APIService.shared.deleteAccount(accountId: accountId); accounts.removeAll { $0.id == accountId } }
        catch { self.error = error.localizedDescription }
    }

    func logIncome(amount: Double, description: String, category: String, accountId: String) async {
        let r = CreateTransactionRequest(accountId: accountId, type: .income, amount: amount, description: description, category: category, date: nil)
        do {
            let t = try await APIService.shared.createTransaction(r)
            transactions.insert(t, at: 0)
            if let idx = accounts.firstIndex(where: { $0.id == accountId }) {
                accounts[idx].currentBalance += amount
            }
        } catch { self.error = error.localizedDescription }
    }

    func logExpense(amount: Double, description: String, category: String, accountId: String) async {
        let r = CreateTransactionRequest(accountId: accountId, type: .expense, amount: amount, description: description, category: category, date: nil)
        do {
            let t = try await APIService.shared.createTransaction(r)
            transactions.insert(t, at: 0)
            if let idx = accounts.firstIndex(where: { $0.id == accountId }) {
                accounts[idx].currentBalance -= amount
            }
        } catch { self.error = error.localizedDescription }
    }

    func deleteTransaction(transactionId: String) async {
        do { try await APIService.shared.deleteTransaction(transactionId: transactionId); transactions.removeAll { $0.id == transactionId } }
        catch { self.error = error.localizedDescription }
    }
}
