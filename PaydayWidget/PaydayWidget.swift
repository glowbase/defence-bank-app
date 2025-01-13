//
//  PaydayWidget.swift
//  PaydayWidget
//
//  Created by Cooper Beltrami on 12/1/2025.
//

import SwiftUI
import WidgetKit

// MARK: - Widget Entry
struct PaydayWidgetEntry: TimelineEntry {
    let date: Date
    let paydayCountdown: PaydayCountdown?
    let nextPayday: Date
    let daysUntilPayday: Int
    let progress: Double
}

// MARK: - Provider
struct PaydayWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> PaydayWidgetEntry {
        PaydayWidgetEntry(
            date: Date(),
            paydayCountdown: nil,
            nextPayday: Date(),
            daysUntilPayday: 0,
            progress: 0.0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PaydayWidgetEntry) -> Void) {
        let entry = PaydayWidgetEntry(
            date: Date(),
            paydayCountdown: samplePaydayCountdown(),
            nextPayday: calculateNextPayday(for: samplePaydayCountdown()),
            daysUntilPayday: calculateDaysUntilPayday(for: samplePaydayCountdown()),
            progress: calculateProgress(for: samplePaydayCountdown())
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PaydayWidgetEntry>) -> Void) {
        var entries: [PaydayWidgetEntry] = []

        // Load saved payday data
        let paydayCountdown = loadSavedPaydayCountdown() ?? samplePaydayCountdown()
        
        let nextPayday = calculateNextPayday(for: paydayCountdown)
        let daysUntilPayday = calculateDaysUntilPayday(for: paydayCountdown)
        let progress = calculateProgress(for: paydayCountdown)

        let entry = PaydayWidgetEntry(
            date: Date(),
            paydayCountdown: paydayCountdown,
            nextPayday: nextPayday,
            daysUntilPayday: daysUntilPayday,
            progress: progress
        )
        entries.append(entry)

        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        
        completion(timeline)
    }

    // MARK: - Helpers
    private func loadSavedPaydayCountdown() -> PaydayCountdown? {
        let savedPayday = UserDefaultsManager.shared.fetch(forKey: "payday_countdown", type: PaydayCountdown.self)
        
        return savedPayday
    }
    
    private func samplePaydayCountdown() -> PaydayCountdown {
        PaydayCountdown(
            NextPayday: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            Frequency: "Weekly"
        )
    }

    private func calculateNextPayday(for countdown: PaydayCountdown) -> Date {
        let currentDate = Date()
        if countdown.NextPayday < currentDate {
            switch countdown.Frequency {
            case "Weekly":
                return Calendar.current.date(byAdding: .day, value: 7, to: countdown.NextPayday)!
            case "Fortnightly":
                return Calendar.current.date(byAdding: .day, value: 14, to: countdown.NextPayday)!
            case "Monthly":
                return Calendar.current.date(byAdding: .month, value: 1, to: countdown.NextPayday)!
            default:
                return countdown.NextPayday
            }
        }
        return countdown.NextPayday
    }

    private func calculateDaysUntilPayday(for countdown: PaydayCountdown) -> Int {
        let nextPayday = calculateNextPayday(for: countdown)
        let currentDate = Date()

        // Normalize the dates to ignore time components
        let calendar = Calendar.current
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)
        let startOfNextPayday = calendar.startOfDay(for: nextPayday)
        
        let components = calendar.dateComponents([.day], from: startOfCurrentDay, to: startOfNextPayday)
        
        return components.day ?? 0
    }

    private func calculateProgress(for countdown: PaydayCountdown) -> Double {
        let nextPayday = calculateNextPayday(for: countdown)
        let currentDate = Date()

        let totalDuration: Double
        switch countdown.Frequency {
        case "Weekly":
            totalDuration = 7 * 24 * 60 * 60
        case "Fortnightly":
            totalDuration = 14 * 24 * 60 * 60
        case "Monthly":
            totalDuration = 30 * 24 * 60 * 60
        default:
            totalDuration = 7 * 24 * 60 * 60
        }

        let elapsed = nextPayday.timeIntervalSince(currentDate)
        return min(max((totalDuration - elapsed) / totalDuration, 0), 1)
    }
}

// MARK: - Widget View
struct PaydayWidgetView: View {
    var entry: PaydayWidgetEntry
    
    @State private var paydayCountdown: PaydayCountdown? = nil
    @Environment(\.widgetFamily) var family

    var body: some View {
        let isSmall = isSmallWidget(family: family)

        HStack {
            VStack(alignment: .leading) {
                Text("PAYDAY")
                    .foregroundColor(.accent)
                    .font(.caption)
                    .bold()
                
                Spacer()
                
                Text(daysUntilPaydayText(for: entry.daysUntilPayday))
                    .font((daysUntilPaydayText(for: entry.daysUntilPayday) == "Tomorrow" && isSmall) ? .title2 : .title)
                    .minimumScaleFactor(0.5)
                    .bold()
                
                Spacer()
                
                ProgressView(value: entry.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .accent))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .frame(height: 10)
                    .cornerRadius(4)
                    .padding(.bottom, 4)
                
                HStack {
                    Text("\(entry.nextPayday, formatter: dateFormatter)")
                        .font(isSmall ? .caption : .subheadline)
                    
                    Spacer()
                    
                    if !isSmall {
                        Text(entry.paydayCountdown?.Frequency ?? "N/A")
                            .font(.subheadline)
                            .bold()
                    }
                }
            }
        }
        .containerBackground(.widgetBackground, for: .widget)
    }

    private func daysUntilPaydayText(for days: Int) -> String {
        switch days {
        case 0: return "Today"
        case 1: return "Tomorrow"
        default: return "\(days) days"
        }
    }

    private func isSmallWidget(family: WidgetFamily) -> Bool {
        return family == .systemSmall
    }
}

// MARK: - Date Formatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


// MARK: - Widget Definition
@main
struct PaydayWidget: Widget {
    let kind: String = "PaydayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PaydayWidgetProvider()) { entry in
            PaydayWidgetView(entry: entry)
        }
        .configurationDisplayName("Payday Countdown")
        .description("View your progress towards the next payday.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews
struct PaydayWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaydayWidgetView(entry: PaydayWidgetEntry(
                date: Date(),
                paydayCountdown: PaydayCountdown(
                    NextPayday: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                    Frequency: "Weekly"
                ),
                nextPayday: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                daysUntilPayday: 5,
                progress: 0.7
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            PaydayWidgetView(entry: PaydayWidgetEntry(
                date: Date(),
                paydayCountdown: PaydayCountdown(
                    NextPayday: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                    Frequency: "Weekly"
                ),
                nextPayday: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                daysUntilPayday: 5,
                progress: 0.7
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
