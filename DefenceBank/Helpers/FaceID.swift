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
    @Published var errorMessage: String?

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
                self.errorMessage = self.localizedErrorMessage(for: error as NSError?)
            }
        } else {
            if let error = error {
                self.errorMessage = self.localizedErrorMessage(for: error)
            }
        }
    }

    private func localizedErrorMessage(for error: NSError?) -> String {
        guard let error = error else { return "An unknown error occurred." }

        switch error.code {
        case LAError.authenticationFailed.rawValue:
            return "Authentication failed. Please try again."
        case LAError.userCancel.rawValue:
            return "Authentication was canceled by the user."
        case LAError.userFallback.rawValue:
            return "User selected password authentication."
        case LAError.biometryNotAvailable.rawValue:
            return "Face ID is not available on this device."
        case LAError.biometryNotEnrolled.rawValue:
            return "Face ID is not set up. Please set up Face ID in Settings."
        case LAError.biometryLockout.rawValue:
            return "Face ID is locked due to too many failed attempts."
        default:
            return "An unknown error occurred."
        }
    }
}
