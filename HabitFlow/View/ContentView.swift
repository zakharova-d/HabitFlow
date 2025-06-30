//
//  ContentView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 12.06.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMode: HabitViewMode = .today
    @State private var isPresentingAddHabit = false
    @ObservedObject var habitStore: HabitStore

    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .sheet(isPresented: $isPresentingAddHabit) {
                        AddHabitView { newHabit in
                            habitStore.addHabit(newHabit)
                        }
                    }

                HabitModePicker(selected: $selectedMode)

                currentScreen
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
            }
            .padding()
            .onAppear {
                habitStore.loadHabits()
            }
        }
    }

    private var currentScreen: some View {
        switch selectedMode {
        case .today:
            AnyView(TodayHabitsView(habitStore: habitStore))
        case .weekly:
            AnyView(Text("Screen: weekly"))
        case .history:
            AnyView(Text("Screen: history"))
        }
    }

    private var header: some View {
        HStack {
            Text("Habits")
                .font(.title.bold())
            Spacer()
            Button(action: {
                isPresentingAddHabit = true
                print("Add habit sheet presented")
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .bold()
                    .foregroundColor(AppColor.green)
            }
        }
        .padding()
    }
}

#Preview("With habits") {
    ContentView(habitStore: {
        let store = HabitStore(skipLoading: true)
        store.addHabit(Habit(title: "Drink water"))
        store.addHabit(Habit(title: "Walk 10k steps"))
        return store
    }()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

#Preview ("Empty state") {
    ContentView(habitStore: HabitStore(skipLoading: true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
