import SwiftUI

struct ProfileDetailsView: View {
    @Environment(AppRouter.self) var router
    @Environment(LanguageManager.self) var languageManager
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
                                Text(languageManager.localized("profile_details"))
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
        .alert(languageManager.localized("add_allergy"), isPresented: $showAddAllergyAlert) {
            Button(languageManager.localized("cancel"), role: .cancel) { }
            Button(languageManager.localized("add")) {
                // In a real app, this would save the allergy
                // For now, just simulate adding
            }
        } message: {
            Text(languageManager.localized("add_allergy_message"))
        }
        .alert(languageManager.localized("delete_profile"), isPresented: $showDeleteAlert) {
            Button(languageManager.localized("cancel"), role: .cancel) { }
            Button(languageManager.localized("delete"), role: .destructive) {
                // In a real app, this would delete the profile
                router.goBack()
            }
        } message: {
            Text(languageManager.localized("delete_profile_message"))
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

            // Trailing icons (right)
            HStack(spacing: 4) {
                Spacer()
                LanguageSwitcher(fontSize: 14, showBackground: false)
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
    @Environment(LanguageManager.self) var languageManager
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
                Text(profile.isActive ? languageManager.localized("active") : languageManager.localized("inactive"))
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
    @Environment(LanguageManager.self) var languageManager
    let profile: PatientProfile
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text(languageManager.localized("personal_information"))
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
                    Text(isEditing ? languageManager.localized("done") : languageManager.localized("edit"))
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            
            VStack(spacing: 14) {
                InfoRow(label: languageManager.localized("full_name"), value: profile.name, isEditing: isEditing)
                InfoRow(label: languageManager.localized("date_of_birth"), value: profile.dateOfBirth, isEditing: isEditing)
                InfoRow(label: languageManager.localized("gender"), value: profile.gender, isEditing: isEditing)
                InfoRow(label: languageManager.localized("blood_type"), value: profile.bloodType, isEditing: isEditing)
                InfoRow(label: languageManager.localized("phone"), value: profile.phone, isEditing: isEditing)
                InfoRow(label: languageManager.localized("email"), value: profile.email, isEditing: isEditing)
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
    @Environment(LanguageManager.self) var languageManager
    @Binding var allergies: [String]
    let onAdd: () -> Void
    let onRemove: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text(languageManager.localized("allergies"))
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
                        Text(languageManager.localized("add"))
                            .font(.poppins(.medium, size: 14))
                    }
                    .foregroundColor(AppColors.brandBlue)
                }
            }
            
            // Allergies list
            if allergies.isEmpty {
                Text(languageManager.localized("no_allergies_recorded"))
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
    @Environment(LanguageManager.self) var languageManager
    let records: [MedicalRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text(languageManager.localized("medical_history"))
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                Button(action: {
                    // View All - Not functional for now
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    Text(languageManager.localized("view_all"))
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            
            // Records list
            if records.isEmpty {
                Text(languageManager.localized("no_medical_history"))
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
    @Environment(LanguageManager.self) var languageManager
    let onDelete: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onDelete()
        }) {
            Text(languageManager.localized("delete_profile"))
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
