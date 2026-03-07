import SwiftUI

/// Reusable app name component displaying "CLINIC" in dark blue and "FLOW" in lighter blue.
struct AppNameText: View {
    var fontSize: CGFloat = 28
    var clinicColor: Color = AppColors.darkBlue
    var flowColor: Color = AppColors.brandBlue
    
    var body: some View {
        HStack(spacing: 0) {
            Text("CLINIC")
                .font(.poppins(.extraBold, size: fontSize))
                .foregroundColor(clinicColor)
            
            Text("FLOW")
                .font(.poppins(.bold, size: fontSize))
                .foregroundColor(flowColor)
        }
        .tracking(2)
    }
}

#Preview {
    AppNameText()
}
