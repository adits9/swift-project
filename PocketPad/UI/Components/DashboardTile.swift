//
//  DashboardTile.swift
//  PocketPad
//
//  Reusable dashboard tile component
//

import SwiftUI

struct DashboardTile: View {
    let icon: String
    let title: String
    let color: Color
    let destination: DashboardDestination
    
    @Environment(\.selectedDestination) private var selectedDestination
    
    var body: some View {
        Button(action: {
            selectedDestination.wrappedValue = destination
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) button")
    }
}

#Preview {
    DashboardTile(
        icon: "calendar",
        title: "Schedule",
        color: .blue,
        destination: .schedule
    )
    .padding()
}
