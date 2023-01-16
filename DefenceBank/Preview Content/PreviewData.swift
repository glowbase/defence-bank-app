//
//  PreviewData.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import Foundation

var accountPreviewData = Account(
    AccountNumber: "20392984",
    Description: "Everyday Access",
    CurrentBalance: 104.28,
    ClassDescription: "Max E Saver"
)

var accountsPreviewData = [Account](repeating: accountPreviewData, count: 3)
