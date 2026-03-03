//
//  LabTestsView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

struct LabTestsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @State private var selectedCategory: TestCategory = .all
    @State private var searchText: String = ""
    @State private var showInfoModal: Bool = true
    @State private var showConfirmationModal: Bool = false
    
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
                    Text("Lab Tests")
                        .font(.poppins(.bold, size: 20))
                        .foregroundColor(AppColors.darkBlue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color.white)
                
                // MARK: - Search Bar
                HStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        TextField("Search lab tests...", text: $searchText)
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(AppColors.darkBlue)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // MARK: - Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(TestCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = category
                                }
                                // Haptic feedback
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                
                // MARK: - Test List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Section Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Available Tests")
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundColor(AppColors.darkBlue)
                                Text(filteredTests.count == 1 ? "1 test available" : "\(filteredTests.count) tests available")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            // Sort button
                            Button(action: {
                                // Sort action
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            }) {
                                HStack(spacing: 4) {
                                    Text("Sort")
                                        .font(.poppins(.medium, size: 13))
                                    Image(systemName: "arrow.up.arrow.down")
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(AppColors.brandBlue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.brandBlue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        
                        // Test Cards
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTests) { test in
                                LabTestCard(test: test) {
                                    // Show confirmation modal when test card is tapped
                                    showConfirmationModal = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
            }
            
            // MARK: - Info Modal Overlay
            if showInfoModal {
                LabTestInfoView(isPresented: $showInfoModal) {
                    // Proceed to view lab tests after dismissing modal
                    print("User acknowledged lab test instructions")
                }
                .zIndex(1)
            }
            
            // MARK: - Confirmation Modal Overlay
            if showConfirmationModal {
                LabTestConfirmationView(isPresented: $showConfirmationModal) {
                    // Action after confirming test details
                    print("User confirmed lab test - adding to queue")
                }
                .zIndex(2)
            }
        }
    }
    
    // Filter tests based on category and search
    var filteredTests: [LabTest] {
        var tests = mockLabTests
        
        // Filter by category
        if selectedCategory != .all {
            tests = tests.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            tests = tests.filter { test in
                test.name.localizedCaseInsensitiveContains(searchText) ||
                test.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return tests
    }
}

// MARK: - Test Category Enum
enum TestCategory: String, CaseIterable {
    case all = "All"
    case blood = "Blood"
    case urine = "Urine"
    case imaging = "Imaging"
    case cardiac = "Cardiac"
    case metabolic = "Metabolic"
    case infectious = "Infectious"
    
    var icon: String {
        switch self {
        case .all:        return "list.bullet"
        case .blood:      return "drop.fill"
        case .urine:      return "flask.fill"
        case .imaging:    return "xmark.circle.fill"
        case .cardiac:    return "heart.fill"
        case .metabolic:  return "chart.line.uptrend.xyaxis"
        case .infectious: return "bandage.fill"
        }
    }
}

// MARK: - Category Chip Component
struct CategoryChip: View {
    let category: TestCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .font(.poppins(.medium, size: 14))
            }
            .foregroundColor(isSelected ? .white : AppColors.darkBlue)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? AppColors.brandBlue : Color.white)
            .cornerRadius(20)
            .shadow(
                color: isSelected ? AppColors.brandBlue.opacity(0.3) : Color.black.opacity(0.04),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
        }
    }
}

// MARK: - Lab Test Model
struct LabTest: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: TestCategory
    let price: Double
    let duration: String
    let availability: TestAvailability
    let preparationRequired: Bool
    let icon: String
    let iconColor: Color
}

// MARK: - Test Availability Status
enum TestAvailability {
    case available
    case limitedSlots
    case unavailable
    
    var statusText: String {
        switch self {
        case .available:     return "Available"
        case .limitedSlots:  return "Limited"
        case .unavailable:   return "Unavailable"
        }
    }
    
    var statusColor: Color {
        switch self {
        case .available:     return Color(red: 80/255, green: 170/255, blue: 100/255)
        case .limitedSlots:  return Color(red: 255/255, green: 160/255, blue: 50/255)
        case .unavailable:   return Color.red.opacity(0.7)
        }
    }
}

// MARK: - Lab Test Card Component
struct LabTestCard: View {
    let test: LabTest
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Trigger the callback to show confirmation modal
            onTap()
        }) {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(test.iconColor.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Image(systemName: test.icon)
                            .font(.system(size: 24))
                            .foregroundColor(test.iconColor)
                    }
                    
                    // Test Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(test.name)
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(AppColors.darkBlue)
                            .lineLimit(1)
                        
                        Text(test.description)
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // Price and Chevron
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("$\(String(format: "%.2f", test.price))")
                            .font(.poppins(.bold, size: 16))
                            .foregroundColor(AppColors.darkBlue)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.4))
                    }
                }
                .padding(16)
                
                // Bottom info bar
                Divider()
                    .padding(.horizontal, 16)
                
                HStack(spacing: 16) {
                    // Availability badge
                    HStack(spacing: 4) {
                        Circle()
                            .fill(test.availability.statusColor)
                            .frame(width: 6, height: 6)
                        Text(test.availability.statusText)
                            .font(.poppins(.medium, size: 11))
                            .foregroundColor(test.availability.statusColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(test.availability.statusColor.opacity(0.1))
                    .cornerRadius(6)
                    
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(test.duration)
                            .font(.poppins(.regular, size: 11))
                    }
                    .foregroundColor(.gray.opacity(0.8))
                    
                    // Preparation required
                    if test.preparationRequired {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 10))
                            Text("Prep Required")
                                .font(.poppins(.regular, size: 11))
                        }
                        .foregroundColor(Color(red: 255/255, green: 160/255, blue: 50/255))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
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

// MARK: - Mock Data
let mockLabTests: [LabTest] = [
    LabTest(
        id: "1",
        name: "Complete Blood Count (CBC)",
        description: "Comprehensive blood analysis including RBC, WBC, and platelet count",
        category: .blood,
        price: 35.00,
        duration: "30 mins",
        availability: .available,
        preparationRequired: false,
        icon: "drop.fill",
        iconColor: Color(red: 220/255, green: 80/255, blue: 100/255)
    ),
    LabTest(
        id: "2",
        name: "Lipid Panel",
        description: "Cholesterol and triglyceride levels assessment",
        category: .blood,
        price: 45.00,
        duration: "20 mins",
        availability: .available,
        preparationRequired: true,
        icon: "heart.text.square.fill",
        iconColor: Color(red: 255/255, green: 120/255, blue: 80/255)
    ),
    LabTest(
        id: "3",
        name: "Urinalysis",
        description: "Physical, chemical and microscopic urine examination",
        category: .urine,
        price: 25.00,
        duration: "15 mins",
        availability: .available,
        preparationRequired: false,
        icon: "flask.fill",
        iconColor: Color(red: 100/255, green: 180/255, blue: 220/255)
    ),
    LabTest(
        id: "4",
        name: "Chest X-Ray",
        description: "Digital radiographic imaging of chest and lungs",
        category: .imaging,
        price: 85.00,
        duration: "10 mins",
        availability: .limitedSlots,
        preparationRequired: false,
        icon: "lungs.fill",
        iconColor: Color(red: 120/255, green: 140/255, blue: 180/255)
    ),
    LabTest(
        id: "5",
        name: "ECG (Electrocardiogram)",
        description: "Heart rhythm and electrical activity recording",
        category: .cardiac,
        price: 55.00,
        duration: "15 mins",
        availability: .available,
        preparationRequired: false,
        icon: "waveform.path.ecg",
        iconColor: Color(red: 200/255, green: 80/255, blue: 120/255)
    ),
    LabTest(
        id: "6",
        name: "Thyroid Panel (TSH, T3, T4)",
        description: "Comprehensive thyroid function assessment",
        category: .metabolic,
        price: 65.00,
        duration: "30 mins",
        availability: .available,
        preparationRequired: true,
        icon: "chart.line.uptrend.xyaxis",
        iconColor: Color(red: 160/255, green: 120/255, blue: 200/255)
    ),
    LabTest(
        id: "7",
        name: "Blood Glucose (Fasting)",
        description: "Fasting blood sugar level measurement",
        category: .metabolic,
        price: 20.00,
        duration: "10 mins",
        availability: .available,
        preparationRequired: true,
        icon: "drop.triangle.fill",
        iconColor: Color(red: 255/255, green: 180/255, blue: 80/255)
    ),
    LabTest(
        id: "8",
        name: "COVID-19 PCR Test",
        description: "RT-PCR molecular test for COVID-19 detection",
        category: .infectious,
        price: 75.00,
        duration: "24-48 hrs",
        availability: .available,
        preparationRequired: false,
        icon: "allergens",
        iconColor: Color(red: 220/255, green: 100/255, blue: 150/255)
    ),
    LabTest(
        id: "9",
        name: "Liver Function Test (LFT)",
        description: "Complete liver enzyme and protein analysis",
        category: .blood,
        price: 50.00,
        duration: "25 mins",
        availability: .available,
        preparationRequired: true,
        icon: "chart.bar.fill",
        iconColor: Color(red: 180/255, green: 140/255, blue: 80/255)
    ),
    LabTest(
        id: "10",
        name: "Kidney Function Test",
        description: "Creatinine and BUN measurement for kidney health",
        category: .blood,
        price: 40.00,
        duration: "20 mins",
        availability: .limitedSlots,
        preparationRequired: false,
        icon: "figure.stand",
        iconColor: Color(red: 80/255, green: 150/255, blue: 180/255)
    ),
    LabTest(
        id: "11",
        name: "Ultrasound Scan",
        description: "Abdominal or pelvic ultrasound imaging",
        category: .imaging,
        price: 120.00,
        duration: "30 mins",
        availability: .limitedSlots,
        preparationRequired: true,
        icon: "waveform",
        iconColor: Color(red: 100/255, green: 140/255, blue: 200/255)
    ),
    LabTest(
        id: "12",
        name: "Hemoglobin A1C",
        description: "3-month average blood sugar control measurement",
        category: .metabolic,
        price: 35.00,
        duration: "20 mins",
        availability: .available,
        preparationRequired: false,
        icon: "percent",
        iconColor: Color(red: 255/255, green: 140/255, blue: 100/255)
    ),
    LabTest(
        id: "13",
        name: "Vitamin D Test",
        description: "25-hydroxyvitamin D blood level assessment",
        category: .blood,
        price: 55.00,
        duration: "30 mins",
        availability: .available,
        preparationRequired: false,
        icon: "sun.max.fill",
        iconColor: Color(red: 255/255, green: 200/255, blue: 50/255)
    ),
    LabTest(
        id: "14",
        name: "Stool Analysis",
        description: "Comprehensive stool examination for digestive issues",
        category: .infectious,
        price: 30.00,
        duration: "48-72 hrs",
        availability: .unavailable,
        preparationRequired: true,
        icon: "bandage.fill",
        iconColor: Color(red: 140/255, green: 100/255, blue: 80/255)
    ),
    LabTest(
        id: "15",
        name: "Pregnancy Test (Beta-hCG)",
        description: "Quantitative blood pregnancy hormone measurement",
        category: .blood,
        price: 30.00,
        duration: "15 mins",
        availability: .available,
        preparationRequired: false,
        icon: "heart.circle.fill",
        iconColor: Color(red: 255/255, green: 150/255, blue: 180/255)
    )
]

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    
    LabTestsView()
        .environment(languageManager)
        .environment(router)
}
