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
                List {
                    ForEach(habitStore.habits) { habit in
                        HabitRowView(
                            habit: habit,
                            isCompletedToday: habit.isCompletedToday,
                            onToggle: {
                                habitStore.toggleCompletion(for: habit)
                            }
                        )
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                habitStore.deleteHabit(habit)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = habitStore.habits[index]
            habitStore.deleteHabit(habit)
        }
    }
}

#Preview("With habits") {
    TodayHabitsView(habitStore: {
        let store = HabitStore(skipLoading: true)
        store.habits = [
            Habit(title: "Drink water"),
            Habit(title: "Read a book"),
            Habit(title: "Go for a walk")
        ]
        return store
    }())
}

#Preview("Empty state") {
    TodayHabitsView(habitStore: HabitStore(skipLoading: true))
}
