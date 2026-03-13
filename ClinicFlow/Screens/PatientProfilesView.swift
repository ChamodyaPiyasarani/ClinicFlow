import SwiftUI

struct PatientProfilesView: View {
    @Environment(AppRouter.self) var router
    @Environment(LanguageManager.self) var languageManager
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
                                showAddProfile = true
                            }
                        )
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
        .sheet(isPresented: $showAddProfile) {
            AddFamilyMemberForm(
                onSave: { newProfile in
                    profiles.append(newProfile)
                    showAddProfile = false
                },
                onCancel: {
                    showAddProfile = false
                }
            )
            .environment(languageManager)
            .environment(router)
        }
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
            }
            
            // Profile subtitle
            Text(languageManager.localized("profile"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

// MARK: - Main Profile Section
private struct MainProfileSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ProfessionalAvatarView(
                size: 90,
                gradientColors: [
                    Color(red: 200/255, green: 220/255, blue: 160/255),
                    Color(red: 160/255, green: 180/255, blue: 120/255)
                ]
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
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                Button(action: {
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onAddProfile()
                }) {
                    Circle()
                        .fill(AppColors.darkBlue)
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
                ProfessionalAvatarView(
                    size: 56,
                    gradientColors: [profile.avatarColor, profile.avatarColor.opacity(0.7)]
                )
                
                // Profile info
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.name)
                        .font(.poppins(.semiBold, size: 17))
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(profile.nickname ?? profile.relationship)
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.gray)
                    
                    // Status badge
                    if let allergies = profile.allergiesCount, allergies > 0 {
                        Text("\(allergies) \(languageManager.localized("allergies"))")
                            .font(.poppins(.medium, size: 13))
                            .foregroundColor(.red)
                    } else if profile.isActive {
                        Text(languageManager.localized("active"))
                            .font(.poppins(.medium, size: 13))
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
    @State private var nickname: String = ""
    @State private var relationship: String = ""
    @State private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var gender: String = "Male"
    @State private var bloodType: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var allergies: [String] = []
    @State private var newAllergyText: String = ""
    @State private var showAllergyField: Bool = false
    @State private var isActive: Bool = true
    
    private let genderOptions = ["Male", "Female", "Other"]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }
    
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
                ProfessionalAvatarView(size: 70)
                Spacer()
            }
            
            CustomTextField(placeholder: languageManager.localized("full_name"), text: $fullName)
            CustomTextField(placeholder: "Nickname (e.g., Mother, Daughter)", text: $nickname)
            CustomTextField(placeholder: languageManager.localized("relationship_placeholder"), text: $relationship)
            
            // Account Status Toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(languageManager.localized("account_status"))
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkBlue)
                    Text(isActive ? languageManager.localized("active") : "Inactive")
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(isActive ? Color(red: 80/255, green: 180/255, blue: 100/255) : .gray)
                }
                Spacer()
                Toggle("", isOn: $isActive)
                    .labelsHidden()
                    .tint(AppColors.brandBlue)
            }
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
            
            // Date of Birth Picker
            VStack(alignment: .leading, spacing: 6) {
                Text(languageManager.localized("dob_placeholder"))
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                
                DatePicker(
                    "",
                    selection: $dateOfBirth,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            
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
                    nickname: nickname.trimmingCharacters(in: .whitespaces).isEmpty ? nil : nickname.trimmingCharacters(in: .whitespaces),
                    relationship: relationship.trimmingCharacters(in: .whitespaces),
                    avatarColor: Color(red: .random(in: 0.6...0.85), green: .random(in: 0.7...0.9), blue: .random(in: 0.6...0.85)),
                    hairColor: Color(red: 139/255, green: 90/255, blue: 43/255),
                    shirtColor: AppColors.brandBlue,
                    isActive: isActive,
                    allergiesCount: allergies.isEmpty ? nil : allergies.count,
                    dateOfBirth: dateFormatter.string(from: dateOfBirth),
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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                headerSection
                profileSection
                informationSection
                allergiesSection
                actionButtons
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(AppColors.background)
    }
}

// MARK: - Profile Avatar View is now handled by ProfessionalAvatarView component

// MARK: - Preview
#Preview {
    PatientProfilesView()
        .environment(AppRouter())
        .environment(LanguageManager.shared)
}
