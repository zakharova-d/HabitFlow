//
//  EmptyHabitsView.swift
//  HabitFlow
//
//  Created by Daria Zakharova on 22.07.2025.
//

import SwiftUI

struct EmptyHabitsView: View {
    var body: some View {
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
    }
}
