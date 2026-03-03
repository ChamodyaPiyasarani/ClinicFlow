//
//  OPDDepartmentsView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

struct OPDDepartmentsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    // Back button
                    HStack {
                        BackButton {
                            router.goBack()
                        }
                        Spacer()
                    }
                    
                    // Centered title
                    Text("OPD Departments")
                        .font(.poppins(.bold, size: 20))
                        .foregroundColor(AppColors.darkBlue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color.white)
                
                // MARK: - Department List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Section Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Available Departments")
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundColor(AppColors.darkBlue)
                                Text("Choose a department to continue")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Department Cards
                        LazyVStack(spacing: 12) {
                            DepartmentCard(
                                icon: "heart.text.square.fill",
                                iconColor: Color(red: 220/255, green: 80/255, blue: 100/255),
                                departmentName: "Cardiology",
                                description: "Heart and cardiovascular care",
                                availabilityStatus: .available,
                                waitingCount: 5
                            )
                            
                            DepartmentCard(
                                icon: "figure.walk",
                                iconColor: Color(red: 100/255, green: 140/255, blue: 200/255),
                                departmentName: "Orthopedics",
                                description: "Bone and joint specialists",
                                availabilityStatus: .available,
                                waitingCount: 8
                            )
                            
                            DepartmentCard(
                                icon: "figure.and.child.holdinghands",
                                iconColor: Color(red: 255/255, green: 150/255, blue: 100/255),
                                departmentName: "Pediatrics",
                                description: "Children's health care",
                                availabilityStatus: .available,
                                waitingCount: 3
                            )
                            
                            DepartmentCard(
                                icon: "allergens",
                                iconColor: Color(red: 160/255, green: 120/255, blue: 200/255),
                                departmentName: "Dermatology",
                                description: "Skin care and treatment",
                                availabilityStatus: .available,
                                waitingCount: 6
                            )
                            
                            DepartmentCard(
                                icon: "ear.fill",
                                iconColor: Color(red: 80/255, green: 170/255, blue: 160/255),
                                departmentName: "ENT",
                                description: "Ear, nose and throat specialists",
                                availabilityStatus: .busy,
                                waitingCount: 12
                            )
                            
                            DepartmentCard(
                                icon: "stethoscope",
                                iconColor: Color(red: 80/255, green: 170/255, blue: 100/255),
                                departmentName: "General Medicine",
                                description: "Primary care physicians",
                                availabilityStatus: .available,
                                waitingCount: 4
                            )
                            
                            DepartmentCard(
                                icon: "eye.fill",
                                iconColor: Color(red: 100/255, green: 120/255, blue: 180/255),
                                departmentName: "Ophthalmology",
                                description: "Eye care and vision",
                                availabilityStatus: .available,
                                waitingCount: 2
                            )
                            
                            DepartmentCard(
                                icon: "gyroscope",
                                iconColor: Color(red: 200/255, green: 100/255, blue: 150/255),
                                departmentName: "Neurology",
                                description: "Brain and nervous system",
                                availabilityStatus: .unavailable,
                                waitingCount: 0
                            )
                            
                            DepartmentCard(
                                icon: "lungs.fill",
                                iconColor: Color(red: 120/255, green: 180/255, blue: 220/255),
                                departmentName: "Pulmonology",
                                description: "Respiratory care",
                                availabilityStatus: .available,
                                waitingCount: 7
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
    }
}

// MARK: - Department Availability Status
enum DepartmentAvailability {
    case available
    case busy
    case unavailable
    
    var statusText: String {
        switch self {
        case .available:    return "Available"
        case .busy:         return "Busy"
        case .unavailable:  return "Closed"
        }
    }
    
    var statusColor: Color {
        switch self {
        case .available:    return Color(red: 80/255, green: 170/255, blue: 100/255)
        case .busy:         return Color(red: 255/255, green: 160/255, blue: 50/255)
        case .unavailable:  return Color.red.opacity(0.7)
        }
    }
}

// MARK: - Department Card Component
struct DepartmentCard: View {
    let icon: String
    let iconColor: Color
    let departmentName: String
    let description: String
    let availabilityStatus: DepartmentAvailability
    let waitingCount: Int
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Action will be implemented when navigation is added
        }) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                }
                
                // Department Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(departmentName)
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(description)
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    // Status and waiting count
                    HStack(spacing: 12) {
                        // Availability badge
                        HStack(spacing: 4) {
                            Circle()
                                .fill(availabilityStatus.statusColor)
                                .frame(width: 6, height: 6)
                            Text(availabilityStatus.statusText)
                                .font(.poppins(.medium, size: 11))
                                .foregroundColor(availabilityStatus.statusColor)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(availabilityStatus.statusColor.opacity(0.1))
                        .cornerRadius(6)
                        
                        // Waiting count (only show if available or busy)
                        if availabilityStatus != .unavailable && waitingCount > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 10))
                                Text("\(waitingCount) waiting")
                                    .font(.poppins(.regular, size: 11))
                            }
                            .foregroundColor(.gray.opacity(0.8))
                        }
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(
                color: Color.black.opacity(isPressed ? 0.08 : 0.04),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    
    OPDDepartmentsView()
        .environment(languageManager)
        .environment(router)
}
