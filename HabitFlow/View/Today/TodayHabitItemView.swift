//
//  HabitRowView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 17.06.2025.
//

import SwiftUI

struct TodayHabitItemView: View {
    let habit: Habit
    let isCompletedToday: Bool
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(habit.title)
                .font(.body)
                .foregroundColor(.primary)
                .onTapGesture {
                    onEdit()
                }
            
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
        .contextMenu {
            Button {
                onToggle()
            } label: {
                Label(isCompletedToday ? "Mark as Not Done" : "Mark as Done", systemImage: isCompletedToday ? "xmark.circle" : "checkmark.circle")
            }
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}


#Preview("Completed") {
    TodayHabitItemView(
        habit: Habit(title: "Read a book"),
        isCompletedToday: true,
        onToggle: {},
        onEdit: {},
        onDelete: {}
    )
}
#Preview("Not completed") {
    TodayHabitItemView(
        habit: Habit(title: "Write a poem"),
        isCompletedToday: false,
        onToggle: {},
        onEdit: {},
        onDelete: {}
    )
}
