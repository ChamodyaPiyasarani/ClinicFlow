import SwiftUI

struct PatientProfilesView: View {
    @Environment(AppRouter.self) var router
    @State private var profiles = PatientProfile.sampleProfiles
    @State private var showAddProfile = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                            onAddProfile: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showAddProfile = true
                                }
                            }
                        )
                        
                        // ── Inline Add Family Member Form ──
                        if showAddProfile {
                            AddFamilyMemberForm(
                                onSave: { newProfile in
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        profiles.append(newProfile)
                                        showAddProfile = false
                                    }
                                },
                                onCancel: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showAddProfile = false
                                    }
                                }
                            )
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Space for bottom nav
                }
            }
            .background(AppColors.background)
            
            // ── Bottom Navigation Bar ──
            BottomNavBar()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Header
private struct ProfilesHeaderView: View {
    @Environment(AppRouter.self) var router
    @Environment(LanguageManager.self) var languageManager
    
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
                AppNameText(fontSize: 20)

                // Trailing icons (right)
                HStack(spacing: 4) {
                    Spacer()
                    LanguageSwitcher(fontSize: 14, showBackground: false)
                    NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                }
            }
            
            // Profile subtitle
            Text(languageManager.localized("profile"))
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
    @Environment(LanguageManager.self) var languageManager

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
            Text("\(languageManager.localized("patient_id_label")): CF-2024-001")
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - My Profiles Section
private struct MyProfilesSection: View {
    @Environment(LanguageManager.self) var languageManager
    let profiles: [PatientProfile]
    let onAddProfile: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with add button
            HStack {
                Text(languageManager.localized("my_profiles"))
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
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .accessibilityLabel("Add profile")
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
    @Environment(LanguageManager.self) var languageManager
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
                        Text("\(allergies) \(languageManager.localized("allergies"))")
                            .font(.poppins(.medium, size: 12))
                            .foregroundColor(.red)
                    } else if profile.isActive {
                        Text(languageManager.localized("active"))
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
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
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

// MARK: - Add Family Member Form
private struct AddFamilyMemberForm: View {
    @Environment(LanguageManager.self) var languageManager
    let onSave: (PatientProfile) -> Void
    let onCancel: () -> Void
    
    @State private var fullName: String = ""
    @State private var relationship: String = ""
    @State private var dateOfBirth: String = ""
    @State private var gender: String = "Male"
    @State private var bloodType: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var allergies: [String] = []
    @State private var newAllergyText: String = ""
    @State private var showAllergyField: Bool = false
    
    private let genderOptions = ["Male", "Female", "Other"]
    
    private func localizedGender(_ gender: String) -> String {
        switch gender {
        case "Male": return languageManager.localized("male")
        case "Female": return languageManager.localized("female")
        case "Other": return languageManager.localized("other_gender")
        default: return gender
        }
    }
    
    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !relationship.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var headerSection: some View {
        HStack {
            Text(languageManager.localized("add_family_member"))
                .font(.poppins(.bold, size: 20))
                .foregroundColor(AppColors.darkBlue)
            
            Spacer()
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                onCancel()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Cancel adding family member")
        }
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(languageManager.localized("profile"))
                .font(.poppins(.semiBold, size: 17))
                .foregroundColor(AppColors.darkBlue)
            
            // Avatar preview
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(AppColors.brandBlue.opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.brandBlue)
                }
                Spacer()
            }
            
            CustomTextField(placeholder: languageManager.localized("full_name"), text: $fullName)
            CustomTextField(placeholder: languageManager.localized("relationship_placeholder"), text: $relationship)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(languageManager.localized("information"))
                .font(.poppins(.semiBold, size: 17))
                .foregroundColor(AppColors.darkBlue)
            
            CustomTextField(placeholder: languageManager.localized("dob_placeholder"), text: $dateOfBirth)
            
            // Gender picker
            VStack(alignment: .leading, spacing: 6) {
                Text(languageManager.localized("gender"))
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 10) {
                    ForEach(genderOptions, id: \.self) { option in
                        Button(action: {
                            gender = option
                        }) {
                            Text(localizedGender(option))
                                .font(.poppins(.medium, size: 14))
                                .foregroundColor(gender == option ? .white : AppColors.darkBlue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(gender == option ? AppColors.brandBlue : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(gender == option ? Color.clear : Color.gray.opacity(0.25), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            CustomTextField(placeholder: languageManager.localized("blood_type_placeholder"), text: $bloodType)
            CustomTextField(placeholder: languageManager.localized("phone_number"), text: $phone, keyboardType: .phonePad)
            CustomTextField(placeholder: languageManager.localized("email_address"), text: $email, keyboardType: .emailAddress)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private var allergiesSection: some View {
        allergiesSectionContent
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var allergiesSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            allergiesHeader
            
            if allergies.isEmpty && !showAllergyField {
                Text(languageManager.localized("no_allergies_added"))
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            
            if !allergies.isEmpty {
                allergiesList
            }
            
            if showAllergyField {
                allergyInputField
            }
        }
    }
    
    private var allergiesHeader: some View {
        HStack {
            Text(languageManager.localized("allergies"))
                .font(.poppins(.semiBold, size: 17))
                .foregroundColor(AppColors.darkBlue)
            
            Spacer()
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    showAllergyField = true
                }
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
    }
    
    private var allergiesList: some View {
        VStack(spacing: 10) {
            ForEach(Array(allergies.enumerated()), id: \.offset) { index, allergy in
                allergyTag(allergy: allergy, index: index)
            }
        }
    }
    
    private func allergyTag(allergy: String, index: Int) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14))
                .foregroundColor(.red)
            
            Text(allergy)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.red)
            
            Spacer()
            
            Button(action: {
                let _ = withAnimation {
                    self.allergies.remove(at: index)
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Remove \(allergy)")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.08) as Color)
        )
    }
    
    private var allergyInputField: some View {
        HStack(spacing: 10) {
            CustomTextField(placeholder: languageManager.localized("allergy_name_placeholder"), text: $newAllergyText)
            
            Button(action: {
                let trimmed = newAllergyText.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return }
                withAnimation {
                    allergies.append(trimmed)
                    newAllergyText = ""
                    showAllergyField = false
                }
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(AppColors.brandBlue)
                    .cornerRadius(12)
            }
            .accessibilityLabel("Confirm allergy")
            
            Button(action: {
                withAnimation {
                    newAllergyText = ""
                    showAllergyField = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            .accessibilityLabel("Cancel adding allergy")
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: languageManager.localized("save_profile")) {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                
                let newProfile = PatientProfile(
                    id: "CF-2024-\(Int.random(in: 100...999))",
                    name: fullName.trimmingCharacters(in: .whitespaces),
                    relationship: relationship.trimmingCharacters(in: .whitespaces),
                    avatarColor: Color(red: .random(in: 0.6...0.85), green: .random(in: 0.7...0.9), blue: .random(in: 0.6...0.85)),
                    hairColor: Color(red: 139/255, green: 90/255, blue: 43/255),
                    shirtColor: AppColors.brandBlue,
                    isActive: true,
                    allergiesCount: allergies.isEmpty ? nil : allergies.count,
                    dateOfBirth: dateOfBirth,
                    gender: gender,
                    bloodType: bloodType,
                    phone: phone,
                    email: email,
                    allergies: allergies,
                    medicalHistory: []
                )
                onSave(newProfile)
            }
            .opacity(isFormValid ? 1.0 : 0.5)
            .disabled(!isFormValid)
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                onCancel()
            }) {
                Text(languageManager.localized("cancel"))
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection
            profileSection
            informationSection
            allergiesSection
            actionButtons
        }
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
