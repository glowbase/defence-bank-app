//
//  Extensions.swift
//  DefenceBank
//
//  Created by Cooper on 31/7/2023.
//

import Foundation

extension DateFormatter {
    static let allNumericAUS: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let dateParsed = DateFormatter.allNumericAUS.date(from: self) else {
            return Date()
        }
        
        return dateParsed
    }
}

extension String {
    var decode: String {
        let attr = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)

        return attr?.string ?? self
    }
}
