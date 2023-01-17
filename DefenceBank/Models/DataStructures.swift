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
    let CurrentBalance: Double
    let ClassDescription: String
}

struct Credentials: Decodable {
    var Cookie: String
    var MemberNumber: String
    var Password: String
}
