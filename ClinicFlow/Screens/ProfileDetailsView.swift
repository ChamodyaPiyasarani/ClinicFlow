import SwiftUI

struct ProfileDetailsView: View {
    @Environment(AppRouter.self) var router
    let profile: PatientProfile
    
    @State private var selectedTab: BottomTab = .account
    @State private var isEditing: Bool = false
    @State private var showAddAllergyAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var allergies: [String]
    
    init(profile: PatientProfile) {
        self.profile = profile
        self._allergies = State(initialValue: profile.allergies)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // ── Header ──
                ProfileDetailsHeaderView()
                
                // ── Scrollable Content ──
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // ── Profile Section ──
                        ProfileHeaderSection(profile: profile)
                            .padding(.top, 20)
                        
                        // ── Profile Details ──
                        VStack(spacing: 16) {
                            // Section title
                            HStack {
                                Text("Profile Details")
                                    .font(.poppins(.semiBold, size: 20))
                                    .foregroundColor(AppColors.darkBlue)
                                Spacer()
                            }
                            
                            // Personal Information
                            PersonalInformationSection(
                                profile: profile,
                                isEditing: $isEditing
                            )
                            
                            // Allergies
                            AllergiesSection(
                                allergies: $allergies,
                                onAdd: { showAddAllergyAlert = true },
                                onRemove: removeAllergy
                            )
                            
                            // Medical History
                            MedicalHistorySection(
                                records: profile.medicalHistory
                            )
                            
                            // Delete Profile Button
                            DeleteProfileButton(onDelete: { showDeleteAlert = true })
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) // Space for bottom nav
                    }
                }
            }
            .background(AppColors.background)
            
            // ── Bottom Navigation ──
            BottomNavBar(selectedTab: $selectedTab)
        }
        .navigationBarHidden(true)
        .alert("Add Allergy", isPresented: $showAddAllergyAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                // In a real app, this would save the allergy
                // For now, just simulate adding
            }
        } message: {
            Text("Enter the name of the allergy to add.")
        }
        .alert("Delete Profile", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // In a real app, this would delete the profile
                router.goBack()
            }
        } message: {
            Text("Are you sure you want to delete this profile? This action cannot be undone.")
        }
    }
    
    private func removeAllergy(at index: Int) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        _ = withAnimation {
            allergies.remove(at: index)
        }
    }
}

// MARK: - Header View
private struct ProfileDetailsHeaderView: View {
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            // Back button (left aligned)
            HStack {
                BackButton {
                    router.goBack()
                }
                Spacer()
            }
            
            // Centered title
            AppNameText(fontSize: 20)

            // Notification bell (right)
            HStack {
                Spacer()
                NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
    }
}

// MARK: - Profile Header Section
private struct ProfileHeaderSection: View {
    let profile: PatientProfile
    
    var body: some View {
        VStack(spacing: 12) {
            // Avatar
            ProfileAvatarView(
                avatarColor: profile.avatarColor,
                hairColor: profile.hairColor,
                shirtColor: profile.shirtColor,
                size: 80
            )
            
            // Name
            Text(profile.name)
                .font(.poppins(.semiBold, size: 22))
                .foregroundColor(AppColors.darkBlue)
            
            // Relationship
            Text(profile.relationship)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(.gray)
            
            // Status badge
            HStack(spacing: 6) {
                Text(profile.isActive ? "Active" : "Inactive")
                    .font(.poppins(.medium, size: 13))
                    .foregroundColor(profile.isActive ? Color(red: 80/255, green: 180/255, blue: 100/255) : Color.orange)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(profile.isActive ? Color(red: 80/255, green: 180/255, blue: 100/255).opacity(0.15) : Color.orange.opacity(0.15))
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Personal Information Section
private struct PersonalInformationSection: View {
    let profile: PatientProfile
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Personal Information")
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            
            VStack(spacing: 14) {
                InfoRow(label: "Full Name", value: profile.name, isEditing: isEditing)
                InfoRow(label: "Date of Birth", value: profile.dateOfBirth, isEditing: isEditing)
                InfoRow(label: "Gender", value: profile.gender, isEditing: isEditing)
                InfoRow(label: "Blood Type", value: profile.bloodType, isEditing: isEditing)
                InfoRow(label: "Phone", value: profile.phone, isEditing: isEditing)
                InfoRow(label: "Email", value: profile.email, isEditing: isEditing)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Info Row
private struct InfoRow: View {
    let label: String
    let value: String
    let isEditing: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(Color.gray)
                .frame(width: 110, alignment: .leading)
            
            if isEditing {
                TextField(value, text: .constant(value))
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.background)
                    )
            } else {
                Text(value)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                Spacer()
            }
        }
    }
}

// MARK: - Allergies Section
private struct AllergiesSection: View {
    @Binding var allergies: [String]
    let onAdd: () -> Void
    let onRemove: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Allergies")
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onAdd()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                        Text("Add")
                            .font(.poppins(.medium, size: 14))
                    }
                    .foregroundColor(AppColors.brandBlue)
                }
            }
            
            // Allergies list
            if allergies.isEmpty {
                Text("No allergies recorded")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(allergies.enumerated()), id: \.offset) { index, allergy in
                        AllergyRow(
                            allergy: allergy,
                            onRemove: { onRemove(index) }
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Allergy Row
private struct AllergyRow: View {
    let allergy: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14))
                .foregroundColor(.red)
            
            Text(allergy)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.red)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Remove \(allergy)")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.08))
        )
    }
}

// MARK: - Medical History Section
private struct MedicalHistorySection: View {
    let records: [MedicalRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Medical History")
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                Button(action: {
                    // View All - Not functional for now
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    Text("View All")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            
            // Records list
            if records.isEmpty {
                Text("No medical history recorded")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 12) {
                    ForEach(records) { record in
                        MedicalRecordRow(record: record)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Medical Record Row
private struct MedicalRecordRow: View {
    let record: MedicalRecord
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.title)
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundColor(AppColors.darkBlue)
                
                Text(record.provider)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(record.date)
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Delete Profile Button
private struct DeleteProfileButton: View {
    let onDelete: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onDelete()
        }) {
            Text("Delete Profile")
                .font(.poppins(.semiBold, size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.red)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .padding(.top, 8)
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
    ProfileDetailsView(profile: PatientProfile.sampleProfiles[0])
        .environment(AppRouter())
}
