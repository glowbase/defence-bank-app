//
//  ContentView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI
import KeychainAccess

struct LoginView: View {
    @State private var showAccountsView: Bool = false
    @State private var member_number:String = ""
    @State private var password:String = ""
    
    func login(member_number:String, password:String) {
        let cookie = getCookie(
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
        self.showAccountsView = true
    }
    
    func preLogin() {
        // See if cookie is already saved, if not, then keep showing
        // LoginView() if not then show the AccountsView()
        
        // If the cookie is invalid, the AccountsView() will determine
        // this and then show get a new cookie using saved credentials
        let credentials = getCredentials()
        
        print("PRE-LOGIN: \(credentials.Cookie)")
        
        // No cookie saved
        if credentials.Cookie == "" {
            return
        }
        
        // Show AccountsView()
        self.showAccountsView = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Title
                Text("Defence Bank")
                    .bold()
                    .padding([.bottom, .top], 64)
                    .font(.largeTitle)
                
                // MARK: Member Number
                TextField("Member Number", text: $member_number)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                    .keyboardType(.numberPad)
                    .textContentType(.username)
                
                // MARK: Password
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                    .textContentType(.password)
                
                Spacer()
                
                // MARK: Login Button
                Button(action: {
                    login(
                        member_number: $member_number.wrappedValue,
                        password: $password.wrappedValue
                    )
                }, label: {
                    HStack {
                        Spacer()
                        Text("Login")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemRed))
                    .cornerRadius(5)
                })
                
                NavigationLink(
                    destination: AccountsView().navigationBarBackButtonHidden(true),
                    isActive: $showAccountsView
                ) { EmptyView() }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
        .onAppear {
            preLogin()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
