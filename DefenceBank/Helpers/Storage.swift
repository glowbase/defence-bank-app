//
//  CloudKit.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 8/1/2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // Set your App Group identifier here
    private let appGroupIdentifier = "group.com.cooperbeltrami.DefenceBank"
    
    // Helper to get shared UserDefaults
    private var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupIdentifier)
    }
    
    // Generic save function
    func save<T: Codable>(_ model: T, forKey key: String) {
        guard let sharedDefaults = sharedDefaults else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            sharedDefaults.set(encoded, forKey: key)
            sharedDefaults.synchronize() // Ensure the data is saved immediately
        }
    }

    // Generic fetch function
    func fetch<T: Codable>(forKey key: String, type: T.Type) -> T? {
        guard let sharedDefaults = sharedDefaults else { return nil }
        if let savedData = sharedDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }

    // Generic delete function
    func delete(forKey key: String) {
        guard let sharedDefaults = sharedDefaults else { return }
        sharedDefaults.removeObject(forKey: key)
    }

    // Generic update function (since we're just saving, this function is the same as `save`)
    func update<T: Codable>(_ model: T, forKey key: String) {
        save(model, forKey: key)
    }
}
