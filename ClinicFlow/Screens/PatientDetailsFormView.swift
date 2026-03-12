import SwiftUI
import PhotosUI

// MARK: - Main View

struct PatientDetailsFormView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager

    let doctor: Doctor
    let department: ClinicDepartment
    let selectedDate: Date
    let selectedTimeSlot: TimeSlot

    @State private var selectedProfile: PatientProfile? = nil
    @State private var contactNumber: String = ""
    @State private var reasonForVisit: String = ""
    @State private var showProfilePicker = false
    @State private var uploadedFileName: String? = nil
    @State private var showDiscardAlert = false

    // Photo picker
    @State private var selectedPhoto: PhotosPickerItem? = nil

    private var isFormValid: Bool {
        selectedProfile != nil && !contactNumber.isEmpty && !reasonForVisit.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            PatientFormHeaderView(subtitle: languageManager.localized("fill_patient_details"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    // ── Step Indicator ──
                    StepIndicator(currentStep: 2, totalSteps: 3)
                        .padding(.top, 4)

                    // ── Patient Profile ──
                    FormSectionCard {
                        FormFieldLabel(title: languageManager.localized("patient_profile"))

                        Button(action: { showProfilePicker = true }) {
                            HStack(spacing: 12) {
                                if let profile = selectedProfile {
                                    profileAvatar(name: profile.name)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(profile.name)
                                            .font(.poppins(.medium, size: 15))
                                            .foregroundColor(AppColors.darkBlue)
                                        Text(profile.relationship)
                                            .font(.poppins(.regular, size: 12))
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.brandBlue.opacity(0.5))
                                    Text(languageManager.localized("select_patient"))
                                        .font(.poppins(.regular, size: 15))
                                        .foregroundColor(.gray.opacity(0.6))
                                }
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    // ── Contact Number ──
                    FormSectionCard {
                        FormFieldLabel(title: languageManager.localized("contact_number"))

                        CustomTextField(
                            placeholder: "+94 XX XXX XXXX",
                            text: $contactNumber,
                            keyboardType: .phonePad
                        )
                    }

                    // ── Reason for Visit ──
                    FormSectionCard {
                        FormFieldLabel(title: languageManager.localized("reason_for_visit"))

                        ZStack(alignment: .topLeading) {
                            if reasonForVisit.isEmpty {
                                Text(languageManager.localized("reason_placeholder"))
                                    .font(.poppins(.regular, size: 15))
                                    .foregroundColor(.gray.opacity(0.45))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 18)
                            }
                            TextEditor(text: $reasonForVisit)
                                .font(.poppins(.regular, size: 15))
                                .frame(minHeight: 100)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // ── Upload Reports ──
                    FormSectionCard {
                        HStack {
                            FormFieldLabel(title: languageManager.localized("upload_reports"))
                            Text("(\(languageManager.localized("optional")))")
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.gray)
                        }

                        // Upload area
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            VStack(spacing: 10) {
                                if let fileName = uploadedFileName {
                                    // File uploaded state
                                    HStack(spacing: 10) {
                                        Image(systemName: "doc.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(AppColors.brandBlue)
                                        Text(fileName)
                                            .font(.poppins(.medium, size: 14))
                                            .foregroundColor(AppColors.darkBlue)
                                            .lineLimit(1)
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .padding(16)
                                } else {
                                    // Empty upload area
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.brandBlue.opacity(0.08))
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "arrow.up.doc.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(AppColors.brandBlue)
                                    }
                                    .padding(.top, 8)

                                    Text(languageManager.localized("upload_medical_reports"))
                                        .font(.poppins(.medium, size: 14))
                                        .foregroundColor(AppColors.darkBlue)

                                    Text(languageManager.localized("jpg_png_supported"))
                                        .font(.poppins(.regular, size: 12))
                                        .foregroundColor(.gray)

                                    Text(languageManager.localized("choose_from_gallery"))
                                        .font(.poppins(.semiBold, size: 14))
                                        .foregroundColor(AppColors.brandBlue)
                                        .padding(.bottom, 8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(
                                        style: StrokeStyle(lineWidth: 1.5, dash: [6])
                                    )
                                    .foregroundColor(AppColors.brandBlue.opacity(0.3))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onChange(of: selectedPhoto) { _, newItem in
                            if newItem != nil {
                                uploadedFileName = "medical_report.jpg"
                                toastManager.show(.success, message: "toast_image_uploaded")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }

            // ── Action Buttons ──
            HStack(spacing: 14) {
                // Discard button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showDiscardAlert = true
                }) {
                    Text(languageManager.localized("discard"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppColors.darkBlue.opacity(0.3), lineWidth: 1.5)
                        )
                }

                // Next button
                Button(action: {
                    guard let profile = selectedProfile else { return }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    router.navigate(to: .appointmentReview(
                        doctor: doctor,
                        department: department,
                        date: selectedDate,
                        timeSlot: selectedTimeSlot,
                        patientName: profile.name,
                        contactNumber: contactNumber,
                        reasonForVisit: reasonForVisit
                    ))
                }) {
                    Text(languageManager.localized("next"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isFormValid ? AppColors.brandBlue : AppColors.brandBlue.opacity(0.4))
                        )
                }
                .disabled(!isFormValid)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            )
            
            BottomNavBar()
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .sheet(isPresented: $showProfilePicker) {
            PatientProfileSheet(selectedProfile: $selectedProfile)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .environment(languageManager)
                .environment(router)
        }
        .alert(languageManager.localized("discard_appointment"), isPresented: $showDiscardAlert) {
            Button(languageManager.localized("cancel"), role: .cancel) { }
            Button(languageManager.localized("discard"), role: .destructive) {
                router.goBack()
                router.goBack()
            }
        } message: {
            Text(languageManager.localized("discard_appointment_message"))
        }
    }

    // MARK: - Profile Avatar

    private func profileAvatar(name: String) -> some View {
        let initials = name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
        return ZStack {
            Circle()
                .fill(AppColors.brandBlue.opacity(0.12))
                .frame(width: 40, height: 40)
            Text(initials)
                .font(.poppins(.semiBold, size: 14))
                .foregroundColor(AppColors.brandBlue)
        }
    }
}

// MARK: - Patient Form Header

private struct PatientFormHeaderView: View {
    @Environment(AppRouter.self) var router
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                HStack {
                    BackButton { router.goBack() }
                    Spacer()
                }
                AppNameText(fontSize: 20)
                HStack(spacing: 4) {
                    Spacer()
                    NotificationIcon(unreadCount: 3, iconSize: 22)
                }
            }
            Text(subtitle)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

// MARK: - Step Indicator

private struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? AppColors.brandBlue : Color.gray.opacity(0.15))
                    .frame(height: 4)
            }
        }
    }
}

// MARK: - Form Section Card

private struct FormSectionCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Form Field Label

private struct FormFieldLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.poppins(.semiBold, size: 15))
            .foregroundColor(AppColors.darkBlue)
    }
}

// MARK: - Patient Profile Sheet

private struct PatientProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedProfile: PatientProfile?

    private let profiles = PatientProfile.sampleProfiles

    var body: some View {
        NavigationStack {
            List(profiles) { profile in
                Button(action: {
                    selectedProfile = profile
                    dismiss()
                }) {
                    HStack(spacing: 14) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(AppColors.brandBlue.opacity(0.12))
                                .frame(width: 44, height: 44)
                            Text(avatarInitials(profile.name))
                                .font(.poppins(.semiBold, size: 15))
                                .foregroundColor(AppColors.brandBlue)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(profile.name)
                                .font(.poppins(.medium, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                            Text(profile.relationship)
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        if selectedProfile?.id == profile.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.brandBlue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(languageManager.localized("patient_profile"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func avatarInitials(_ name: String) -> String {
        name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

// MARK: - Preview

#Preview {
    PatientDetailsFormView(
        doctor: Doctor.samples[0],
        department: ClinicDepartment.samples[0],
        selectedDate: Date(),
        selectedTimeSlot: TimeSlot.generateSlots()[0]
    )
    .environment(LanguageManager.shared)
    .environment(AppRouter())
}
