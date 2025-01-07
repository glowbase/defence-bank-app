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

struct Card: Codable, Hashable {
    let `Type`: String
    let Number: String
    let Index: Int
    let ControlGroups: [CardControlGroup]
    let LinkedAccounts: [LinkedAccount]
}

struct CardControlGroup: Codable, Hashable {
    let Id: Int
    let Name: String
    let Description: String
    let DisplayOrder: Int
    let Controls: [CardControl]
}

struct CardControl: Codable, Hashable {
    let Name: String
    let Description: String
    let DisplayOrder: Int
    let DisplayGroup: String
    let Scope: Int
    let `Type`: String
    let Id: Int
    let Value: String
}

struct SliderItem: Identifiable {
    private(set) var id: UUID = .init()
    var Background: String
    var Title: String
    var SubTitle: String
    var Card: Card
}

struct Control {
    let id: UUID
    let Name: String
    let Description: String
    var isEnabled: Bool  // State variable for the toggle (on/off)
}

struct LinkedAccount: Codable, Hashable {
    let AccountNumber: String
    let AccountType: String
    let Name: String
    let Relationships: String
}

struct CardResponse: Codable {
    let Cards: [Card]?
}

struct PaydayCountdown {
    let NextPayday: Date
    let Frequency: String
}
