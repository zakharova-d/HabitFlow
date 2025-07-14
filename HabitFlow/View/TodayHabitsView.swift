import SwiftUI

struct TodayHabitsView: View {
    @State private var habitToEdit: Habit? = nil
    @State private var habitToDelete: Habit? = nil
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
                            },
                            onEdit: {
                                habitToEdit = habit
                            },
                            onDelete: {
                                habitToDelete = habit
                            }
                        )
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .listStyle(.plain)
                .sheet(item: $habitToEdit) { habit in
                    AddHabitView(
                        habitToEdit: habit,
                        onSave: { _ in },
                        onEdit: { updatedHabit in
                            habitStore.editHabit(updatedHabit)
                        }
                    )
                }
                .alert(item: $habitToDelete) { habit in
                    Alert(
                        title: Text("Delete Habit"),
                        message: Text("Are you sure you want to delete \"\(habit.title)\"?"),
                        primaryButton: .destructive(Text("Delete")) {
                            habitStore.deleteHabit(habit)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
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
