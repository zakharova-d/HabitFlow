//
//  AddHabitView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 13.06.2025.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @State private var habitTitle: String = ""
    var habitToEdit: Habit?
    
    var onSave: (Habit) -> Void
    var onEdit: (Habit) -> Void
    
    init(
        habitToEdit: Habit? = nil,
        onSave: @escaping (Habit) -> Void,
        onEdit: @escaping (Habit) -> Void = { _ in }
    ) {
        self.habitToEdit = habitToEdit
        self._habitTitle = State(initialValue: habitToEdit?.title ?? "")
        self.onSave = onSave
        self.onEdit = onEdit
    }

    var body: some View {
        ZStack {
            Color(AppColor.background)
                .ignoresSafeArea()

            NavigationView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(habitToEdit == nil ? "🌱 Add New Habit" : " 🪶 Edit Habit")
                        .font(.largeTitle.bold())
                        .padding(.top, 32)
                        .padding(.horizontal)

                    TextField("Habit name", text: $habitTitle)
                        .padding()
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    Spacer()

                    Text("Start building better habits 🌿")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(AppColor.orange)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let updatedHabit = Habit(
                                id: habitToEdit?.id ?? UUID(),
                                title: habitTitle,
                                createdDate: habitToEdit?.createdDate ?? Date(),
                                records: habitToEdit?.records ?? [:]
                            )
                            if habitToEdit == nil {
                                onSave(updatedHabit)
                            } else {
                                onEdit(updatedHabit)
                            }
                            dismiss()
                        }
                        .font(.title3.bold())
                        .foregroundColor(habitTitle.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : AppColor.strongGreen)
                        .disabled(habitTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
}
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(
            onSave: { newHabit in
                print("Preview habit created: \(newHabit.title)")
            },
            onEdit: { editedHabit in
                print("Preview habit edited: \(editedHabit.title)")
            }
        )
    }
}
