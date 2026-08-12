import Foundation
enum TransactionType: String, Codable, CaseIterable {
    case income = "income"
    case expense = "expense"
    case allocation = "allocation"
}
struct Transaction: Codable, Identifiable {
    let id: String
    let userId: String
    var accountRef: String
    var type: TransactionType
    var amount: Double
    var description: String
    var category: String
    var taxWithholding: Double
    var date: String
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id = "RecordId", userId = "UserId"
        case accountRef, type, amount, description, category, taxWithholding, date, createdAt
    }
}
struct CreateTransactionRequest: Codable {
    let accountId: String
    let type: TransactionType
    let amount: Double
    let description: String
    let category: String
    let date: String?
}
