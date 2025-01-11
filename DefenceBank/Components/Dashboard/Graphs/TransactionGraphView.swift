//
//  TransactionGraphView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 9/1/2025.
//

import SwiftUI
import Charts

struct TransactionsGraphView: View {
    @Binding var transactions: [Transaction]
    
    @State private var transactionAmountsByDay: [(date: Date, debitAmount: Double, creditAmount: Double)] = []

    var body: some View {
        VStack {
            Chart {
                ForEach(transactionAmountsByDay, id: \.date) { item in
                    if item.debitAmount > item.creditAmount {
                        // Render Debit Bar in Front
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            yStart: .value("Start", 0),
                            yEnd: .value("End", item.debitAmount)
                        )
                        .foregroundStyle(Color.red)
                        .cornerRadius(5)

                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            yStart: .value("Start", 0),
                            yEnd: .value("End", item.creditAmount)
                        )
                        .foregroundStyle(Color.green)
                    } else {
                        // Render Credit Bar in Front
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            yStart: .value("Start", 0),
                            yEnd: .value("End", item.creditAmount)
                        )
                        .foregroundStyle(Color.green)
                        .cornerRadius(5)

                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            yStart: .value("Start", 0),
                            yEnd: .value("End", item.debitAmount)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
            }
            .frame(height: 300)
            .padding(.top)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(formatDate(value.as(Date.self) ?? Date()))
                    AxisTick()
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { value in
                    AxisValueLabel(formatWholeCurrency(value.as(Double.self) ?? 0))
                    AxisTick()
                    AxisGridLine() // Adds grid lines to the y-axis
                }
            }
        }
        .onAppear {
            Task {
                loadData()
            }
        }
        .onChange(of: transactions) { _ in
            Task {
                loadData()
            }
        }
    }
    
    func loadData() {
        let grouped = groupTransactionsByDate(transactions)
        
        transactionAmountsByDay = getLast7DaysTotal(grouped)
    }
    
    // Group transactions by date
    func groupTransactionsByDate(_ transactions: [Transaction]) -> [Date: [Transaction]] {
        return Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: parseDate(transaction.CreateDate) ?? Date())
        }
    }
    
    // Calculate totals for the last 7 days
    func getLast7DaysTotal(_ groupedTransactions: [Date: [Transaction]]) -> [(date: Date, debitAmount: Double, creditAmount: Double)] {
        let today = Calendar.current.startOfDay(for: Date())
        var results: [(date: Date, debitAmount: Double, creditAmount: Double)] = []
        
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let transactionsForDay = groupedTransactions[date] ?? []

            // Calculate total debit and credit amounts
            let debitAmount = transactionsForDay.reduce(0) { $0 + $1.DebitAmount }
            let creditAmount = transactionsForDay.reduce(0) { $0 + $1.CreditAmount }
            
            results.append((date: date, debitAmount: debitAmount, creditAmount: creditAmount))
        }
        
        return results.reversed() // Ensure the graph displays oldest to newest
    }

    // Format date for axis
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    // Format whole currency for axis labels
    func formatWholeCurrency(_ value: Double) -> String {
        "\(Int(value))"
    }
}
