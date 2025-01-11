//
//  Helpers.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 3/1/2025.
//

import SwiftUI

// Format the amount as currency with a proper symbol
func formatAmount(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
}

// Parse date from string, considering both formats
func parseDate(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    
    // Try parsing with time (full format)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    if let parsedDate = formatter.date(from: dateString) {
        return parsedDate
    }
    
    // If the first format fails, try parsing without time
    formatter.dateFormat = "yyyy-MM-dd" // Format without time
    if let parsedDate = formatter.date(from: dateString) {
        return parsedDate
    }
    
    // If both formats fail, return nil
    print("Failed to parse date: \(dateString)")
    return nil
}

func isRunningOnSimulator() -> Bool {
    return TARGET_OS_SIMULATOR != 0
}

// Group transactions by category and calculate totals
func groupTransactionsByCategory(_ transactions: [Transaction]) -> [CategoryGroupedTransactions] {
    let grouped = Dictionary(grouping: transactions) { $0.CategoryList?.first ?? "Miscellaneous" }
    
    return grouped.map { (category, transactions) in
        let total = transactions.reduce(0) { $0 + $1.DebitAmount }
        
        return CategoryGroupedTransactions(
            Transactions: transactions,
            Category: category,
            Total: total
        )
    }.sorted { $0.Category < $1.Category }
}

// Group the transactions by date (ignoring the time part) and apply search filtering
func groupTransactionsByDate(_ transactions: [Transaction]) -> [(date: String, transactions: [Transaction], total: Double)] {
    
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
        let totalDebited = transactions
            .reduce(0) { $0 + $1.DebitAmount }

        return (date: date, transactions: transactions, total: totalDebited)
    }
}

// Filter the transactions based on the search query
func filterTransactions(query: String, transactions: [Transaction]) -> [Transaction] {
    if query.isEmpty {
        return transactions
    }
    
    return transactions.filter { transaction in
        (transaction.MerchantName ?? transaction.Description ?? transaction.LongDescription ?? "").lowercased().contains(query.lowercased())
    }
}

// Group accounts by ClassDescription
func groupAccountsByClassDescription(_ accounts: [Account]) -> [(classDescription: String, accounts: [Account])] {
    let grouped = Dictionary(grouping: accounts) { $0.ClassDescription ?? "Uncategorized" }
    return grouped
        .map { (classDescription, accounts) in
            (classDescription: classDescription, accounts: accounts)
        }
        .sorted { $0.classDescription < $1.classDescription } // Sort alphabetically by class description
}
