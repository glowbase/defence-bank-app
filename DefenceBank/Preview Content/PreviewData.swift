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

var transactionsPreviewData = [Transaction](repeating: transactionPreviewData, count: 5)
var accountsPreviewData = [Account](repeating: accountPreviewData, count: 2)
