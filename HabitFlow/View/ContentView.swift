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
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        
                        guard abs(horizontalAmount) > 50 else { return }
                        
                        switch horizontalAmount {
                        case ..<0:
                            // Swipe left – forward
                            if let next = HabitViewMode.allCases.next(after: selectedMode) {
                                selectedMode = next
                            }
                        case 0...:
                            // Swipe right – back
                            if let previous = HabitViewMode.allCases.previous(before: selectedMode) {
                                selectedMode = previous
                            }
                        default:
                            break
                        }
                    }
            )
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
            AnyView(WeeklyHabitsView(habitStore: habitStore))
        case .progress:
            AnyView(HabitProgressView(habitStore: habitStore))
        }
    }
    
    private var header: some View {
        HStack {
            Text("Habits")
                .font(.title.bold())
            Spacer()
            Button(action: {
                isPresentingAddHabit = true
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
        
        var habit1 = Habit(title: "Drink water")
        var habit2 = Habit(title: "Walk 10k steps")
        
        for i in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            let key = Calendar.current.startOfDay(for: date)
            
            habit1.records[key] = i % 2 == 0
            habit2.records[key] = true
        }
        
        store.addHabit(habit1)
        store.addHabit(habit2)
        
        return store
    }())
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

extension Array where Element: Equatable {
    func next(after element: Element) -> Element? {
        guard let index = firstIndex(of: element), index + 1 < count else { return nil }
        return self[index + 1]
    }
    
    func previous(before element: Element) -> Element? {
        guard let index = firstIndex(of: element), index - 1 >= 0 else { return nil }
        return self[index - 1]
    }
}


#Preview ("Empty state") {
    ContentView(habitStore: HabitStore(skipLoading: true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
