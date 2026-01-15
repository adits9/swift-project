//
//  CalendarView.swift
//  PocketPad
//
//  School calendar view
//

import SwiftUI
import SafariServices

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var showingSafari = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Local date picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Date Reference")
                    .font(.headline)
                    .padding(.horizontal)
                
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Divider()
            
            // School calendar link
            VStack(spacing: 16) {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("View School Calendar")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Access the full school calendar with events, holidays, and important dates")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    showingSafari = true
                }) {
                    Label("Open School Calendar", systemImage: "arrow.up.right.square")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Calendar")
        .sheet(isPresented: $showingSafari) {
            SafariView(url: URL(string: Config.schoolCalendarURL)!)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
