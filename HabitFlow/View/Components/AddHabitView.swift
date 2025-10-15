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
    @FocusState private var nameFocused: Bool
    var habitToEdit: Habit?
    private let maxTitleLength: Int = 40
    
    var onAddHabit: (Habit) -> Void
    var onUpdateHabit: (Habit) -> Void
    
    init(
        habitToEdit: Habit? = nil,
        onAddHabit: @escaping (Habit) -> Void,
        onUpdateHabit: @escaping (Habit) -> Void = { _ in }
    ) {
        self.habitToEdit = habitToEdit
        self._habitTitle = State(initialValue: habitToEdit?.title ?? "")
        self.onAddHabit = onAddHabit
        self.onUpdateHabit = onUpdateHabit
    }
    
    private var isSaveDisabled: Bool {
        habitTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveHabit() {
        let updatedHabit = Habit(
            id: habitToEdit?.id ?? UUID(),
            title: habitTitle,
            createdDate: habitToEdit?.createdDate ?? Date(),
            records: habitToEdit?.records ?? [:]
        )
        if habitToEdit == nil {
            onAddHabit(updatedHabit)
        } else {
            onUpdateHabit(updatedHabit)
        }
        nameFocused = false
        dismiss()
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
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                        .focused($nameFocused)
                        .submitLabel(.done)
                        .onSubmit { saveHabit() }
                        .onChange(of: habitTitle) {
                            if habitTitle.count > maxTitleLength {
                                habitTitle = String(habitTitle.prefix(maxTitleLength))
                            }
                        }
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.black.opacity(0.10), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
                        .padding(.horizontal)
                    HStack {
                        Spacer()
                        Text("\(max(0, maxTitleLength - habitTitle.count))/\(maxTitleLength)")
                            .font(.caption2)
                            .monospacedDigit()
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                            .padding(.trailing, 20)
                    }

                    Spacer()

                    Text("Start building better habits 🌿")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .task {
                    // slight delay so the sheet/push animation finishes before focusing
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    nameFocused = true
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
                            saveHabit()
                        }
                        .font(.title3.bold())
                        .foregroundColor(isSaveDisabled ? .gray : AppColor.strongGreen)
                        .disabled(isSaveDisabled)
                    }
                }
            }
        }
    }
}
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(
            onAddHabit: { newHabit in
                print("Preview habit created: \(newHabit.title)")
            },
            onUpdateHabit: { editedHabit in
                print("Preview habit edited: \(editedHabit.title)")
            }
        )
    }
}
