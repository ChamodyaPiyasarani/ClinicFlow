import SwiftUI

struct OPDDepartmentsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @State private var selectedCategory: DepartmentCategory = .all
    @State private var searchText: String = ""
    @State private var selectedTab: BottomTab = .home
    
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

                    // Notification bell (right)
                    HStack {
                        Spacer()
                        NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                    }
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
                        
                        TextField("Search departments...", text: $searchText)
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
                        ForEach(DepartmentCategory.allCases, id: \.self) { category in
                            DepartmentCategoryChip(
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
                
                // MARK: - Department List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Section Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Available Departments")
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundColor(AppColors.darkBlue)
                                Text(filteredDepartments.count == 1 ? "1 department available" : "\(filteredDepartments.count) departments available")
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
                        
                        // Department Cards
                        LazyVStack(spacing: 12) {
                            ForEach(filteredDepartments) { department in
                                DepartmentCard(
                                    icon: department.icon,
                                    iconColor: department.iconColor,
                                    departmentName: department.name,
                                    description: department.description,
                                    availabilityStatus: department.availability,
                                    waitingCount: department.waitingCount
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }

                // MARK: - Bottom Nav Bar
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
    }
    
    // Filter departments based on category and search
    var filteredDepartments: [Department] {
        var departments = mockDepartments
        
        // Filter by category
        if selectedCategory != .all {
            departments = departments.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            departments = departments.filter { department in
                department.name.localizedCaseInsensitiveContains(searchText) ||
                department.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return departments
    }
}

// MARK: - Department Model
struct Department: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: DepartmentCategory
    let availability: DepartmentAvailability
    let waitingCount: Int
    let icon: String
    let iconColor: Color
}

// MARK: - Department Category Enum
enum DepartmentCategory: String, CaseIterable {
    case all = "All"
    case general = "General"
    case surgical = "Surgical"
    case specialized = "Specialized"
    case diagnostic = "Diagnostic"
    case emergency = "Emergency"
    
    var icon: String {
        switch self {
        case .all:         return "list.bullet"
        case .general:     return "stethoscope"
        case .surgical:    return "cross.case.fill"
        case .specialized: return "heart.text.square"
        case .diagnostic:  return "waveform.path.ecg"
        case .emergency:   return "cross.circle.fill"
        }
    }
}

// MARK: - Department Category Chip Component
struct DepartmentCategoryChip: View {
    let category: DepartmentCategory
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

// MARK: - Mock Departments Data
let mockDepartments: [Department] = [
    Department(
        id: "1",
        name: "General Medicine",
        description: "Treats common illnesses and provides first medical consultation",
        category: .general,
        availability: .available,
        waitingCount: 20,
        icon: "stethoscope",
        iconColor: Color(red: 80/255, green: 170/255, blue: 100/255)
    ),
    Department(
        id: "2",
        name: "Pediatrics",
        description: "Provides healthcare services for infants, children, and adolescents",
        category: .general,
        availability: .available,
        waitingCount: 18,
        icon: "figure.and.child.holdinghands",
        iconColor: Color(red: 255/255, green: 150/255, blue: 100/255)
    ),
    Department(
        id: "3",
        name: "Orthopedics",
        description: "Treats bone, joint, muscle, and spine-related conditions",
        category: .surgical,
        availability: .available,
        waitingCount: 27,
        icon: "figure.walk",
        iconColor: Color(red: 100/255, green: 140/255, blue: 200/255)
    ),
    Department(
        id: "4",
        name: "Gynecology & Obstetrics",
        description: "Focuses on women's health, pregnancy, and childbirth care",
        category: .specialized,
        availability: .available,
        waitingCount: 5,
        icon: "heart.fill",
        iconColor: Color(red: 255/255, green: 120/255, blue: 180/255)
    ),
    Department(
        id: "5",
        name: "Cardiology",
        description: "Diagnoses and treats heart and blood vessel diseases",
        category: .specialized,
        availability: .available,
        waitingCount: 12,
        icon: "heart.text.square.fill",
        iconColor: Color(red: 220/255, green: 80/255, blue: 100/255)
    ),
    Department(
        id: "6",
        name: "Dermatology",
        description: "Skin care and treatment",
        category: .specialized,
        availability: .available,
        waitingCount: 6,
        icon: "allergens",
        iconColor: Color(red: 160/255, green: 120/255, blue: 200/255)
    ),
    Department(
        id: "7",
        name: "ENT",
        description: "Ear, nose and throat specialists",
        category: .specialized,
        availability: .busy,
        waitingCount: 12,
        icon: "ear.fill",
        iconColor: Color(red: 80/255, green: 170/255, blue: 160/255)
    ),
    Department(
        id: "8",
        name: "Ophthalmology",
        description: "Eye care and vision",
        category: .specialized,
        availability: .available,
        waitingCount: 2,
        icon: "eye.fill",
        iconColor: Color(red: 100/255, green: 120/255, blue: 180/255)
    ),
    Department(
        id: "9",
        name: "Neurology",
        description: "Brain and nervous system",
        category: .specialized,
        availability: .unavailable,
        waitingCount: 0,
        icon: "brain.head.profile",
        iconColor: Color(red: 200/255, green: 100/255, blue: 150/255)
    ),
    Department(
        id: "10",
        name: "Pulmonology",
        description: "Respiratory care",
        category: .specialized,
        availability: .available,
        waitingCount: 7,
        icon: "lungs.fill",
        iconColor: Color(red: 120/255, green: 180/255, blue: 220/255)
    ),
    Department(
        id: "11",
        name: "General Surgery",
        description: "Comprehensive surgical procedures and care",
        category: .surgical,
        availability: .available,
        waitingCount: 9,
        icon: "cross.case.fill",
        iconColor: Color(red: 200/255, green: 80/255, blue: 80/255)
    ),
    Department(
        id: "12",
        name: "Radiology",
        description: "Medical imaging and diagnostics",
        category: .diagnostic,
        availability: .available,
        waitingCount: 15,
        icon: "waveform.path.ecg",
        iconColor: Color(red: 80/255, green: 140/255, blue: 200/255)
    ),
    Department(
        id: "13",
        name: "Emergency Department",
        description: "24/7 urgent and emergency medical care",
        category: .emergency,
        availability: .available,
        waitingCount: 35,
        icon: "cross.circle.fill",
        iconColor: Color(red: 255/255, green: 80/255, blue: 80/255)
    ),
    Department(
        id: "14",
        name: "Psychiatry",
        description: "Mental health and behavioral disorder treatment",
        category: .specialized,
        availability: .available,
        waitingCount: 4,
        icon: "brain",
        iconColor: Color(red: 140/255, green: 100/255, blue: 200/255)
    ),
    Department(
        id: "15",
        name: "Urology",
        description: "Urinary tract and male reproductive system care",
        category: .specialized,
        availability: .busy,
        waitingCount: 8,
        icon: "drop.fill",
        iconColor: Color(red: 100/255, green: 180/255, blue: 200/255)
    )
]

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    
    OPDDepartmentsView()
        .environment(languageManager)
        .environment(router)
}
