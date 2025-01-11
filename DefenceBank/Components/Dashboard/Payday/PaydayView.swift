//
//  PaydayView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 2/1/2025.
//

import SwiftUI

struct PaydayView: View {
    @State private var showSheet: Bool = false
    @State private var paydayCountdown: PaydayCountdown? = nil // Store loaded payday data

    // Calculate the next payday if it's in the past
    private var nextPayday: Date {
        guard let payday = paydayCountdown else { return Date() }
        
        let currentDate = Date()
        
        // If next payday is in the past, recalculate it based on frequency
        if payday.NextPayday < currentDate {
            var calculatedNextPayday = payday.NextPayday
            switch payday.Frequency {
            case "Weekly":
                calculatedNextPayday = Calendar.current.date(byAdding: .day, value: 7, to: payday.NextPayday)!
            case "Fortnightly":
                calculatedNextPayday = Calendar.current.date(byAdding: .day, value: 14, to: payday.NextPayday)!
            case "Monthly":
                calculatedNextPayday = Calendar.current.date(byAdding: .month, value: 1, to: payday.NextPayday)!
            default:
                break
            }
            return calculatedNextPayday
        }
        
        return payday.NextPayday
    }

    // Calculate the progress towards the next payday
    private var progress: Double {
        let currentDate = Date()
        let timeInterval = nextPayday.timeIntervalSince(currentDate)
        
        // If the next payday has already passed
        if timeInterval < 0 {
            return 1.0 // 100% progress if payday is in the past
        }
        
        guard let payday = paydayCountdown else { return 0 }
        
        let totalCycleDuration: Double
        switch payday.Frequency {
        case "Weekly":
            totalCycleDuration = 7 * 24 * 60 * 60 // 1 week in seconds
        case "Fortnightly":
            totalCycleDuration = 14 * 24 * 60 * 60 // 2 weeks in seconds
        case "Monthly":
            totalCycleDuration = 30 * 24 * 60 * 60 // Approx 1 month in seconds
        default:
            totalCycleDuration = 7 * 24 * 60 * 60 // Default to 1 week
        }
        
        // Progress as a percentage of the total cycle duration
        let progress = (timeInterval / totalCycleDuration)
        return min(max(progress, 0), 1) // Clamp value between 0 and 1
    }

    // Calculate the number of days until the next payday or return specific text
    private var daysUntilPaydayText: String {
        let currentDate = Date()

        // Normalize the dates to ignore time components
        let calendar = Calendar.current
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)
        let startOfNextPayday = calendar.startOfDay(for: nextPayday)
        
        let components = calendar.dateComponents([.day], from: startOfCurrentDay, to: startOfNextPayday)
        
        guard let daysUntil = components.day else { return "Next Pay: Not Set" }
        
        switch daysUntil {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "\(daysUntil) days"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(daysUntilPaydayText)  // Show dynamic countdown text
                    .bold()
                Spacer()
                Image(systemName: "gear")
                    .bold()
                    .foregroundColor(.red)
                    .onTapGesture {
                        showSheet.toggle()
                    }
            }

            ProgressView(value: progress, total: 1)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .scaleEffect(x: 1, y: 4, anchor: .center)
                .frame(height: 15)
                .cornerRadius(10)
                .padding([.bottom], 4)
            
            if let payday = paydayCountdown {
                // Display the loaded payday data
                HStack {
                    Text("Next Pay: \(nextPayday, formatter: dateFormatter)") // Dynamically load the next payday
                    Spacer()
                    Text(payday.Frequency)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // Placeholder text if no data is found
                HStack {
                    Text("Next Pay: Not Set")
                    Spacer()
                    Text("No Frequency Set")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: loadData) {
            NavigationView {
                PaydayEditView(paydayCountdown: $paydayCountdown)  // Pass a binding to the data
            }
            .presentationDetents([.height(280)])
        }
        .onAppear {
            // Load saved payday data when the view appears
            loadData()
        }
    }
    
    private func loadData() {
        // Load saved payday data when the view appears or when the sheet is dismissed
        if let savedPayday = UserDefaultsManager.shared.fetch(forKey: "paydayCountdown", type: PaydayCountdown.self) {
            self.paydayCountdown = savedPayday
        } else {
            self.paydayCountdown = nil
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


struct PaydayView_Previews: PreviewProvider {
    static var previews: some View {
        PaydayView()
            .padding()
    }
}
