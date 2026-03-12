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
    
    var displayNameKey: String {
        "floor_prefix"
    }
    
    var fullName: String {
        switch self {
        case .floor1: return "First Floor"
        case .floor2: return "Second Floor"
        case .floor3: return "Third Floor"
        }
    }
    
    var fullNameKey: String {
        switch self {
        case .floor1: return "first_floor"
        case .floor2: return "second_floor"
        case .floor3: return "third_floor"
        }
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
    
    var subtitleKey: String {
        switch self {
        case .floor1: return "main_entrance"
        case .floor2: return "specialist_wing"
        case .floor3: return "map_diagnostics"
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
    case radiology
    case imaging
    case bloodTest
    case pathology
    case waitingArea
    case specimenCollection
    case elevator
    
    var displayName: String {
        switch self {
        case .registration: return "Registration"
        case .consultation: return "Consultation"
        case .laboratory: return "Laboratory"
        case .pharmacy: return "Pharmacy"
        case .payment: return "Payment"
        case .restrooms: return "Restrooms"
        case .radiology: return "Radiology"
        case .imaging: return "Imaging"
        case .bloodTest: return "Blood Test"
        case .pathology: return "Pathology"
        case .waitingArea: return "Waiting Area"
        case .specimenCollection: return "Specimen Collection"
        case .elevator: return "Elevator"
        }
    }
    
    var localizationKey: String {
        switch self {
        case .registration: return "registration"
        case .consultation: return "consultation"
        case .laboratory: return "laboratory"
        case .pharmacy: return "pharmacy_area"
        case .payment: return "payment"
        case .restrooms: return "restrooms"
        case .radiology: return "radiology"
        case .imaging: return "imaging"
        case .bloodTest: return "blood_test"
        case .pathology: return "pathology"
        case .waitingArea: return "waiting_area"
        case .specimenCollection: return "specimen_collection"
        case .elevator: return "elevator"
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
        case .radiology: return "xmark.shield.fill"
        case .imaging: return "camera.metering.matrix"
        case .bloodTest: return "drop.fill"
        case .pathology: return "cross.vial.fill"
        case .waitingArea: return "person.3.fill"
        case .specimenCollection: return "syringe.fill"
        case .elevator: return "arrow.up.arrow.down.circle.fill"
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
        case .radiology:    return Color(red: 255/255, green: 99/255, blue: 132/255)
        case .imaging:      return Color(red: 54/255, green: 162/255, blue: 235/255)
        case .bloodTest:    return Color(red: 220/255, green: 53/255, blue: 69/255)
        case .pathology:    return Color(red: 153/255, green: 102/255, blue: 255/255)
        case .waitingArea:  return Color(red: 102/255, green: 187/255, blue: 106/255)
        case .specimenCollection: return Color(red: 255/255, green: 152/255, blue: 0/255)
        case .elevator:     return Color(red: 52/255, green: 73/255, blue: 94/255)
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
        case .radiology:    return Color(red: 255/255, green: 230/255, blue: 235/255)
        case .imaging:      return Color(red: 227/255, green: 242/255, blue: 253/255)
        case .bloodTest:    return Color(red: 255/255, green: 225/255, blue: 230/255)
        case .pathology:    return Color(red: 243/255, green: 237/255, blue: 255/255)
        case .waitingArea:  return Color(red: 232/255, green: 245/255, blue: 233/255)
        case .specimenCollection: return Color(red: 255/255, green: 243/255, blue: 224/255)
        case .elevator:     return Color(red: 236/255, green: 240/255, blue: 243/255)
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
        case .radiology:    return "\(base + 7)"
        case .imaging:      return "\(base + 8)"
        case .bloodTest:    return "\(base + 9)"
        case .pathology:    return "\(base + 10)"
        case .waitingArea:  return "\(base + 11)"
        case .specimenCollection: return "\(base + 12)"
        case .elevator:     return floor == .floor1 ? "Lift" : "Lift"
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
            case .radiology: return 4
            case .imaging: return 4
            case .bloodTest: return 3
            case .pathology: return 5
            case .waitingArea: return 1
            case .specimenCollection: return 2
            case .elevator: return 0
            }
        case .floor2:
            switch self {
            case .registration: return 0
            case .consultation: return 2
            case .laboratory: return 4
            case .pharmacy: return 3
            case .payment: return 3
            case .restrooms: return 2
            case .radiology: return 3
            case .imaging: return 3
            case .bloodTest: return 4
            case .pathology: return 5
            case .waitingArea: return 1
            case .specimenCollection: return 2
            case .elevator: return 0
            }
        case .floor3:
            switch self {
            case .registration: return 0
            case .consultation: return 2
            case .laboratory: return 5
            case .pharmacy: return 4
            case .payment: return 3
            case .restrooms: return 2
            case .radiology: return 4
            case .imaging: return 4
            case .bloodTest: return 3
            case .pathology: return 4
            case .waitingArea: return 1
            case .specimenCollection: return 2
            case .elevator: return 0
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
                VStack(spacing: 16) {
                    // Floor Selector
                    FloorSelector(selectedFloor: $selectedFloor, selectedArea: $selectedArea)
                        .padding(.top, 8)
                    
                    // Map Container with smooth animation
                    MapContainer(
                        selectedFloor: selectedFloor,
                        selectedArea: $selectedArea,
                        isNavigating: selectedArea != nil && selectedArea != .registration
                    )
                    
                    // Destination Info
                    if let area = selectedArea, area != .registration {
                        DestinationInfoView(
                            area: area,
                            floor: selectedFloor
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .background(AppColors.background)
        .onChange(of: selectedFloor) { _, _ in
            // Keep the selected area when switching floors
        }
    }
}

// MARK: - Header

private struct MapHeaderView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            AppNameText(fontSize: 20)
            
            HStack(spacing: 4) {
                BackButton { router.goBack() }
                Spacer()
                NotificationIcon(unreadCount: 3, iconSize: 18)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

// MARK: - Floor Selector

private struct FloorSelector: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedFloor: Floor
    @Binding var selectedArea: ClinicArea?
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Floor.allCases, id: \.self) { floor in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedFloor = floor
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    FloorSelectorButton(
                        floor: floor,
                        isSelected: selectedFloor == floor,
                        selectedFloor: selectedFloor,
                        animation: animation
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 240/255, green: 242/255, blue: 245/255))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Floor Selector Button

private struct FloorSelectorButton: View {
    @Environment(LanguageManager.self) var languageManager
    let floor: Floor
    let isSelected: Bool
    let selectedFloor: Floor
    let animation: Namespace.ID
    
    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.brandBlue)
                    .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 4, x: 0, y: 5)
                    .matchedGeometryEffect(id: "floor_selector", in: animation)
            }
            
            Text(languageManager.localized(floor.fullNameKey))
                .font(.poppins(isSelected ? .semiBold : .medium, size: isSelected ? 15 : 14))
                .foregroundColor(isSelected ? .white : AppColors.darkBlue.opacity(0.6))
                .animation(.easeInOut(duration: 0.2), value: selectedFloor)
                .padding(.vertical, 15)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

// MARK: - Map Container

private struct MapContainer: View {
    @Environment(LanguageManager.self) var languageManager
    let selectedFloor: Floor
    @Binding var selectedArea: ClinicArea?
    let isNavigating: Bool
    
    @State private var previousFloor: Floor?
    
    var body: some View {
        ZStack {
            // Simple white background without gradients
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color(red: 220/255, green: 225/255, blue: 230/255),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            
            // Floor-specific layout with smooth transition
            Group {
                switch selectedFloor {
                case .floor1:
                    Floor1Layout(selectedArea: $selectedArea)
                        .transition(floorTransition(from: previousFloor, to: .floor1))
                case .floor2:
                    Floor2Layout(selectedArea: $selectedArea)
                        .transition(floorTransition(from: previousFloor, to: .floor2))
                case .floor3:
                    Floor3Layout(selectedArea: $selectedArea)
                        .transition(floorTransition(from: previousFloor, to: .floor3))
                }
            }
            .id(selectedFloor)
            
            // Navigation path overlay
            if isNavigating, let destination = selectedArea, destination != .registration {
                NavigationPathOverlay(to: destination, floor: selectedFloor)
                    .transition(.opacity.animation(.easeInOut(duration: 0.4)))
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: selectedFloor) { oldValue, newValue in
            previousFloor = oldValue
        }
    }
    
    private func floorTransition(from oldFloor: Floor?, to newFloor: Floor) -> AnyTransition {
        guard let oldFloor = oldFloor else {
            return .opacity.combined(with: .scale(scale: 0.95))
        }
        
        let isMovingUp = newFloor.rawValue > oldFloor.rawValue
        let insertionEdge: Edge = isMovingUp ? .trailing : .leading
        let removalEdge: Edge = isMovingUp ? .leading : .trailing
        
        let insertion = AnyTransition.asymmetric(
            insertion: .move(edge: insertionEdge)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.9)),
            removal: .move(edge: removalEdge)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.9))
        )
        
        return insertion.animation(.easeInOut(duration: 0.5))
    }
}

// MARK: - Floor 1 Layout (Ground Floor - Main Services)

private struct Floor1Layout: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedArea: ClinicArea?
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            EntranceMarker()
                .padding(.top, 16)
                .padding(.bottom, 8)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : -10)
            
            // Row 1: Registration & Consultation (Wide layout)
            HStack(spacing: 10) {
                MapAreaCard(
                    area: .registration,
                    floor: .floor1,
                    isSelected: selectedArea == .registration,
                    isYouAreHere: true
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .registration
                    }
                }
                
                MapAreaCard(
                    area: .consultation,
                    floor: .floor1,
                    isSelected: selectedArea == .consultation
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .consultation
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("main_corridor"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 2: Pharmacy (Full width - Main pharmacy)
            VStack(spacing: 8) {
                MapAreaCard(
                    area: .pharmacy,
                    floor: .floor1,
                    isSelected: selectedArea == .pharmacy,
                    fullWidth: true
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .pharmacy
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("south_wing"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 3: Payment & Restrooms
            HStack(spacing: 10) {
                MapAreaCard(
                    area: .payment,
                    floor: .floor1,
                    isSelected: selectedArea == .payment
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .payment
                    }
                }
                
                MapAreaCard(
                    area: .restrooms,
                    floor: .floor1,
                    isSelected: selectedArea == .restrooms
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .restrooms
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            StaircaseIndicator(currentFloor: .floor1)
                .padding(.top, 10)
                .padding(.bottom, 16)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Floor 2 Layout (Specialist Wing - Different Shape)

private struct Floor2Layout: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedArea: ClinicArea?
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 12))
                Text(languageManager.localized("specialist_wing"))
                    .font(.poppins(.medium, size: 12))
            }
            .foregroundColor(AppColors.darkBlue.opacity(0.5))
            .padding(.top, 16)
            .padding(.bottom, 8)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : -10)
            
            // Elevator (Starting Point)
            MapAreaCard(
                area: .elevator,
                floor: .floor2,
                isSelected: selectedArea == .elevator,
                isYouAreHere: true,
                compactSize: true
            ) { 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArea = .elevator
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 120)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : -10)
            
            CorridorStrip(label: "⬇")
                .opacity(isVisible ? 1 : 0)
            
            // Row 1: Large Consultation block (Specialist rooms)
            MapAreaCard(
                area: .consultation,
                floor: .floor2,
                isSelected: selectedArea == .consultation,
                fullWidth: true,
                height: 75
            ) { 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArea = .consultation
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("main_corridor"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 2: Lab & Registration (L-shaped configuration)
            HStack(spacing: 10) {
                MapAreaCard(
                    area: .laboratory,
                    floor: .floor2,
                    isSelected: selectedArea == .laboratory
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .laboratory
                    }
                }
                
                VStack(spacing: 8) {
                    MapAreaCard(
                        area: .waitingArea,
                        floor: .floor2,
                        isSelected: selectedArea == .waitingArea,
                        compactSize: true
                    ) { 
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedArea = .waitingArea
                        }
                    }
                    
                    MapAreaCard(
                        area: .restrooms,
                        floor: .floor2,
                        isSelected: selectedArea == .restrooms,
                        compactSize: true
                    ) { 
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedArea = .restrooms
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("east_corridor"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 3: Radiology & Imaging Labs
            HStack(spacing: 10) {
                MapAreaCard(
                    area: .radiology,
                    floor: .floor2,
                    isSelected: selectedArea == .radiology
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .radiology
                    }
                }
                
                MapAreaCard(
                    area: .imaging,
                    floor: .floor2,
                    isSelected: selectedArea == .imaging
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .imaging
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            StaircaseIndicator(currentFloor: .floor2)
                .padding(.top, 10)
                .padding(.bottom, 16)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Floor 3 Layout (Diagnostics - Compact Layout)

private struct Floor3Layout: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedArea: ClinicArea?
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 12))
                Text(languageManager.localized("map_diagnostics"))
                    .font(.poppins(.medium, size: 12))
            }
            .foregroundColor(AppColors.darkBlue.opacity(0.5))
            .padding(.top, 16)
            .padding(.bottom, 8)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : -10)
            
            // Elevator (Starting Point)
            MapAreaCard(
                area: .elevator,
                floor: .floor3,
                isSelected: selectedArea == .elevator,
                isYouAreHere: true,
                compactSize: true
            ) { 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArea = .elevator
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 120)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : -10)
            
            CorridorStrip(label: "⬇")
                .opacity(isVisible ? 1 : 0)
            
            // Row 1: Three compact rooms (Specimen Collection, Blood Test, Restrooms)
            HStack(spacing: 8) {
                MapAreaCard(
                    area: .specimenCollection,
                    floor: .floor3,
                    isSelected: selectedArea == .specimenCollection,
                    compactSize: true
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .specimenCollection
                    }
                }
                
                MapAreaCard(
                    area: .bloodTest,
                    floor: .floor3,
                    isSelected: selectedArea == .bloodTest,
                    compactSize: true
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .bloodTest
                    }
                }
                
                MapAreaCard(
                    area: .restrooms,
                    floor: .floor3,
                    isSelected: selectedArea == .restrooms,
                    compactSize: true
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .restrooms
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("central_corridor"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 2: Large Laboratory (Main diagnostic center)
            MapAreaCard(
                area: .laboratory,
                floor: .floor3,
                isSelected: selectedArea == .laboratory,
                fullWidth: true,
                height: 75
            ) { 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedArea = .laboratory
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            CorridorStrip(label: languageManager.localized("south_wing"))
                .opacity(isVisible ? 1 : 0)
            
            // Row 3: Consultation & Pathology Lab
            HStack(spacing: 10) {
                MapAreaCard(
                    area: .consultation,
                    floor: .floor3,
                    isSelected: selectedArea == .consultation
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .consultation
                    }
                }
                
                MapAreaCard(
                    area: .pathology,
                    floor: .floor3,
                    isSelected: selectedArea == .pathology
                ) { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedArea = .pathology
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            
            StaircaseIndicator(currentFloor: .floor3)
                .padding(.top, 10)
                .padding(.bottom, 16)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Entrance Marker

private struct EntranceMarker: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.brandBlue)
            
            Text(languageManager.localized("main_entrance"))
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
        .padding(.vertical, 4)
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
    @Environment(LanguageManager.self) var languageManager
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
                    Text(languageManager.localized("staircase"))
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(AppColors.darkBlue)
                    Text(languageManager.localized("connects_all_floors"))
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
                    Text(languageManager.localized("elevator"))
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(AppColors.darkBlue)
                    Text("\(languageManager.localized("floor_prefix")) \(currentFloor.rawValue)")
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
    @Environment(LanguageManager.self) var languageManager
    let area: ClinicArea
    let floor: Floor
    let isSelected: Bool
    var isYouAreHere: Bool = false
    var fullWidth: Bool = false
    var height: CGFloat? = nil
    var compactSize: Bool = false
    let action: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button {
            action()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            ZStack(alignment: .topLeading) {
                // Card background with animated appearance
                RoundedRectangle(cornerRadius: compactSize ? 12 : 14)
                    .fill(area.lightBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: compactSize ? 12 : 14)
                            .stroke(
                                isSelected
                                    ? area.backgroundColor
                                    : area.backgroundColor.opacity(0.2),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                
                VStack(spacing: compactSize ? 2 : 4) {
                    // Icon with colored circle
                    ZStack {
                        Circle()
                            .fill(area.backgroundColor.opacity(0.15))
                            .frame(width: compactSize ? 24 : 34, height: compactSize ? 24 : 34)
                        Image(systemName: area.icon)
                            .font(.system(size: compactSize ? 12 : 16, weight: .medium))
                            .foregroundColor(area.backgroundColor)
                    }
                    
                    // Area name
                    Text(languageManager.localized(area.localizationKey))
                        .font(.poppins(.semiBold, size: compactSize ? 10 : 12))
                        .foregroundColor(AppColors.darkBlue)
                        .lineLimit(compactSize ? 2 : 1)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                    
                    // Room number
                    if !compactSize {
                        Text("\(languageManager.localized("room_prefix")) \(area.roomNumber(floor: floor))")
                            .font(.poppins(.regular, size: 9))
                            .foregroundColor(AppColors.darkBlue.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, compactSize ? 6 : 8)
                .padding(.horizontal, compactSize ? 4 : 8)
                
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
                if !compactSize && area.walkingTime(floor: floor) > 0 {
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
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: height ?? (compactSize ? 60 : 85))
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: fullWidth ? .infinity : .infinity)
        .shadow(
            color: isSelected ? area.backgroundColor.opacity(0.3) : .clear,
            radius: isSelected ? 8 : 0,
            x: 0,
            y: isSelected ? 4 : 0
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
    }
}
// MARK: - Navigation Path Overlay

private struct NavigationPathOverlay: View {
    let to: ClinicArea
    let floor: Floor
    
    var body: some View {
        Canvas { context, size in
            let leftX = size.width * 0.28
            let centerX = size.width * 0.5
            let rightX = size.width * 0.72
            
            let rowYs: [CGFloat]
            let corridorYs: [CGFloat]
            let startX: CGFloat
            let startY: CGFloat
            
            if floor == .floor1 {
                rowYs = [size.height * 0.18, size.height * 0.48, size.height * 0.78]
                corridorYs = [size.height * 0.33, size.height * 0.63]
                startX = leftX
                startY = rowYs[0]
            } else if floor == .floor2 {
                rowYs = [size.height * 0.11, size.height * 0.30, size.height * 0.56, size.height * 0.83]
                corridorYs = [size.height * 0.20, size.height * 0.43, size.height * 0.70]
                startX = centerX
                startY = rowYs[0]
            } else { // Floor 3
                rowYs = [size.height * 0.14, size.height * 0.34, size.height * 0.56, size.height * 0.82]
                corridorYs = [size.height * 0.24, size.height * 0.45, size.height * 0.69]
                startX = centerX
                startY = rowYs[0]
            }
            
            let dest = areaRowCol(for: to, floor: floor)
            let endX = dest.col == 0 ? leftX : (dest.col == 1 ? rightX : centerX)
            
            // Safety check for array bounds
            let safeRow = max(0, min(dest.row, rowYs.count - 1))
            let endY = rowYs[safeRow]
            
            var path = Path()
            path.move(to: CGPoint(x: startX, y: startY))
            
            if floor == .floor1 {
                if dest.row == 0 && dest.col == 1 {
                    // Same row, go through corridor
                    path.addLine(to: CGPoint(x: startX, y: corridorYs[0]))
                    path.addLine(to: CGPoint(x: endX, y: corridorYs[0]))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                } else if startX == endX {
                    // Same column, straight down
                    path.addLine(to: CGPoint(x: startX, y: endY))
                } else {
                    // Different row and column, route through corridor
                    let corridorIdx = max(0, min(dest.row - 1, corridorYs.count - 1))
                    let corridorY = corridorYs[corridorIdx]
                    path.addLine(to: CGPoint(x: startX, y: corridorY))
                    path.addLine(to: CGPoint(x: endX, y: corridorY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
            } else {
                // For Floor 2 & 3
                if startX == endX {
                    path.addLine(to: CGPoint(x: startX, y: endY))
                } else {
                    let corridorIdx = max(0, min(dest.row - 1, corridorYs.count - 1))
                    let corridorY = corridorYs[corridorIdx]
                    path.addLine(to: CGPoint(x: startX, y: corridorY))
                    path.addLine(to: CGPoint(x: endX, y: corridorY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
            }
            
            // Draw dashed navigation line
            context.stroke(
                path,
                with: .color(AppColors.brandBlue.opacity(0.7)),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [8, 6])
            )
            
            // Draw start point
            context.fill(Path(ellipseIn: CGRect(x: startX - 5, y: startY - 5, width: 10, height: 10)), with: .color(AppColors.brandBlue))
            
            // Draw end point (outer glow + inner dot)
            context.fill(Path(ellipseIn: CGRect(x: endX - 7, y: endY - 7, width: 14, height: 14)), with: .color(AppColors.brandBlue.opacity(0.25)))
            context.fill(Path(ellipseIn: CGRect(x: endX - 4, y: endY - 4, width: 8, height: 8)), with: .color(AppColors.brandBlue))
            
            // Draw arrowhead at destination
            let arrowSize: CGFloat = 10
            let angle: CGFloat
            if floor == .floor1 && dest.row == 0 && dest.col == 1 {
                angle = -.pi / 2 // Pointing upwards
            } else if startX == endX {
                angle = .pi / 2
            } else {
                angle = .pi / 2
            }
            
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: endX, y: endY))
            arrowPath.addLine(to: CGPoint(x: endX - arrowSize * cos(angle - .pi / 6), y: endY - arrowSize * sin(angle - .pi / 6)))
            arrowPath.move(to: CGPoint(x: endX, y: endY))
            arrowPath.addLine(to: CGPoint(x: endX - arrowSize * cos(angle + .pi / 6), y: endY - arrowSize * sin(angle + .pi / 6)))
            
            context.stroke(arrowPath, with: .color(AppColors.brandBlue), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
        .allowsHitTesting(false)
    }
    
    private func areaRowCol(for area: ClinicArea, floor: Floor) -> (row: Int, col: Int) {
        switch floor {
        case .floor1:
            switch area {
            case .registration: return (0, 0)
            case .consultation: return (0, 1)
            case .pharmacy:     return (1, 2)
            case .payment:      return (2, 0)
            case .restrooms:    return (2, 1)
            default:            return (1, 0)
            }
        case .floor2:
            switch area {
            case .elevator:     return (0, 2)
            case .consultation: return (1, 2)
            case .laboratory:   return (2, 0)
            case .waitingArea:  return (2, 1)
            case .restrooms:    return (2, 1)
            case .radiology:    return (3, 0)
            case .imaging:      return (3, 1)
            default:            return (1, 0)
            }
        case .floor3:
            switch area {
            case .elevator:           return (0, 2)
            case .specimenCollection: return (1, 0)
            case .bloodTest:          return (1, 2)
            case .restrooms:          return (1, 1)
            case .laboratory:         return (2, 2)
            case .consultation:       return (3, 0)
            case .pathology:          return (3, 1)
            default:                  return (1, 0)
            }
        }
    }
}

// MARK: - Destination Info

private struct DestinationInfoView: View {
    @Environment(LanguageManager.self) var languageManager
    let area: ClinicArea
    let floor: Floor
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Direction indicator
            HStack(spacing: 8) {
                Image(systemName: "arrow.forward.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.brandBlue)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(languageManager.localized("directions_to"))
                        .font(.poppins(.medium, size: 12))
                        .foregroundColor(AppColors.darkBlue.opacity(0.6))
                    
                    Text(languageManager.localized(area.localizationKey))
                        .font(.poppins(.bold, size: 18))
                        .foregroundColor(AppColors.darkBlue)
                }
                
                Spacer()
                
                // Walking time
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 12))
                        Text("\(area.walkingTime(floor: floor))")
                            .font(.poppins(.bold, size: 20))
                    }
                    .foregroundColor(AppColors.brandBlue)
                    .scaleEffect(isAnimating ? 1.05 : 0.95)
                    
                    Text(languageManager.localized("min_suffix"))
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(AppColors.darkBlue.opacity(0.5))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.brandBlue.opacity(0.05),
                                area.lightBackground
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.brandBlue.opacity(0.2), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MapView()
        .environment(LanguageManager.shared)
        .environment(AppRouter.shared)
}
