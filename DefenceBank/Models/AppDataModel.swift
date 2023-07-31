//
//  AccountListModel.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import Foundation
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>

final class AppDataModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var pending: [Transaction] = []
    @Published var transactions: [Transaction] = []
    
    @Published var accountsTotal: Double = 0.0
    
    init() {
        if !isPreview {
            DispatchQueue.global(qos: .userInitiated).async {
                self.accounts = getAccounts()
                self.accountsTotal = getAccountsTotal(accounts: self.accounts)
            }
        }
    }
    
//    func groupTransactionsByMonth() -> TransactionGroup {
//        guard !transactions.isEmpty else { return [:] }
//        
//        let grouppedTransactions = TransactionGroup(grouping: transactions, by: { $0.month })
//        
//        return grouppedTransactions
//    }
}

func getAccountsTotal(accounts: [Account]) -> Double {
    var total: Double = 0.0
    
    accounts.forEach { account in
        total += account.AvailableBalance
    }
    
    return total
}

func getAccounts() -> [Account] {
    var temp_accounts = _getAccounts()
    
    // Tring to get accounts the first time might fail if
    // the cookie is invalid. The getAccounts() function
    // has the logic to generate a new token and save it
    // but will not reinvoke itself so we are doing it here
    if temp_accounts == [] {
        temp_accounts = _getAccounts()
    }
    
    return temp_accounts
}

func getTransactions(account_number: String) -> [Transaction] {
    var temp_transactions = _getTranasactions(account_number: account_number)
    
    if temp_transactions == [] {
        temp_transactions = _getTranasactions(account_number: account_number)
    }
    
    return temp_transactions
}
