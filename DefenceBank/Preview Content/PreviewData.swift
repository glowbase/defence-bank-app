//
//  PreviewData.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import Foundation

var accountPreviewData = Account(
    AccountNumber: "20392984",
    Description: "Everyday",
    CurrentBalance: 394.64,
    AvailableBalance: 375.25,
    ClassDescription: "Everyday Access"
)

var transactionPreviewData = Transaction(
    AccountNumber: "123456789",
    CreateDate: ISO8601DateFormatter().string(from: Date()),
    DebitAmount: 28.00,
    CreditAmount: 0.0,
    Balance: 250.00,
    Description: "Purchase",
    LongDescription: "Purchase",
    TransactionCodeDescription: "POS Purchase",
    ImmutableTransactionId: 1122334455,
    CanLookupMerchant: true,
    MerchantLogo: "https://images.lookwhoscharging.com/d2c7868b-c732-4f82-80cd-b867ae17e10a/Aldi-Stores-Summerhill-Shopping-Centre-logo-image.png",
    MerchantName: "ALDI (Summerhill)",
    CategoryList: ["Groceries"]
)

var cardPreviewData = Card(
    Type: "VISA DEBIT - CAMO ARMY GREEN",
    Number: "xxxxxxxxxxxx1234",
    Index: 0,
    ControlGroups: [],
    LinkedAccounts: []
)

var cardSliderPreviewData = SliderItem(
    Background: "army",
    Title: "Everyday",
    SubTitle: "20302942",
    Card: cardPreviewData
)

var groupedTransactionPreview = CategoryGroupedTransactions(
    Transactions: transactionsPreviewData,
    Category: "Food",
    Total: 1039
)

var transactionsPreviewData = [Transaction](repeating: transactionPreviewData, count: 5)
var accountsPreviewData = [Account](repeating: accountPreviewData, count: 2)
var cardsPreviewData = [SliderItem](repeating: cardSliderPreviewData, count: 3)
var groupedTransactionsPreviewData = [CategoryGroupedTransactions](repeating: groupedTransactionPreview, count: 4)
