//
//  CloudKit.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 8/1/2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    // Generic save function
    func save<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // Generic fetch function
    func fetch<T: Codable>(forKey key: String, type: T.Type) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }

    // Generic delete function
    func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    // Generic update function (since we're just saving, this function is the same as `save`)
    func update<T: Codable>(_ model: T, forKey key: String) {
        save(model, forKey: key)
    }
}
