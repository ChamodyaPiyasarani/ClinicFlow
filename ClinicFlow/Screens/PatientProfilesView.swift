//
//  PatientProfilesView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

struct PatientProfilesView: View {
    @Environment(AppRouter.self) var router
    @State private var profiles = PatientProfile.sampleProfiles
    @State private var showAddProfile = false
    
    var body: some View {
        VStack(spacing: 0) {
            // ── Header with Back Button ──
            ProfilesHeaderView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // ── Main Profile Card ──
                    MainProfileSection()
                        .padding(.top, 20)
                    
                    // ── My Profiles Section ──
                    MyProfilesSection(
                        profiles: profiles,
                        onAddProfile: { showAddProfile = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Space for bottom nav
            }
        }
        .background(AppColors.background)
        .alert("Add Profile", isPresented: $showAddProfile) {
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                // Future: Add new profile functionality
            }
        } message: {
            Text("Profile creation will be available in a future update.")
        }
    }
}

// MARK: - Header
private struct ProfilesHeaderView: View {
    @Environment(AppRouter.self) var router
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Back button (left aligned)
                HStack {
                    BackButton {
                        router.goBack()
                    }
                    Spacer()
                }
                
                // Centered title
                Text("CLINICFLOW")
                    .font(.poppins(.bold, size: 20))
                    .foregroundColor(AppColors.darkBlue)
            }
            
            // Profile subtitle
            Text("Profile")
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
    }
}

// MARK: - Main Profile Section
private struct MainProfileSection: View {
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ProfileAvatarView(
                avatarColor: Color(red: 200/255, green: 220/255, blue: 160/255),
                hairColor: Color(red: 139/255, green: 90/255, blue: 43/255),
                shirtColor: Color(red: 70/255, green: 130/255, blue: 220/255),
                size: 90
            )
            
            // Name
            Text("John Doe")
                .font(.poppins(.semiBold, size: 22))
                .foregroundColor(AppColors.darkBlue)
            
            // Patient ID
            Text("Patient ID: CF-2024-001")
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - My Profiles Section
private struct MyProfilesSection: View {
    let profiles: [PatientProfile]
    let onAddProfile: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with add button
            HStack {
                Text("My Profiles")
                    .font(.poppins(.semiBold, size: 20))
                    .foregroundColor(AppColors.brandBlue)
                
                Spacer()
                
                Button(action: {
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onAddProfile()
                }) {
                    Circle()
                        .fill(AppColors.brandBlue)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.bottom, 4)
            
            // Profile cards
            VStack(spacing: 12) {
                ForEach(profiles) { profile in
                    ProfileCardRow(profile: profile)
                }
            }
        }
    }
}

// MARK: - Profile Card Row
private struct ProfileCardRow: View {
    @Environment(AppRouter.self) var router
    let profile: PatientProfile
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Navigate to profile detail
            router.navigate(to: .profileDetails(profile))
        }) {
            HStack(spacing: 16) {
                // Avatar
                ProfileAvatarView(
                    avatarColor: profile.avatarColor,
                    hairColor: profile.hairColor,
                    shirtColor: profile.shirtColor,
                    size: 56
                )
                
                // Profile info
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.name)
                        .font(.poppins(.semiBold, size: 17))
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(profile.relationship)
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.gray)
                    
                    // Status badge
                    if let allergies = profile.allergiesCount, allergies > 0 {
                        Text("\(allergies) Allergies")
                            .font(.poppins(.medium, size: 12))
                            .foregroundColor(.red)
                    } else if profile.isActive {
                        Text("Active")
                            .font(.poppins(.medium, size: 12))
                            .foregroundColor(Color(red: 80/255, green: 180/255, blue: 100/255))
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.brandBlue.opacity(0.2), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Profile Avatar View (Reusable)
private struct ProfileAvatarView: View {
    let avatarColor: Color
    let hairColor: Color
    let shirtColor: Color
    let size: CGFloat
    
    private var faceSize: CGFloat { size * 0.35 }
    private var bodyWidth: CGFloat { size * 0.44 }
    private var bodyHeight: CGFloat { size * 0.27 }
    private var hairSize: CGFloat { size * 0.067 }
    private var eyeSize: CGFloat { size * 0.033 }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatarColor)
                .frame(width: size, height: size)
            
            // Simple avatar illustration
            VStack(spacing: size * 0.022) {
                // Head
                Circle()
                    .fill(Color(red: 240/255, green: 200/255, blue: 170/255))
                    .frame(width: faceSize, height: faceSize)
                    .overlay(
                        // Simple facial features
                        VStack(spacing: size * 0.033) {
                            // Hair/curls
                            HStack(spacing: size * 0.033) {
                                Circle().fill(hairColor)
                                    .frame(width: hairSize, height: hairSize)
                                Circle().fill(hairColor)
                                    .frame(width: hairSize, height: hairSize)
                                Circle().fill(hairColor)
                                    .frame(width: hairSize, height: hairSize)
                            }
                            .offset(y: -faceSize * 0.375)
                            
                            Spacer()
                            
                            // Eyes
                            HStack(spacing: size * 0.089) {
                                Circle().fill(Color.black)
                                    .frame(width: eyeSize, height: eyeSize)
                                Circle().fill(Color.black)
                                    .frame(width: eyeSize, height: eyeSize)
                            }
                            
                            // Smile arc
                            Path { path in
                                path.addArc(
                                    center: CGPoint(x: faceSize/2, y: faceSize * 0.625),
                                    radius: faceSize * 0.1875,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(180),
                                    clockwise: false
                                )
                            }
                            .stroke(Color.black, lineWidth: size * 0.011)
                            .frame(width: faceSize, height: faceSize)
                        }
                        .frame(width: faceSize, height: faceSize)
                    )
                
                // Body/shirt
                Capsule()
                    .fill(shirtColor)
                    .frame(width: bodyWidth, height: bodyHeight)
                    .offset(y: -size * 0.044)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PatientProfilesView()
        .environment(AppRouter())
}
