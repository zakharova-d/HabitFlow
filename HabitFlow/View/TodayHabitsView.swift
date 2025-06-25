import SwiftUI

struct TodayHabitsView: View {
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
                            HabitRowView(
                                habit: habit,
                                isCompletedToday: habit.isCompletedToday,
                                onToggle: {                   habitStore.toggleCompletion(for: habit)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview("Empty state") {
    TodayHabitsView(habitStore: HabitStore())
}

#Preview("With habits") {
    TodayHabitsView(habitStore: {
        let store = HabitStore()
        store.habits = [
            Habit(title: "Drink water"),
            Habit(title: "Read a book"),
            Habit(title: "Go for a walk")
        ]
        return store
    }())
}
