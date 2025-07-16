//
//  HabitProgressItemView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 09.07.2025.
//

import SwiftUI

struct HabitProgressItemView: View {
    let habitTitle: String
    let doneCount: Int
    let totalDaysInPeriod: Int
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(habitTitle)
                .foregroundStyle(AppColor.orange)
                .bold()
            ProgressView(value: Double(doneCount) / Double(totalDaysInPeriod)) {
                Text("\(doneCount)/\(totalDaysInPeriod)")
            }
            .accentColor(AppColor.green)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 4)
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
    HabitProgressItemView(
        habitTitle: "Read a Book",
        doneCount: 22,
        totalDaysInPeriod: 30,
        onEdit: {},
        onDelete: {}
    )
}

#Preview("No progress") {
    HabitProgressItemView(
        habitTitle: "Read a Book",
        doneCount: 0,
        totalDaysInPeriod: 30,
        onEdit: {},
        onDelete: {}
    )
}
