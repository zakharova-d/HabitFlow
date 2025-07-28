//
//  HabitProgressItemView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 09.07.2025.
//

import SwiftUI

struct ProgressHabitItemView: View {
    let habitTitle: String
    let completedDaysCount: Int
    let totalDaysInPeriod: Int
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(habitTitle)
            ProgressView(value: Double(completedDaysCount) / Double(totalDaysInPeriod)) {
                Text("\(completedDaysCount)/\(totalDaysInPeriod)")
                    .font(.footnote)
                    .foregroundStyle(AppColor.orange)
            }
            .accentColor(AppColor.green)
        }
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button (role: .destructive) {
                onDelete()
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}

#Preview("With progress") {
    ProgressHabitItemView(
        habitTitle: "Read a Book",
        completedDaysCount: 22,
        totalDaysInPeriod: 30,
        onEdit: {},
        onDelete: {}
    )
}

#Preview("No progress") {
    ProgressHabitItemView(
        habitTitle: "Read a Book",
        completedDaysCount: 0,
        totalDaysInPeriod: 30,
        onEdit: {},
        onDelete: {}
    )
}
