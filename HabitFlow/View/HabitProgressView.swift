//
//  HabitProgressView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 09.07.2025.
//


import SwiftUI

struct HabitProgressView: View {
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()
            
            if habitStore.habits.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No habits yet")
                        .font(.title3.bold())
                    
                    Text("Tap '+' to add your first habit ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(habitStore.habits) { habit in
                            HabitProgressItemView(
                                habitTitle: habit.title,
                                doneCount: habit.records.filter { $0.value }.count,
                                totalDaysInPeriod: trackingRangeInDays()
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func trackingRangeInDays() -> Int {
        return 30 // or 60, or 90 — could be made dynamic later
    }
}

#Preview("With progress") {
    let store = HabitStore(skipLoading: true)
    store.habits = [
        Habit(title: "Read a Book", records: (0..<30).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 2 == 0
        }),
        Habit(title: "Meditate", records: (0..<30).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 3 == 0
        }),
        Habit(title: "Walk", records: (0..<30).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = true
        })
    ]
    return HabitProgressView(habitStore: store)
}

#Preview("No progress") {
    let store = HabitStore(skipLoading: true)
    store.habits = [
        Habit(title: "Read a Book"),
        Habit(title: "Meditate"),
        Habit(title: "Walk")
    ]
    return HabitProgressView(habitStore: store)
}
