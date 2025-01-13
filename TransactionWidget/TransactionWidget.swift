//
//  TransactionWidget.swift
//  TransactionWidget
//
//  Created by Cooper Beltrami on 12/1/2025.
//

import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct TransactionWidgetEntry: TimelineEntry {
    let date: Date
    let transaction: Transaction?
}

// MARK: - Widget Provider
struct TransactionWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TransactionWidgetEntry {
        TransactionWidgetEntry(
            date: Date(),
            transaction: transactionPreviewData
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TransactionWidgetEntry) -> Void) {
        let entry = TransactionWidgetEntry(
            date: Date(),
            transaction: transactionPreviewData
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TransactionWidgetEntry>) -> Void) {
        Task {
            // Fetch transactions for the default account
            let defaultAccount = UserDefaultsManager.shared.fetch(forKey: "default_account", type: Account.self)
            var transactions:[Transaction] = []
            
            transactions = await getTransactions(account_number: defaultAccount?.AccountNumber ?? "")

            // If it's not loaded the first time, it might be an expired cookie.
            if transactions.isEmpty {
                transactions = await getTransactions(account_number: defaultAccount?.AccountNumber ?? "")
            }
            
            // Extract the most recent valid transaction
            let mostRecentTransaction = getMostRecentTransaction(from: transactions)
            
            let entry = TransactionWidgetEntry(date: Date(), transaction: mostRecentTransaction)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            
            completion(timeline)
        }
    }
    
    func getMostRecentTransaction(from transactions: [Transaction]) -> Transaction? {
        // Filter transactions to exclude "TFR" or "Round Up" and only include debit amounts
        let filteredTransactions = transactions.filter { transaction in
            let description = transaction.Description?.lowercased() ?? ""
            let longDescription = transaction.LongDescription?.lowercased() ?? ""

            // Exclude transactions containing "TFR" or "Round Up" and ensure it's a debit transaction
            return transaction.DebitAmount > 0 && // Only include debit transactions
                   !description.contains("tfr") &&
                   !description.contains("round up") &&
                   !longDescription.contains("tfr") &&
                   !longDescription.contains("round up")
        }

        // Return the most recent transaction from the filtered list
        return filteredTransactions.sorted { t1, t2 in
            guard let date1 = ISO8601DateFormatter().date(from: t1.CreateDate),
                  let date2 = ISO8601DateFormatter().date(from: t2.CreateDate) else {
                return false
            }
            return date1 > date2
        }.first
    }

}

// MARK: - Widget View
struct TransactionWidgetView: View {
    var entry: TransactionWidgetEntry

    var body: some View {
        VStack(alignment: .leading) {
            if let transaction = entry.transaction {
                AsyncImage(url: URL(string: "https://images.lookwhoscharging.com/d2c7868b-c732-4f82-80cd-b867ae17e10a/Aldi-Stores-Summerhill-Shopping-Centre-logo-image.png"))
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text(transaction.MerchantName ?? "")
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .padding(.top, 4)
                    .bold()
                
                Spacer()
                
                Text(transaction.DebitAmount, format: .currency(code: "AUD"))
                    .foregroundColor(.accent)
                    .font(.title)

                Spacer()
                
                if let date = transaction.CreateDate.toDate() {
                    Text(date, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                Text("LAST TRANSACTION")
                    .foregroundColor(.accent)
                    .bold()
                    .font(.caption)
                
                Text("No transactions available.")
                    .font(.headline)
            }
        }
        .containerBackground(.widgetBackground, for: .widget)
    }
}

// MARK: - Date Formatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// MARK: - Widget Configuration
@main
struct LastTransactionWidget: Widget {
    let kind: String = "LastTransactionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TransactionWidgetProvider()) { entry in
            TransactionWidgetView(entry: entry)
        }
        .configurationDisplayName("Last Transaction")
        .description("Displays the most recent transaction for the default account.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Extensions
extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

extension Date {
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

struct TransactionWidget_Previews: PreviewProvider {
    static var previews: some View {
        TransactionWidgetView(entry: TransactionWidgetEntry(
            date: Date(),
            transaction: transactionPreviewData
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
