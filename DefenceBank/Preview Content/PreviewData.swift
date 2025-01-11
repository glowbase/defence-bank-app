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
    AccountNumber: "20392984",
    CreateDate: "",
    DebitAmount: 103.64,
    CreditAmount: 0.0,
    Balance: 402.6,
    Description: "Description",
    LongDescription: "Long Description",
    TransactionCodeDescription: "",
    ImmutableTransactionId: 903894508392,
    CanLookupMerchant: false,
    MerchantLogo: "",
    MerchantName: "Merchant Name",
    CategoryList: [
        "Food/Drink"
    ]
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
