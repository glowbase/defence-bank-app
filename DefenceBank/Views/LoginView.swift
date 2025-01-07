//
//  LoginView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI
import KeychainAccess

struct LoginView: View {
    @StateObject private var authenticator = FaceIDAuthenticator()

    @State private var showContentView: Bool = false
    @State private var member_number: String = ""
    @State private var password: String = ""

    func login(member_number: String, password: String) async {
        let cookie = await getCookie(
            member_number: member_number,
            password: password
        )

        // No cookie, probably bad credentials
        if cookie == "" {
            return
        }

        // Save everything to keychain
        let credentials = Credentials(
            Cookie: cookie,
            MemberNumber: member_number,
            Password: password
        )

        saveCredentials(credentials: credentials)

        // Show AccountsView()
        self.showContentView = true
    }

    func preLogin() async {
        // See if cookie is already saved, if not, then keep showing
        // LoginView() if not then show the AccountsView()

        // If the cookie is invalid, the AccountsView() will determine
        // this and then show get a new cookie using saved credentials
        let credentials = getCredentials()

        if credentials.Cookie == "" {
            return
        }

        // Check if we're running on a simulator (at runtime)
        if isRunningOnSimulator() {
            // If running on a simulator, bypass Face ID and go directly to ContentView
            self.showContentView = true
            return
        }

        // Authenticate using Face ID if on a real device
        await authenticator.authenticateWithFaceID()

        // If authentication is successful, navigate to ContentView
        if authenticator.isAuthenticated {
            self.showContentView = true
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Image("Logo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding([.bottom], 12)

                        VStack(alignment: .leading) {
                            Text("Welcome to")
                            Text("Defence Bank")
                                .foregroundColor(Color.accentColor)
                        }
                        .font(.system(size: 40))
                        .fontWeight(.light)
                    }
                    .padding([.top], 50)

                    Spacer()
                }
                .padding()
                .padding([.bottom], 32)

                VStack {
                    // MARK: Member Number
                    TextField("Member Number", text: $member_number)
                        .padding()
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(5)
                        .keyboardType(.numberPad)
                        .textContentType(.username)

                    // MARK: Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(5)
                        .textContentType(.password)
                }
                .fontWeight(.light)
                .padding([.leading, .trailing], 10)

                Spacer()

                // MARK: Login Button
                Button(action: {
                    // Launch async code inside a Task
                    Task {
                        await login(
                            member_number: $member_number.wrappedValue,
                            password: $password.wrappedValue
                        )
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("Login")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                })

                Link("Don't have an account?", destination: URL(string: "https://join.defencebank.com.au/#/welcome")!)
                    .padding([.top, .bottom], 10)
                    .foregroundColor(.primary)

                NavigationLink(
                    destination: ContentView().navigationBarBackButtonHidden(true),
                    isActive: $showContentView
                ) { EmptyView() }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
        .onAppear {
            Task {
                await preLogin() // Wait for the Face ID authentication when the view appears
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
