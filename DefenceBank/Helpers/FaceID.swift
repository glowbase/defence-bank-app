//
//  BiometricAuthManager.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 6/1/2025.
//

import LocalAuthentication
import SwiftUI

class FaceIDAuthenticator: ObservableObject {
    @Published var isAuthenticated = false

    // Async method to authenticate using Face ID
    func authenticateWithFaceID() async {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate using Face ID")
                
                if success {
                    self.isAuthenticated = true
                }
            } catch {
                print("Error occured authenticating with Face ID")
            }
        } else {
            if let error = error {
                print(error)
            }
        }
    }
}
