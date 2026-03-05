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
    
    var icon: String {
        switch self {
        case .floor1: return "1.square.fill"
        case .floor2: return "2.square.fill"
        case .floor3: return "3.square.fill"
        }
    }
    
    var subtitle: String {
        switch self {
        case .floor1: return "Main Entrance"
        case .floor2: return "Specialist Wing"
        case .floor3: return "Diagnostics"
        }
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
    
    /// Accent color for each area
    var backgroundColor: Color {
        switch self {
        case .registration: return Color(red: 90/255, green: 140/255, blue: 210/255)
        case .consultation: return Color(red: 75/255, green: 180/255, blue: 130/255)
        case .laboratory:   return Color(red: 150/255, green: 110/255, blue: 200/255)
        case .pharmacy:     return Color(red: 235/255, green: 150/255, blue: 80/255)
        case .payment:      return Color(red: 220/255, green: 185/255, blue: 55/255)
        case .restrooms:    return Color(red: 140/255, green: 155/255, blue: 175/255)
        }
    }
    
    /// Light pastel background for map cards
    var lightBackground: Color {
        switch self {
        case .registration: return Color(red: 227/255, green: 242/255, blue: 253/255)
        case .consultation: return Color(red: 232/255, green: 245/255, blue: 233/255)
        case .laboratory:   return Color(red: 243/255, green: 229/255, blue: 245/255)
        case .pharmacy:     return Color(red: 255/255, green: 243/255, blue: 224/255)
        case .payment:      return Color(red: 255/255, green: 249/255, blue: 220/255)
        case .restrooms:    return Color(red: 236/255, green: 239/255, blue: 241/255)
        }
    }
    
    /// Room number based on floor
    func roomNumber(floor: Floor) -> String {
        let base = floor.rawValue * 100
        switch self {
        case .registration: return "\(base + 1)"
        case .consultation: return "\(base + 2)"
        case .laboratory:   return "\(base + 3)"
        case .pharmacy:     return "\(base + 4)"
        case .payment:      return "\(base + 5)"
        case .restrooms:    return "\(base + 6)"
        }
    }
    
    /// Walking time from registration in minutes
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
            MapHeaderView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Floor Selector
                    FloorSelector(selectedFloor: $selectedFloor, isNavigating: $isNavigating)
                        .padding(.top, 12)
                    
                    // Map Container
                    MapContainer(
                        selectedFloor: selectedFloor,
                        selectedArea: $selectedArea,
                        isNavigating: isNavigating
                    )
                    
                    // Legend
                    MapLegend()
                    
                    // Destination Info
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
            isNavigating = false
        }
    }
}

// MARK: - Header

private struct MapHeaderView: View {
    @Environment(LanguageManager.self) var languageManager
    
    var body: some View {
        ZStack {
            AppNameText(fontSize: 20)
            
            HStack {
                BackButton { }
                Spacer()
                NotificationIcon(unreadCount: 3, iconSize: 18)
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
        HStack(spacing: 10) {
            ForEach(Floor.allCases, id: \.self) { floor in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedFloor = floor
                        isNavigating = false
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: floor.icon)
                            .font(.system(size: 18, weight: .semibold))
                        Text(floor.displayName)
                            .font(.poppins(.semiBold, size: 13))
                        Text(floor.subtitle)
                            .font(.poppins(.regular, size: 10))
                            .opacity(0.8)
                    }
                    .foregroundColor(selectedFloor == floor ? .white : AppColors.darkBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(selectedFloor == floor ? AppColors.brandBlue : Color.white)
                    )
                    .shadow(
                        color: selectedFloor == floor
                            ? AppColors.brandBlue.opacity(0.3)
                            : .black.opacity(0.06),
                        radius: selectedFloor == floor ? 8 : 4,
                        x: 0,
                        y: selectedFloor == floor ? 4 : 2
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
    
    var body: some View {
        ZStack {
            // Blueprint-style container
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 245/255, green: 248/255, blue: 252/255))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color(red: 200/255, green: 215/255, blue: 235/255),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            
            VStack(spacing: 0) {
                // Entrance or floor label
                if selectedFloor == .floor1 {
                    EntranceMarker()
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 12))
                        Text(selectedFloor.subtitle)
                            .font(.poppins(.medium, size: 12))
                    }
                    .foregroundColor(AppColors.darkBlue.opacity(0.5))
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                
                // Row 1: Registration, Consultation
                HStack(spacing: 10) {
                    MapAreaCard(
                        area: .registration,
                        floor: selectedFloor,
                        isSelected: selectedArea == .registration,
                        isYouAreHere: true
                    ) { selectedArea = .registration }
                    
                    MapAreaCard(
                        area: .consultation,
                        floor: selectedFloor,
                        isSelected: selectedArea == .consultation
                    ) { selectedArea = .consultation }
                }
                .padding(.horizontal, 16)
                
                // Corridor 1
                CorridorStrip(label: "Main Corridor")
                
                // Row 2: Laboratory, Pharmacy
                HStack(spacing: 10) {
                    MapAreaCard(
                        area: .laboratory,
                        floor: selectedFloor,
                        isSelected: selectedArea == .laboratory
                    ) { selectedArea = .laboratory }
                    
                    MapAreaCard(
                        area: .pharmacy,
                        floor: selectedFloor,
                        isSelected: selectedArea == .pharmacy
                    ) { selectedArea = .pharmacy }
                }
                .padding(.horizontal, 16)
                
                // Corridor 2
                CorridorStrip(label: "South Wing")
                
                // Row 3: Payment, Restrooms
                HStack(spacing: 10) {
                    MapAreaCard(
                        area: .payment,
                        floor: selectedFloor,
                        isSelected: selectedArea == .payment
                    ) { selectedArea = .payment }
                    
                    MapAreaCard(
                        area: .restrooms,
                        floor: selectedFloor,
                        isSelected: selectedArea == .restrooms
                    ) { selectedArea = .restrooms }
                }
                .padding(.horizontal, 16)
                
                // Staircase & Elevator indicators
                StaircaseIndicator(currentFloor: selectedFloor)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
            }
            
            // Navigation path overlay
            if isNavigating, let destination = selectedArea, destination != .registration {
                NavigationPathOverlay(to: destination)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Entrance Marker

private struct EntranceMarker: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.brandBlue)
            
            Text("Main Entrance")
                .font(.poppins(.semiBold, size: 12))
                .foregroundColor(AppColors.brandBlue)
            
            Rectangle()
                .fill(AppColors.brandBlue.opacity(0.3))
                .frame(height: 1)
            
            Image(systemName: "arrow.down")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AppColors.brandBlue.opacity(0.5))
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Corridor Strip

private struct CorridorStrip: View {
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            CorridorDashedLine()
                .frame(height: 1)
            
            HStack(spacing: 4) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 9))
                Text(label)
                    .font(.poppins(.medium, size: 9))
            }
            .foregroundColor(AppColors.darkBlue.opacity(0.35))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(red: 230/255, green: 238/255, blue: 248/255))
            )
            
            CorridorDashedLine()
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

// MARK: - Corridor Dashed Line

private struct CorridorDashedLine: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0.5))
                path.addLine(to: CGPoint(x: geo.size.width, y: 0.5))
            }
            .stroke(
                AppColors.darkBlue.opacity(0.15),
                style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
            )
        }
    }
}

// MARK: - Staircase Indicator

private struct StaircaseIndicator: View {
    let currentFloor: Floor
    
    var body: some View {
        HStack(spacing: 12) {
            // Staircase
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 230/255, green: 238/255, blue: 248/255))
                        .frame(width: 32, height: 32)
                    Image(systemName: "stairs")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.brandBlue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Staircase")
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(AppColors.darkBlue)
                    Text("Connects all floors")
                        .font(.poppins(.regular, size: 9))
                        .foregroundColor(AppColors.darkBlue.opacity(0.5))
                }
            }
            
            Spacer()
            
            // Elevator
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 232/255, green: 245/255, blue: 233/255))
                        .frame(width: 32, height: 32)
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 75/255, green: 180/255, blue: 130/255))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Elevator")
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(AppColors.darkBlue)
                    Text("Floor \(currentFloor.rawValue)")
                        .font(.poppins(.regular, size: 9))
                        .foregroundColor(AppColors.darkBlue.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Map Area Card

private struct MapAreaCard: View {
    let area: ClinicArea
    let floor: Floor
    let isSelected: Bool
    var isYouAreHere: Bool = false
    let action: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button {
            action()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            ZStack(alignment: .topLeading) {
                // Card background
                RoundedRectangle(cornerRadius: 14)
                    .fill(area.lightBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected
                                    ? area.backgroundColor
                                    : area.backgroundColor.opacity(0.2),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                
                VStack(spacing: 6) {
                    // Icon with colored circle
                    ZStack {
                        Circle()
                            .fill(area.backgroundColor.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: area.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(area.backgroundColor)
                    }
                    
                    // Area name
                    Text(area.displayName)
                        .font(.poppins(.semiBold, size: 12))
                        .foregroundColor(AppColors.darkBlue)
                        .lineLimit(1)
                    
                    // Room number
                    Text("Rm \(area.roomNumber(floor: floor))")
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(AppColors.darkBlue.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                
                // "You are here" pulse indicator
                if isYouAreHere {
                    ZStack {
                        Circle()
                            .fill(AppColors.brandBlue.opacity(0.2))
                            .frame(width: 20, height: 20)
                            .scaleEffect(pulseScale)
                        Circle()
                            .fill(AppColors.brandBlue)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(6)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true)
                        ) {
                            pulseScale = 1.5
                        }
                    }
                }
                
                // Walking time badge (top-right)
                if area.walkingTime(floor: floor) > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 7))
                        Text("\(area.walkingTime(floor: floor))m")
                            .font(.poppins(.medium, size: 8))
                    }
                    .foregroundColor(AppColors.darkBlue.opacity(0.6))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(Color.white.opacity(0.8))
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(6)
                }
            }
            .frame(height: 110)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
        .shadow(
            color: isSelected ? area.backgroundColor.opacity(0.3) : .clear,
            radius: isSelected ? 8 : 0,
            x: 0,
            y: isSelected ? 4 : 0
        )
    }
}

// MARK: - Map Legend

private struct MapLegend: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Legend")
                .font(.poppins(.semiBold, size: 13))
                .foregroundColor(AppColors.darkBlue)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(ClinicArea.allCases, id: \.self) { area in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(area.backgroundColor)
                            .frame(width: 8, height: 8)
                        Text(area.displayName)
                            .font(.poppins(.regular, size: 10))
                            .foregroundColor(AppColors.darkBlue.opacity(0.7))
                            .lineLimit(1)
                    }
                }
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(AppColors.brandBlue)
                        .frame(width: 8, height: 8)
                    Text("You are here")
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(AppColors.darkBlue.opacity(0.7))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "stairs")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.brandBlue)
                    Text("Staircase")
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(AppColors.darkBlue.opacity(0.7))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 75/255, green: 180/255, blue: 130/255))
                    Text("Elevator")
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(AppColors.darkBlue.opacity(0.7))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Navigation Path Overlay

private struct NavigationPathOverlay: View {
    let to: ClinicArea
    
    var body: some View {
        Canvas { context, size in
            // Row centers relative to container height
            let row0Y = size.height * 0.20
            let row1Y = size.height * 0.48
            let row2Y = size.height * 0.76
            
            // Corridor Y positions (between rows)
            let corridor0Y = size.height * 0.34
            let corridor1Y = size.height * 0.62
            
            let leftX = size.width * 0.28
            let rightX = size.width * 0.72
            
            let startX = leftX
            let startY = row0Y
            
            let rowYs = [row0Y, row1Y, row2Y]
            let dest = areaRowCol(for: to)
            let endX = dest.col == 0 ? leftX : rightX
            let endY = rowYs[dest.row]
            
            // Build corridor-following path
            var path = Path()
            path.move(to: CGPoint(x: startX, y: startY))
            
            if dest.row == 0 && dest.col == 1 {
                // Same row, go through corridor
                path.addLine(to: CGPoint(x: startX, y: corridor0Y))
                path.addLine(to: CGPoint(x: endX, y: corridor0Y))
                path.addLine(to: CGPoint(x: endX, y: endY))
            } else if dest.col == 0 {
                // Same column, straight down
                path.addLine(to: CGPoint(x: startX, y: endY))
            } else {
                // Different row and column, route through corridor
                let corridorY = dest.row >= 2 ? corridor1Y : corridor0Y
                path.addLine(to: CGPoint(x: startX, y: corridorY))
                path.addLine(to: CGPoint(x: endX, y: corridorY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            
            // Draw dashed navigation line
            context.stroke(
                path,
                with: .color(AppColors.brandBlue.opacity(0.7)),
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: [8, 6]
                )
            )
            
            // Draw start point
            context.fill(
                Path(ellipseIn: CGRect(
                    x: startX - 5, y: startY - 5,
                    width: 10, height: 10
                )),
                with: .color(AppColors.brandBlue)
            )
            
            // Draw end point (outer glow + inner dot)
            context.fill(
                Path(ellipseIn: CGRect(
                    x: endX - 7, y: endY - 7,
                    width: 14, height: 14
                )),
                with: .color(AppColors.brandBlue.opacity(0.25))
            )
            context.fill(
                Path(ellipseIn: CGRect(
                    x: endX - 4, y: endY - 4,
                    width: 8, height: 8
                )),
                with: .color(AppColors.brandBlue)
            )
            
            // Draw arrowhead at destination
            let arrowSize: CGFloat = 10
            let angle: CGFloat
            if dest.row == 0 && dest.col == 1 {
                angle = -.pi / 2
            } else if dest.col == 0 {
                angle = .pi / 2
            } else {
                angle = .pi / 2
            }
            
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
                with: .color(AppColors.brandBlue),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
        }
        .allowsHitTesting(false)
    }
    
    private func areaRowCol(for area: ClinicArea) -> (row: Int, col: Int) {
        switch area {
        case .registration: return (0, 0)
        case .consultation: return (0, 1)
        case .laboratory:   return (1, 0)
        case .pharmacy:     return (1, 1)
        case .payment:      return (2, 0)
        case .restrooms:    return (2, 1)
        }
    }
}

// MARK: - Destination Info

private struct DestinationInfoView: View {
    let area: ClinicArea
    let floor: Floor
    @Binding var isNavigating: Bool
    
    var body: some View {
        VStack(spacing: 14) {
            // Info card
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(area.lightBackground)
                        .frame(width: 52, height: 52)
                    Image(systemName: area.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(area.backgroundColor)
                }
                
                // Destination details
                VStack(alignment: .leading, spacing: 4) {
                    Text(area.displayName)
                        .font(.poppins(.semiBold, size: 17))
                        .foregroundColor(AppColors.darkBlue)
                    
                    HStack(spacing: 8) {
                        Text("Room \(area.roomNumber(floor: floor))")
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(AppColors.darkBlue.opacity(0.6))
                        
                        Text("·")
                            .foregroundColor(AppColors.darkBlue.opacity(0.3))
                        
                        Text(floor.displayName)
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(AppColors.darkBlue.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Walking time
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 12))
                        Text("\(area.walkingTime(floor: floor)) min")
                            .font(.poppins(.semiBold, size: 16))
                    }
                    .foregroundColor(AppColors.darkBlue)
                    
                    Text("walking")
                        .font(.poppins(.regular, size: 11))
                        .foregroundColor(AppColors.darkBlue.opacity(0.5))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            )
            
            // Navigation button
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isNavigating.toggle()
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isNavigating
                          ? "xmark.circle.fill"
                          : "location.fill")
                        .font(.system(size: 16))
                    Text(isNavigating ? "Stop Navigation" : "Start Navigation")
                        .font(.poppins(.semiBold, size: 17))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isNavigating
                              ? Color.red.opacity(0.85)
                              : AppColors.brandBlue)
                )
                .shadow(
                    color: (isNavigating ? Color.red : AppColors.brandBlue)
                        .opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
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
