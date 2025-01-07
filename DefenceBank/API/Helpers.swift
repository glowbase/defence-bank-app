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
