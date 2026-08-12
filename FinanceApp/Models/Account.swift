import Foundation
enum AccountType: String, Codable, CaseIterable {
    case sinkingFund   = "sinking_fund"
    case incomeVault   = "income_vault"
    case taxReserve    = "tax_reserve"
    case rsuTracker    = "rsu_tracker"
    var displayName: String {
        switch self {
        case .sinkingFund:  return "Sinking Fund"
        case .incomeVault:  return "Income Vault"
        case .taxReserve:   return "Tax Reserve"
        case .rsuTracker:   return "RSU Tracker"
        }
    }
    var icon: String {
        switch self {
        case .sinkingFund:  return "drop.fill"
        case .incomeVault:  return "lock.shield.fill"
        case .taxReserve:   return "percent"
        case .rsuTracker:   return "chart.line.uptrend.xyaxis"
        }
    }
}
struct Account: Codable, Identifiable {
    let id: String
    let userId: String
    var name: String
    var type: AccountType
    var targetAmount: Double
    var currentBalance: Double
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id = "ItemId", userId = "UserId"
        case name, type, targetAmount, currentBalance, createdAt
    }
    var progress: Double { targetAmount > 0 ? min(currentBalance / targetAmount, 1.0) : 0 }
}
struct CreateAccountRequest: Codable {
    let name: String
    let type: AccountType
    let targetAmount: Double
}
