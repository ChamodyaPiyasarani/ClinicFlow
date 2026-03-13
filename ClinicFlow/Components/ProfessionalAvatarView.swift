import SwiftUI

struct ProfessionalAvatarView: View {
    var image: UIImage? = nil
    var systemIcon: String = "person.crop.circle.fill"
    var size: CGFloat = 60
    var gradientColors: [Color] = [
        Color(red: 90/255, green: 140/255, blue: 210/255),
        Color(red: 60/255, green: 110/255, blue: 180/255)
    ]
    var showBorder: Bool = true
    
    var body: some View {
        ZStack {
            // Background Gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Content
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: systemIcon)
                    .font(.system(size: size * 0.5, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            
            // Premium Overlay/Border
            if showBorder {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.6),
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: size * 0.03
                    )
                    .frame(width: size - (size * 0.015), height: size - (size * 0.015))
            }
        }
        .shadow(color: gradientColors[0].opacity(0.25), radius: size * 0.1, x: 0, y: size * 0.05)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProfessionalAvatarView(size: 100)
        ProfessionalAvatarView(size: 60, gradientColors: [.orange, .red])
        ProfessionalAvatarView(systemIcon: "person.2.fill", size: 44)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
