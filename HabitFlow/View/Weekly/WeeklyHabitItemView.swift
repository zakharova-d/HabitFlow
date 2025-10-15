//
//  WeeklyHabitItemView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.07.2025.
//


import SwiftUI

struct WeeklyHabitItemView: View {
    let habit: Habit
    let dates: [Date] // last seven days
    let toggleAction: (Date) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    // 7 equal-width columns so date bubbles stretch to fill available width
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 14, alignment: .center), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(habit.title)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(dates, id: \.self) { date in
                    let isDone = habit.records[Calendar.current.startOfDay(for: date)] ?? false

                    VStack(spacing: 4) {
                        Text(shortWeekday(from: date))
                            .font(.caption2)
                            .foregroundColor(AppColor.orange)

                        Button(action: {
                            toggleAction(date)
                        }) {
                            Circle()
                                .fill(isDone ? AppColor.green : Color.gray.opacity(0.3))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text("\(dayNumber(from: date))")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                )
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.7))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button (role: .destructive) {
                onDelete()
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
    
    private func shortWeekday(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.setLocalizedDateFormatFromTemplate("E") // e.g., "Mon"
        return formatter.string(from: date)
    }
    
    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}


#Preview("Filled") {
    WeeklyHabitItemView(
        habit: Habit(
            title: "Meditate",
            createdDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            records: (0..<7).reduce(into: [:]) { dict, offset in
                let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
                dict[Calendar.current.startOfDay(for: date)] = true
            }
        ),
        dates: (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: -$0, to: Date()) }.reversed(),
        toggleAction: { _ in },
        onEdit: {},
        onDelete: {}
    )
}

#Preview("Empty") {
    WeeklyHabitItemView(
        habit: Habit(
            title: "Read",
            createdDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            records: [:]
        ),
        dates: (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: -$0, to: Date()) }.reversed(),
        toggleAction: { _ in },
        onEdit: {},
        onDelete: {}
    )
}
