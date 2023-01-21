//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 18/1/2023.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var data = AppDataModel()
    
    let account: Account
    
    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Available")
                        Text(account.AvailableBalance, format: .currency(code: "AUD"))
                            .font(.title)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 5) {
                                Text("Balance")
                                    .foregroundColor(.secondary)
                                
                                Text(account.CurrentBalance, format: .currency(code: "AUD"))
                                
                            }
                            
                            HStack(spacing: 5) {
                                Text("Pending")
                                    .foregroundColor(.secondary)
                                    
                                Text(15.3, format: .currency(code: "AUD"))
                            }
                        }
                        .font(.subheadline)
                        .padding([.top], 4)
                        
                        HStack() {
                            Button("Transfer", action: {
                                
                            })
                            .padding()
                            .font(.callout)
                            .background(.secondary.opacity(0.2))
                            .cornerRadius(25)
                            .foregroundColor(.primary)
                        }
                        .padding([.top], 20)
                        
                        Divider()
                            .padding([.top], 24)
                    }
                    .padding()
                    
                    Text("Activity")
                        .font(.title2)
                        .padding([.leading])
                    
                    List() {
                        ForEach(Array(data.transactions.enumerated()), id: \.element) { index, transaction in
                            TransactionView(transaction: transaction)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                self.data.transactions = getTransactions(account_number: account.AccountNumber)
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        data.accounts = accountsPreviewData
        
        return data
    }()
    
    static var previews: some View {
        TransactionsView(account: accountPreviewData)
            .environmentObject(data)
    }
}
