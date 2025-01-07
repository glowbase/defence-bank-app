//
//  WeeklyDebitGraphView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 6/1/2025.
//

import SwiftUI
import Charts

struct WeeklyDebitGraphView: View {
    @State private var transactions: [Transaction] = []
    @State private var isLoading = true
    @State var accounts: [Account] = []

    var body: some View {
        VStack {
            Text("Debited Amounts Over the Last Week")
                .font(.headline)
            
            // Create the chart using the Swift Charts framework
            Chart(groupedTransactions().prefix(7), id: \.date) { transaction in
                LineMark(
                    x: .value("Date", transaction.date),
                    y: .value("Amount", transaction.total)
                )
                .foregroundStyle(.blue) // Line color
                .lineStyle(StrokeStyle(lineWidth: 2)) // Line width
                .symbol(.circle) // Symbol at each point
                .symbolSize(10)  // Size of the symbol
            }
            .padding()
            .frame(height: 300)
            
            if isLoading {
                ProgressView()
            }
        }
        .onAppear {
            loadData()
        }
        .padding()
    }

    func groupedTransactions() -> [(date: String, total: Double)] {
        // Group by date (ignoring time)
        let grouped = Dictionary(grouping: transactions) { transaction -> String in
            if let parsedDate = parseDate(transaction.CreateDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"  // Only the date part (no time)
                return dateFormatter.string(from: parsedDate)
            }
            return ""  // Return an empty string for invalid dates
        }

        // Sort the groups by date and reverse the order (from most recent to oldest)
        return grouped.keys.sorted().reversed().map { date in
            // Filter transactions for this date
            let transactions = grouped[date]!

            // Calculate the total debited amount for this group
            let totalDebited = transactions.reduce(0) { $0 + $1.DebitAmount }

            return (date: date, total: totalDebited)
        }
    }

    // Parse date string into Date object
    func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)
    }

    // Load transaction data
    func loadData() {
        Task {
            
//            transactions = await getTransactions(account_number: account_number)
            isLoading = false
        }
    }
}


#Preview {
    WeeklyDebitGraphView(accounts: accountsPreviewData)
}
