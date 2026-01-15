//
//  EmailStaffView.swift
//  PocketPad
//
//  View for emailing teachers/staff
//

import SwiftUI
import MessageUI

struct EmailStaffView: View {
    @StateObject private var viewModel = EmailStaffViewModel()
    @State private var searchText = ""
    @State private var selectedRole = "All"
    @State private var showingMailComposer = false
    @State private var selectedStaff: StaffDirectoryEntry?
    
    let roles = ["All", "Teacher", "Counselor", "Administrator"]
    
    var filteredStaff: [StaffDirectoryEntry] {
        var staff = viewModel.staffMembers
        
        if selectedRole != "All" {
            staff = staff.filter { $0.role == selectedRole }
        }
        
        if !searchText.isEmpty {
            staff = staff.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText) ||
                ($0.subjectTaught?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return staff
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Role filter
            Picker("Role", selection: $selectedRole) {
                ForEach(roles, id: \.self) { role in
                    Text(role).tag(role)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if filteredStaff.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No staff found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List(filteredStaff) { staff in
                    StaffDirectoryRow(staff: staff) {
                        selectedStaff = staff
                        showingMailComposer = true
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Email Staff")
        .searchable(text: $searchText, prompt: "Search staff")
        .task {
            await viewModel.loadStaff()
        }
        .sheet(isPresented: $showingMailComposer) {
            if let staff = selectedStaff {
                MailComposeView(
                    recipient: staff.email,
                    subject: "Question from Student",
                    body: "\n\n---\nSent from PocketPad"
                )
            }
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

struct StaffDirectoryRow: View {
    let staff: StaffDirectoryEntry
    let onEmailTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(staff.name)
                        .font(.headline)
                    
                    Text(staff.role)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(roleColor(for: staff.role))
                        .cornerRadius(4)
                }
                
                Spacer()
            }
            
            if let subject = staff.subjectTaught, !subject.isEmpty {
                Label(subject, systemImage: "book")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let dept = staff.department, !dept.isEmpty {
                Label(dept, systemImage: "building.2")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let ext = staff.phoneExtension {
                Label("Ext. \(ext)", systemImage: "phone")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button(action: onEmailTap) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text(staff.email)
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    private func roleColor(for role: String) -> Color {
        switch role {
        case "Teacher": return .blue
        case "Counselor": return .green
        case "Administrator": return .purple
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        EmailStaffView()
    }
}
