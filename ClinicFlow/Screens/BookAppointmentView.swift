import SwiftUI

// MARK: - Main View

struct BookAppointmentView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    @State private var selectedDepartment: ClinicDepartment? = nil
    @State private var selectedDoctor: Doctor? = nil
    @State private var selectedDate: Date = Date()
    @State private var selectedTimeSlot: TimeSlot? = nil
    @State private var timeSlots: [TimeSlot] = TimeSlot.generateSlots()

    @State private var showDepartmentPicker = false
    @State private var showDoctorPicker = false

    private var filteredDoctors: [Doctor] {
        guard let dept = selectedDepartment else { return [] }
        return Doctor.samples.filter { $0.department == dept.id }
    }

    private var isFormValid: Bool {
        selectedDepartment != nil && selectedDoctor != nil && selectedTimeSlot != nil
    }

    // Calendar helpers
    private var currentWeekDates: [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: selectedDate)
        return (-3...3).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            BookingHeaderView(subtitle: languageManager.localized("book_new_appointment"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // ── Department Selection ──
                    SectionContainer {
                        SectionLabel(title: languageManager.localized("select_department"))

                        DropdownButton(
                            placeholder: languageManager.localized("select_department_placeholder"),
                            value: selectedDepartment.map { languageManager.localized($0.localizationKey) },
                            icon: selectedDepartment?.icon
                        ) {
                            showDepartmentPicker = true
                        }
                    }

                    // ── Doctor Selection ──
                    if selectedDepartment != nil {
                        SectionContainer {
                            SectionLabel(title: languageManager.localized("select_doctor"))

                            // Specialization (auto-filled)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(languageManager.localized("doctors_specialization"))
                                    .font(.poppins(.medium, size: 13))
                                    .foregroundColor(.gray)

                                Text(selectedDepartment.map { languageManager.localized($0.localizationKey) } ?? "")
                                    .font(.poppins(.regular, size: 15))
                                    .foregroundColor(AppColors.darkBlue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(AppColors.brandBlue.opacity(0.05))
                                    .cornerRadius(12)
                            }

                            // Doctor name dropdown
                            VStack(alignment: .leading, spacing: 6) {
                                Text(languageManager.localized("doctors_name"))
                                    .font(.poppins(.medium, size: 13))
                                    .foregroundColor(.gray)

                                DropdownButton(
                                    placeholder: languageManager.localized("select_doctor_placeholder"),
                                    value: selectedDoctor?.name,
                                    icon: nil
                                ) {
                                    showDoctorPicker = true
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // ── Date & Time Selection ──
                    if selectedDoctor != nil {
                        SectionContainer {
                            SectionLabel(title: languageManager.localized("available_date_time"))

                            // Month navigator
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate) ?? selectedDate
                                        timeSlots = TimeSlot.generateSlots()
                                        selectedTimeSlot = nil
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.darkBlue)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(AppColors.brandBlue.opacity(0.08)))
                                }

                                Spacer()

                                Text(monthYearString)
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundColor(AppColors.darkBlue)

                                Spacer()

                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate) ?? selectedDate
                                        timeSlots = TimeSlot.generateSlots()
                                        selectedTimeSlot = nil
                                    }
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.darkBlue)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(AppColors.brandBlue.opacity(0.08)))
                                }
                            }
                            .padding(.bottom, 8)

                            // Week day strip
                            HStack(spacing: 0) {
                                ForEach(currentWeekDates, id: \.self) { date in
                                    let cal = Calendar.current
                                    let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
                                    let isToday = cal.isDateInToday(date)
                                    let dayName = dayAbbreviation(date)
                                    let dayNum = cal.component(.day, from: date)

                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedDate = date
                                            timeSlots = TimeSlot.generateSlots()
                                            selectedTimeSlot = nil
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Text("\(dayNum)")
                                                .font(.poppins(.bold, size: 16))
                                                .foregroundColor(isSelected ? .white : (isToday ? AppColors.brandBlue : AppColors.darkBlue))

                                            Text(dayName)
                                                .font(.poppins(.medium, size: 11))
                                                .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(isSelected ? AppColors.brandBlue : Color.clear)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.gray.opacity(0.06))
                            )

                            // Time slots
                            VStack(alignment: .leading, spacing: 10) {
                                Text(languageManager.localized("select_time"))
                                    .font(.poppins(.medium, size: 13))
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)

                                // Use a flexible grid layout
                                let columns = [GridItem(.adaptive(minimum: 90), spacing: 10)]
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(timeSlots.filter(\.isAvailable)) { slot in
                                        let isSelected = selectedTimeSlot?.id == slot.id
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                selectedTimeSlot = slot
                                            }
                                        }) {
                                            Text(slot.time)
                                                .font(.poppins(.medium, size: 13))
                                                .foregroundColor(isSelected ? .white : AppColors.darkBlue)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 10)
                                                .frame(maxWidth: .infinity)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(isSelected ? AppColors.brandBlue : Color.white)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                                                )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedDepartment?.id)
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedDoctor?.id)
            }

            // ── Next Button ──
            VStack {
                PrimaryButton(title: languageManager.localized("next")) {
                    guard let dept = selectedDepartment,
                          let doc = selectedDoctor,
                          let slot = selectedTimeSlot else { return }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    router.navigate(to: .patientDetailsForm(doctor: doc, department: dept, date: selectedDate, timeSlot: slot))
                }
                .opacity(isFormValid ? 1.0 : 0.5)
                .disabled(!isFormValid)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            )

            // ── Bottom Nav Bar ──
            BottomNavBar()
        }
        .background(AppColors.background)
        .sheet(isPresented: $showDepartmentPicker) {
            SelectionSheet(
                title: languageManager.localized("select_department"),
                items: ClinicDepartment.samples,
                selectedId: selectedDepartment?.id,
                displayName: { languageManager.localized($0.localizationKey) },
                icon: { $0.icon },
                iconColor: { $0.color }
            ) { dept in
                withAnimation {
                    selectedDepartment = dept
                    selectedDoctor = nil
                    selectedTimeSlot = nil
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showDoctorPicker) {
            SelectionSheet(
                title: languageManager.localized("select_doctor"),
                items: filteredDoctors,
                selectedId: selectedDoctor?.id,
                displayName: { $0.name },
                icon: { _ in "stethoscope" },
                iconColor: { _ in AppColors.brandBlue }
            ) { doc in
                withAnimation {
                    selectedDoctor = doc
                    selectedTimeSlot = nil
                    timeSlots = TimeSlot.generateSlots()
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
}

// MARK: - Booking Header

private struct BookingHeaderView: View {
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
                    NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                }
            }

            Text(subtitle)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

// MARK: - Section Container

private struct SectionContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
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

// MARK: - Section Label

private struct SectionLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.poppins(.bold, size: 17))
            .foregroundColor(AppColors.darkBlue)
    }
}

// MARK: - Dropdown Button

private struct DropdownButton: View {
    let placeholder: String
    let value: String?
    let icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.brandBlue)
                }

                Text(value ?? placeholder)
                    .font(.poppins(.regular, size: 15))
                    .foregroundColor(value != nil ? AppColors.darkBlue : .gray.opacity(0.5))

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
}

// MARK: - Selection Sheet

private struct SelectionSheet<T: Identifiable & Hashable>: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let items: [T]
    let selectedId: String?
    let displayName: (T) -> String
    let icon: (T) -> String
    let iconColor: (T) -> Color
    let onSelect: (T) -> Void

    var body: some View {
        NavigationStack {
            List(items) { item in
                Button(action: {
                    onSelect(item)
                    dismiss()
                }) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(iconColor(item).opacity(0.12))
                                .frame(width: 40, height: 40)
                            Image(systemName: icon(item))
                                .font(.system(size: 18))
                                .foregroundColor(iconColor(item))
                        }

                        Text(displayName(item))
                            .font(.poppins(.medium, size: 16))
                            .foregroundColor(AppColors.darkBlue)

                        Spacer()

                        if "\(item.id)" == selectedId {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.brandBlue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    BookAppointmentView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
