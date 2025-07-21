//
//  HabitProgressView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 09.07.2025.
//


import SwiftUI

struct HabitProgressView: View {
    @ObservedObject var habitStore: HabitStore
    @State var selectedPeriod: Int = 30
    let availablePeriods = [30, 60, 90]
    @State private var habitToEdit: Habit? = nil
    @State private var habitToDelete: Habit? = nil
    
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
                    VStack(alignment: .leading) {
                        HStack(spacing: 24) {
                            ForEach(availablePeriods, id: \.self) { period in
                                VStack(spacing: 4) {
                                    Text("\(period) days")
                                        .font(.headline)
                                        .foregroundColor(selectedPeriod == period ? AppColor.strongGreen : .secondary)
                                        .onTapGesture {
                                            selectedPeriod = period
                                        }
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(selectedPeriod == period ? AppColor.green : .clear)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        VStack(spacing: 12) {
                            ForEach(habitStore.habits) { habit in
                                let done = habitStore.doneCount(for: habit, inLast: selectedPeriod)
                                HabitProgressItemView(
                                    habitTitle: habit.title,
                                    doneCount: done,
                                    totalDaysInPeriod: selectedPeriod,
                                    onEdit: {
                                        habitToEdit = habit
                                    },
                                    onDelete: {
                                        habitToDelete = habit
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .editSheet(for: $habitToEdit, in: habitStore)
                        .deleteAlert(for: $habitToDelete, in: habitStore)
                    }
                }
            }
        }
    }
}

#Preview("With progress") {
    let store = HabitStore(skipLoading: true)
    store.habits = [
        Habit(title: "Read a Book", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 2 == 0
        }),
        Habit(title: "Meditate", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = $1 % 3 == 0
        }),
        Habit(title: "Walk", records: (0..<90).reduce(into: [:]) {
            let date = Calendar.current.date(byAdding: .day, value: -$1, to: Date())!
            $0[Calendar.current.startOfDay(for: date)] = true
        })
    ]
    let selectedPeriod = Binding<Int>(get: { 90 }, set: { _ in })
    return HabitProgressView(habitStore: store)
}

#Preview("No progress") {
    let store = HabitStore(skipLoading: true)
    store.habits = [
        Habit(title: "Read a Book"),
        Habit(title: "Meditate"),
        Habit(title: "Walk")
    ]
    let selectedPeriod = Binding<Int>(get: { 30 }, set: { _ in })
    return HabitProgressView(habitStore: store)
}
