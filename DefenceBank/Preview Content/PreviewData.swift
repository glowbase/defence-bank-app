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

var accountsPreviewData = [Account](repeating: accountPreviewData, count: 3)
