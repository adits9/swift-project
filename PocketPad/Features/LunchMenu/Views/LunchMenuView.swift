//
//  LunchMenuView.swift
//  PocketPad
//
//  View for lunch menu
//

import SwiftUI

struct LunchMenuView: View {
    @StateObject private var viewModel = LunchMenuViewModel()
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            // Date picker
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(Color(.systemBackground))
            .onChange(of: selectedDate) { _, newDate in
                Task {
                    await viewModel.loadMenu(for: newDate)
                }
            }
            
            Divider()
            
            // Menu content
            ScrollView {
                if let menu = viewModel.currentMenu {
                    VStack(alignment: .leading, spacing: 20) {
                        // Main Dish Section
                        MenuSection(
                            title: "Main Dish",
                            icon: "fork.knife",
                            color: .orange
                        ) {
                            Text(menu.mainDish)
                                .font(.body)
                        }
                        
                        // Sides Section
                        MenuSection(
                            title: "Sides",
                            icon: "leaf",
                            color: .green
                        ) {
                            ForEach(menu.sides, id: \.self) { side in
                                HStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: 6, height: 6)
                                    Text(side)
                                        .font(.body)
                                }
                            }
                        }
                        
                        // Vegetarian Option
                        if let vegOption = menu.vegetarianOption {
                            MenuSection(
                                title: "Vegetarian Option",
                                icon: "leaf.circle",
                                color: .green
                            ) {
                                Text(vegOption)
                                    .font(.body)
                            }
                        }
                        
                        // Dessert
                        if let dessert = menu.dessert {
                            MenuSection(
                                title: "Dessert",
                                icon: "birthday.cake",
                                color: .pink
                            ) {
                                Text(dessert)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                } else if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No menu available for this date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try selecting a different date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Lunch Menu")
        .task {
            await viewModel.loadMenu(for: selectedDate)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

struct MenuSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        LunchMenuView()
    }
}
