//
//  ContentView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 12.06.2025.
//

import SwiftUI
import CoreData

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
            .gesture(swipeGesture)
            .padding()
        }
    }
    
    @ViewBuilder
    private var currentScreen: some View {
        switch selectedMode {
        case .today:
            TodayHabitsView(habitStore: habitStore)
        case .weekly:
            WeeklyHabitsView(habitStore: habitStore)
        case .progress:
            ProgressHabitsView(habitStore: habitStore)
        }
    }
    
    private var header: some View {
        HStack {
            Text(Bundle.main.appName)
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
    
    private var swipeGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                let horizontalAmount = value.translation.width
                
                guard abs(horizontalAmount) > 50 else { return }
                
                switch horizontalAmount {
                case ..<0:
                    // Swipe left – forward
                    if let next = selectedMode.next() {
                        selectedMode = next
                    }
                case 0...:
                    // Swipe right – back
                    if let previous = selectedMode.previous() {
                        selectedMode = previous
                    }
                default:
                    break
                }
            }
    }
}

extension Bundle {
    var appName: String {
        return object(forInfoDictionaryKey: "CFBundleName") as? String ?? "HabitFlow"
    }
}

#Preview("With habits") {
    ContentView(habitStore: PreviewData.habitStoreWithSampleData())
}

#Preview ("Empty state") {
    ContentView(habitStore: HabitStore(shouldSkipLoading: true))
}
