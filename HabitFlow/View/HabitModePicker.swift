//
//  HabitModePicker.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 13.06.2025.
//

import SwiftUICore
import SwiftUI

struct HabitModePicker: View {
    @Binding var selected: HabitViewMode

    var body: some View {
        HStack(spacing: 10) {
            ForEach(HabitViewMode.allCases, id: \.self) { mode in
                Text(mode.rawValue.uppercased())
                    .fontWeight(.semibold)
                    .foregroundColor(selected == mode ? .white : .gray)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule().fill(selected == mode ? AppColor.orange : Color(.systemGray5))
                    )
                    .onTapGesture {
                        selected = mode
                    }
            }
        }
        .padding(.vertical, 8)
        .onChange(of: selected) { newValue, _ in
            print("Switched to mode: \(newValue)")
        }
    }
}
