import SwiftUI

struct FinanceChartsView: View {
    @ObservedObject var vm: AccountsViewModel

    var incomeByMonth: [(String, Double)] {
        var monthly: [String: Double] = [:]
        for txn in vm.transactions where txn.type == .income {
            let month = String(txn.date.prefix(7))
            monthly[month, default: 0] += txn.amount
        }
        return monthly.sorted { $0.key < $1.key }.suffix(6).map { ($0.key, $0.value) }
    }

    var expenseByCategory: [(String, Double)] {
        var cats: [String: Double] = [:]
        for txn in vm.transactions where txn.type == .expense {
            cats[txn.category, default: 0] += txn.amount
        }
        return cats.sorted { $0.value > $1.value }
    }

    var totalTaxWithheld: Double { vm.transactions.reduce(0) { $0 + $1.taxWithholding } }
    var totalIncome: Double { vm.transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount } }
    var totalExpenses: Double { vm.transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount } }

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    HStack {
                        StatCard(title: "Income", value: totalIncome, color: .green)
                        StatCard(title: "Expenses", value: totalExpenses, color: .red)
                        StatCard(title: "Tax Reserved", value: totalTaxWithheld, color: .orange)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 8)
                }

                Section("Income by Month") {
                    if incomeByMonth.isEmpty {
                        Text("No income logged yet").foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 8) {
                            let maxVal = incomeByMonth.map { $0.1 }.max() ?? 1
                            ForEach(incomeByMonth, id: \.0) { month, amount in
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(month).font(.caption).foregroundColor(.secondary)
                                        Spacer()
                                        Text(String(format: "$%.0f", amount)).font(.caption.bold())
                                    }
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.green.opacity(0.7))
                                            .frame(width: geo.size.width * CGFloat(amount / maxVal), height: 20)
                                    }
                                    .frame(height: 20)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Spending by Category") {
                    if expenseByCategory.isEmpty {
                        Text("No expenses logged yet").foregroundColor(.secondary)
                    } else {
                        let total = expenseByCategory.reduce(0) { $0 + $1.1 }
                        ForEach(expenseByCategory, id: \.0) { cat, amount in
                            HStack {
                                Text(cat.capitalized).font(.subheadline)
                                Spacer()
                                Text(String(format: "$%.2f", amount)).font(.subheadline)
                                Text(String(format: "(%.0f%%)", total > 0 ? amount/total*100 : 0))
                                    .font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section("Net Position") {
                    let net = totalIncome - totalExpenses
                    HStack {
                        Text("Net Income").font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", net))
                            .font(.headline.bold())
                            .foregroundColor(net >= 0 ? .green : .red)
                    }
                }
            }
            .navigationTitle("Charts & Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await vm.load() }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: Double
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(String(format: "$%.0f", value)).font(.subheadline.bold()).foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(color.opacity(0.08))
        .cornerRadius(8)
        .padding(.horizontal, 4)
    }
}
