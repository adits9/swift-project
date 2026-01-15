//
//  SocialLinksView.swift
//  PocketPad
//
//  Social media links view
//

import SwiftUI

struct SocialLinksView: View {
    @State private var selectedURL: URL?
    @State private var showingSafari = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "megaphone.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Stay Connected")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Follow \(Config.schoolName) on social media")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Social links
                VStack(spacing: 16) {
                    ForEach(Config.socialLinks) { link in
                        SocialLinkButton(link: link) {
                            if let url = URL(string: link.url) {
                                selectedURL = url
                                showingSafari = true
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle("Social Links")
        .sheet(isPresented: $showingSafari) {
            if let url = selectedURL {
                SafariView(url: url)
            }
        }
    }
}

struct SocialLinkButton: View {
    let link: SocialLink
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: socialIcon(for: link.platform))
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(socialColor(for: link.platform))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(link.platform)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("@jeffersonhigh")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    private func socialIcon(for platform: String) -> String {
        switch platform.lowercased() {
        case "instagram": return "camera.fill"
        case "twitter": return "bird.fill"
        case "youtube": return "play.rectangle.fill"
        case "facebook": return "person.2.fill"
        default: return "link"
        }
    }
    
    private func socialColor(for platform: String) -> Color {
        switch platform.lowercased() {
        case "instagram": return Color(red: 0.8, green: 0.2, blue: 0.5)
        case "twitter": return Color(red: 0.1, green: 0.6, blue: 1.0)
        case "youtube": return .red
        case "facebook": return Color(red: 0.2, green: 0.4, blue: 0.8)
        default: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        SocialLinksView()
    }
}
