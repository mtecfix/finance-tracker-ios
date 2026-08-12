import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL, requestFailed(Int, String), decodingFailed(String)
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let c, let m): return "Error (\(c)): \(m)"
        case .decodingFailed(let m): return "Decode error: \(m)"
        }
    }
}

class APIService {
    static let shared = APIService()
    private let base = Config.apiEndpoint
    private var token: String? = nil
    func setToken(_ t: String) { token = t }

    private func req<T: Decodable>(_ path: String, method: String = "GET", body: Encodable? = nil) async throws -> T {
        guard let url = URL(string: "\(base)\(path)") else { throw APIError.invalidURL }
        var r = URLRequest(url: url)
        r.httpMethod = method
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let t = token { r.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization") }
        if let b = body { r.httpBody = try JSONEncoder().encode(b) }
        let (data, resp) = try await URLSession.shared.data(for: r)
        let code = (resp as! HTTPURLResponse).statusCode
        guard (200...299).contains(code) else { throw APIError.requestFailed(code, String(data: data, encoding: .utf8) ?? "") }
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw APIError.decodingFailed(error.localizedDescription) }
    }

    func getAccounts() async throws -> [Account] { struct R: Decodable { let accounts: [Account] }; return try await (req("/accounts") as R).accounts }
    func createAccount(_ a: CreateAccountRequest) async throws -> Account { struct R: Decodable { let account: Account }; return try await (req("/accounts", method: "POST", body: a) as R).account }
    func updateAccount(accountId: String, name: String, targetAmount: Double, currentBalance: Double) async throws {
        struct Body: Encodable { let name: String; let targetAmount: Double; let currentBalance: Double }
        struct R: Decodable { let updated: Bool }
        let enc = accountId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? accountId
        let _: R = try await req("/accounts/\(enc)", method: "PUT", body: Body(name: name, targetAmount: targetAmount, currentBalance: currentBalance))
    }
    func deleteAccount(accountId: String) async throws {
        struct R: Decodable { let deleted: Bool }
        let enc = accountId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? accountId
        let _: R = try await req("/accounts/\(enc)", method: "DELETE")
    }
    func getTransactions() async throws -> [Transaction] { struct R: Decodable { let transactions: [Transaction] }; return try await (req("/transactions") as R).transactions }
    func createTransaction(_ t: CreateTransactionRequest) async throws -> Transaction { struct R: Decodable { let transaction: Transaction }; return try await (req("/transactions", method: "POST", body: t) as R).transaction }
    func deleteTransaction(transactionId: String) async throws {
        struct R: Decodable { let deleted: Bool }
        let enc = transactionId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? transactionId
        let _: R = try await req("/transactions/\(enc)", method: "DELETE")
    }
}
