//
//  Strucures.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import Foundation

struct Account: Codable, Hashable {
    let AccountNumber: String
    let Description: String
    let CurrentBalance: Double?
    let AvailableBalance: Double
    let ClassDescription: String?
}

struct Transaction: Codable, Hashable {
    let AccountNumber: String?
    let CreateDate: String
    let DebitAmount: Double
    let CreditAmount: Double
    let Balance: Double
    let Description: String?
    let LongDescription: String?
    let TransactionCodeDescription: String?
    let ImmutableTransactionId: Double?
    let CanLookupMerchant: Bool?
    let MerchantLogo: String?
    let MerchantName: String?
    let CategoryList: [String]?
}

struct TransactionResponse: Codable {
    let TransactionDetails: [Transaction]?
}

struct IdentifiableTransaction: Identifiable {
    let id: Double
    let transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
        self.id = transaction.ImmutableTransactionId ?? 0.0
    }
}

struct Uncollected: Codable, Hashable {
    let Amount: Double
    let CreditAmount: Double
    let DebitAmount: Double
    let EffectiveDate: String
    let Description: String
    let MerchantName: String
}

struct UncollectedResponse: Codable {
    let UncollectedFunds: [Uncollected]?
}

struct Credentials: Decodable {
    var Cookie: String
    var MemberNumber: String
    var Password: String
}
