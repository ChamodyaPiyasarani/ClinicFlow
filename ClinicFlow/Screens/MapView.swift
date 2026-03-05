import SwiftUI

// MARK: - Models

/// Represents different floors in the clinic
enum Floor: Int, CaseIterable {
    case floor1 = 1
    case floor2 = 2
    case floor3 = 3
    
    var displayName: String {
        "Floor \(rawValue)"
    }
}

/// Represents different areas/departments in the clinic
enum ClinicArea: String, CaseIterable {
    case registration
    case consultation
    case laboratory
    case pharmacy
    case payment
    case restrooms
    
    var displayName: String {
        switch self {
        case .registration: return "Registration"
        case .consultation: return "Consultation"
        case .laboratory: return "Laboratory"
        case .pharmacy: return "Pharmacy"
        case .payment: return "Payment"
        case .restrooms: return "Restrooms"
        }
    }
    
    var icon: String {
        switch self {
        case .registration: return "clipboard.fill"
        case .consultation: return "stethoscope"
        case .laboratory: return "testtube.2"
        case .pharmacy: return "pills.fill"
        case .payment: return "creditcard.fill"
        case .restrooms: return "figure.stand"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .registration: return Color(red: 100/255, green: 140/255, blue: 200/255)
        case .consultation: return Color(red: 130/255, green: 220/255, blue: 150/255)
        case .laboratory: return Color(red: 180/255, green: 130/255, blue: 220/255)
        case .pharmacy: return Color(red: 255/255, green: 180/255, blue: 120/255)
        case .payment: return Color(red: 255/255, green: 220/255, blue: 120/255)
        case .restrooms: return Color(red: 180/255, green: 180/255, blue: 190/255)
        }
    }
    
    /// Walking time from registration in minutes (mock data for each floor)
    func walkingTime(floor: Floor) -> Int {
        switch floor {
        case .floor1:
            switch self {
            case .registration: return 0
            case .consultation: return 1
            case .laboratory: return 3
            case .pharmacy: return 2
            case .payment: return 2
            case .restrooms: return 1
            }
        case .floor2:
            switch self {
            case .registration: return 0
            case .consultation: return 2
            case .laboratory: return 4
            case .pharmacy: return 3
            case .payment: return 3
            case .restrooms: return 2
            }
        case .floor3:
            switch self {
            case .registration: return 0
            case .consultation: return 2
            case .laboratory: return 5
            case .pharmacy: return 4
            case .payment: return 3
            case .restrooms: return 2
            }
        }
    }
}

// MARK: - Main View

struct MapView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @State private var selectedFloor: Floor = .floor1
    @State private var selectedArea: ClinicArea? = nil
    @State private var isNavigating: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            MapHeaderView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Subtitle
                    Text("Clinic Map")
                        .font(.poppins(.medium, size: 16))
                        .foregroundColor(Color.gray.opacity(0.8))
                        .padding(.top, 8)
                    
                    // Floor Selector
                    FloorSelector(selectedFloor: $selectedFloor, isNavigating: $isNavigating)
                    
                    // Map Container
                    MapContainer(
                        selectedFloor: selectedFloor,
                        selectedArea: $selectedArea,
                        isNavigating: isNavigating
                    )
                    
                    // Destination Info (shown when area is selected)
                    if let area = selectedArea {
                        DestinationInfoView(
                            area: area,
                            floor: selectedFloor,
                            isNavigating: $isNavigating
                        )
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .background(AppColors.background)
        .onChange(of: selectedFloor) { _, _ in
            // Reset navigation when changing floors
            isNavigating = false
        }
    }
}

// MARK: - Header

private struct MapHeaderView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            // Centered title
            AppNameText(fontSize: 20)
            
            HStack {
                // Back button (left)
                BackButton {
                    // This is handled by tab navigation, but included for consistency
                }
                
                Spacer()
                
                // Notification bell (right)
                Button(action: {
                    router.navigate(to: .notifications)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 42, height: 42)
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.darkBlue)
                        
                        // Notification badge
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Floor Selector

private struct FloorSelector: View {
    @Binding var selectedFloor: Floor
    @Binding var isNavigating: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(Floor.allCases, id: \.self) { floor in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedFloor = floor
                        isNavigating = false
                    }
                    
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    Text(floor.displayName)
                        .font(.poppins(.medium, size: 15))
                        .foregroundColor(selectedFloor == floor ? .white : AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedFloor == floor 
                                ? AppColors.brandBlue 
                                : Color.white
                        )
                        .cornerRadius(10)
                        .shadow(
                            color: .black.opacity(selectedFloor == floor ? 0.15 : 0.08),
                            radius: selectedFloor == floor ? 6 : 3,
                            x: 0,
                            y: selectedFloor == floor ? 3 : 2
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Map Container

private struct MapContainer: View {
    let selectedFloor: Floor
    @Binding var selectedArea: ClinicArea?
    let isNavigating: Bool
    
    // Layout positions for each area
    private let areaPositions: [ClinicArea: (row: Int, col: Int)] = [
        .registration: (0, 0),
        .consultation: (0, 1),
        .laboratory: (1, 0),
        .pharmacy: (1, 1),
        .payment: (2, 0),
        .restrooms: (2, 1)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background container
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                
                // Map content
                VStack(spacing: 16) {
                    // Row 1: Registration, Consultation
                    HStack(spacing: 16) {
                        AreaCard(
                            area: .registration,
                            floor: selectedFloor,
                            isSelected: selectedArea == .registration,
                            hasIndicator: true
                        ) {
                            selectedArea = .registration
                        }
                        
                        AreaCard(
                            area: .consultation,
                            floor: selectedFloor,
                            isSelected: selectedArea == .consultation
                        ) {
                            selectedArea = .consultation
                        }
                    }
                    
                    // Row 2: Laboratory, Pharmacy
                    HStack(spacing: 16) {
                        AreaCard(
                            area: .laboratory,
                            floor: selectedFloor,
                            isSelected: selectedArea == .laboratory
                        ) {
                            selectedArea = .laboratory
                        }
                        
                        AreaCard(
                            area: .pharmacy,
                            floor: selectedFloor,
                            isSelected: selectedArea == .pharmacy
                        ) {
                            selectedArea = .pharmacy
                        }
                    }
                    
                    // Row 3: Payment, Restrooms
                    HStack(spacing: 16) {
                        AreaCard(
                            area: .payment,
                            floor: selectedFloor,
                            isSelected: selectedArea == .payment
                        ) {
                            selectedArea = .payment
                        }
                        
                        AreaCard(
                            area: .restrooms,
                            floor: selectedFloor,
                            isSelected: selectedArea == .restrooms
                        ) {
                            selectedArea = .restrooms
                        }
                    }
                }
                .padding(20)
                
                // Navigation lines (dotted arrows)
                if isNavigating, let destination = selectedArea, destination != .registration {
                    NavigationPath(to: destination)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Area Card

private struct AreaCard: View {
    let area: ClinicArea
    let floor: Floor
    let isSelected: Bool
    var hasIndicator: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(area.backgroundColor.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? area.backgroundColor : Color.clear,
                                lineWidth: isSelected ? 3 : 0
                            )
                    )
                
                VStack(spacing: 8) {
                    Image(systemName: area.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(area.backgroundColor)
                    
                    Text(area.displayName)
                        .font(.poppins(.medium, size: 13))
                        .foregroundColor(AppColors.darkBlue)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                
                // Blue indicator dot for registration
                if hasIndicator {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(8)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Navigation Path (Dotted Lines)

private struct NavigationPath: View {
    let to: ClinicArea
    
    var body: some View {
        Canvas { context, size in
            let startX = size.width * 0.25
            let startY = size.height * 0.15
            
            var endX: CGFloat = 0
            var endY: CGFloat = 0
            
            // Calculate end position based on destination
            switch to {
            case .registration:
                return // No path to itself
            case .consultation:
                endX = size.width * 0.75
                endY = size.height * 0.15
            case .laboratory:
                endX = size.width * 0.25
                endY = size.height * 0.48
            case .pharmacy:
                endX = size.width * 0.75
                endY = size.height * 0.48
            case .payment:
                endX = size.width * 0.25
                endY = size.height * 0.81
            case .restrooms:
                endX = size.width * 0.75
                endY = size.height * 0.81
            }
            
            // Create a path
            var path = Path()
            path.move(to: CGPoint(x: startX, y: startY))
            
            // Add intermediate points for more interesting paths
            if to == .consultation {
                // Straight horizontal line
                path.addLine(to: CGPoint(x: endX, y: endY))
            } else if to == .laboratory || to == .payment {
                // Straight vertical line
                path.addLine(to: CGPoint(x: endX, y: endY))
            } else {
                // L-shaped path
                let midY = (startY + endY) / 2
                path.addLine(to: CGPoint(x: startX, y: midY))
                path.addLine(to: CGPoint(x: endX, y: midY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            
            // Draw dotted line
            context.stroke(
                path,
                with: .color(AppColors.brandBlue.opacity(0.6)),
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: [8, 6]
                )
            )
            
            // Draw arrowhead at the end
            let arrowSize: CGFloat = 10
            let angle = atan2(endY - startY, endX - startX)
            
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: endX, y: endY))
            arrowPath.addLine(to: CGPoint(
                x: endX - arrowSize * cos(angle - .pi / 6),
                y: endY - arrowSize * sin(angle - .pi / 6)
            ))
            arrowPath.move(to: CGPoint(x: endX, y: endY))
            arrowPath.addLine(to: CGPoint(
                x: endX - arrowSize * cos(angle + .pi / 6),
                y: endY - arrowSize * sin(angle + .pi / 6)
            ))
            
            context.stroke(
                arrowPath,
                with: .color(AppColors.brandBlue.opacity(0.6)),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
        }
    }
}

// MARK: - Destination Info

private struct DestinationInfoView: View {
    let area: ClinicArea
    let floor: Floor
    @Binding var isNavigating: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Info card
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(area.backgroundColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: area.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(area.backgroundColor)
                }
                
                // Destination info
                VStack(alignment: .leading, spacing: 4) {
                    Text("Destination")
                        .font(.poppins(.regular, size: 12))
                        .foregroundColor(Color.gray.opacity(0.7))
                    
                    Text(area.displayName)
                        .font(.poppins(.semiBold, size: 18))
                        .foregroundColor(AppColors.darkBlue)
                }
                
                Spacer()
                
                // Walking time
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Walking time")
                        .font(.poppins(.regular, size: 12))
                        .foregroundColor(Color.gray.opacity(0.7))
                    
                    Text("\(area.walkingTime(floor: floor)) min")
                        .font(.poppins(.semiBold, size: 18))
                        .foregroundColor(AppColors.darkBlue)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
            
            // Start Navigation Button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isNavigating.toggle()
                }
                
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            }) {
                Text(isNavigating ? "Stop Navigation" : "Start Navigation")
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isNavigating ? Color.red.opacity(0.8) : AppColors.brandBlue)
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview {
    MapView()
        .environment(LanguageManager.shared)
        .environment(AppRouter.shared)
}
