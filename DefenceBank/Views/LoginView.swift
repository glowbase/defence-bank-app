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
    
    func login(member_number:String, password:String) async {
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
        self.showAccountsView = true
    }
    
    func preLogin() {
        // See if cookie is already saved, if not, then keep showing
        // LoginView() if not then show the AccountsView()
        
        // If the cookie is invalid, the AccountsView() will determine
        // this and then show get a new cookie using saved credentials
        let credentials = getCredentials()
        
        print("COOKIE: \(credentials.Cookie)")
        
        // No cookie saved
        if credentials.Cookie == "" {
            return
        }
        
        // Show AccountsView()
        self.showAccountsView = true
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack() {
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
                    destination: DashboardView().navigationBarBackButtonHidden(true),
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
