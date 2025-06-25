//
//  HabitRowView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.06.2025.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let isCompletedToday: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Text(habit.title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompletedToday ? AppColor.strongGreen : .gray)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


#Preview("Completed") {
    HabitRowView(
        habit: Habit(title: "Read a book"),
        isCompletedToday: true,
        onToggle: {}
    )
}
#Preview("Not completed") {
    HabitRowView(
        habit: Habit(title: "Write a poem"),
        isCompletedToday: false,
        onToggle: {}
    )
}
