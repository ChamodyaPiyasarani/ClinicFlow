import SwiftUI

// MARK: - After Visit Progress View

struct AfterVisitProgressView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let journey: VisitJourney

    // Animation states
    @State private var headerAppear = false
    @State private var statusCardAppear = false
    @State private var nextStepAppear = false
    @State private var progressAppear = false
    @State private var footerAppear = false
    @State private var checkmarkScale: CGFloat = 0
    @State private var checkmarkRotation: Double = -30
    @State private var shimmer = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MM - dd"
        return formatter.string(from: journey.date)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Header ──
                headerBar
                    .opacity(headerAppear ? 1 : 0)
                    .offset(y: headerAppear ? 0 : -12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        // ── Status Hero Card ──
                        statusHeroCard
                            .opacity(statusCardAppear ? 1 : 0)
                            .offset(y: statusCardAppear ? 0 : 30)

                        // ── Next Step Card ──
                        if journey.nextAction != nil {
                            nextStepCard
                                .opacity(nextStepAppear ? 1 : 0)
                                .offset(y: nextStepAppear ? 0 : 24)
                        } else {
                            visitCompleteCard
                                .opacity(nextStepAppear ? 1 : 0)
                                .offset(y: nextStepAppear ? 0 : 24)
                        }

                        // ── Visit Progress ──
                        visitProgressSection
                            .opacity(progressAppear ? 1 : 0)
                            .offset(y: progressAppear ? 0 : 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 120)
                }
            }

            // ── Bottom Action Bar ──
            bottomActionBar
                .opacity(footerAppear ? 1 : 0)
                .offset(y: footerAppear ? 0 : 40)
            
            BottomNavBar()
        }
        .navigationBarHidden(true)
        .onAppear { triggerAnimations() }
    }

    // MARK: - Animations

    private func triggerAnimations() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.82).delay(0.05)) {
            headerAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(0.12)) {
            statusCardAppear = true
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15)) {
            checkmarkScale = 1
            checkmarkRotation = 0
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(0.28)) {
            nextStepAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.38)) {
            progressAppear = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.46)) {
            footerAppear = true
        }
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true).delay(0.6)) {
            shimmer = true
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            BackButton {
                router.goBack()
            }
            Spacer()
            AppNameText(fontSize: 18)
            Spacer()
            NotificationIcon(unreadCount: 2, iconSize: 18, showBackground: true)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Status Hero Card

    private var statusHeroCard: some View {
        VStack(spacing: 0) {
            // Gradient header with status
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 45/255, green: 74/255, blue: 115/255),
                        Color(red: 80/255, green: 120/255, blue: 175/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Subtle decorative circles
                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 180, height: 180)
                    .offset(x: 100, y: -50)

                Circle()
                    .fill(Color.white.opacity(0.03))
                    .frame(width: 120, height: 120)
                    .offset(x: -110, y: 40)

                VStack(spacing: 14) {
                    // Current Status label + Done badge
                    HStack {
                        Text(languageManager.localized("avp_current_status"))
                            .font(.poppins(.medium, size: 13))
                            .foregroundColor(.white.opacity(0.8))

                        Spacer()

                        // Done badge
                        HStack(spacing: 5) {
                            Circle()
                                .fill(Color(red: 160/255, green: 230/255, blue: 130/255))
                                .frame(width: 7, height: 7)
                            Text(languageManager.localized("avp_done"))
                                .font(.poppins(.semiBold, size: 12))
                                .foregroundColor(Color(red: 160/255, green: 230/255, blue: 130/255))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.white.opacity(0.12))
                        )
                    }

                    // Completed title with checkmark
                    HStack(spacing: 10) {
                        Text(languageManager.localized("avp_consultation_completed"))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(.white)

                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(red: 160/255, green: 230/255, blue: 130/255))
                            .scaleEffect(checkmarkScale)
                            .rotationEffect(.degrees(checkmarkRotation))
                    }

                    // Doctor & details
                    VStack(spacing: 6) {
                        Text(journey.doctorName)
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(.white)

                        Text(languageManager.localized(journey.departmentKey))
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(.white.opacity(0.75))

                        HStack(spacing: 16) {
                            HStack(spacing: 5) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 12))
                                Text(dateString)
                                    .font(.poppins(.regular, size: 13))
                            }

                            HStack(spacing: 5) {
                                Image(systemName: "clock")
                                    .font(.system(size: 12))
                                Text("Time : \(journey.timeSlot)")
                                    .font(.poppins(.regular, size: 13))
                            }
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 22,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 22
                )
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: AppColors.darkBlue.opacity(0.12), radius: 16, x: 0, y: 8)
        )
    }

    // MARK: - Next Step Card

    @ViewBuilder
    private var nextStepCard: some View {
        if let action = journey.nextAction {
            VStack(alignment: .leading, spacing: 0) {
                // Header strip
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(action.queueStatus.queueType.color)

                    Text(languageManager.localized("avp_next_step"))
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkBlue)

                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 12)

                // Action description
                Text(languageManager.localized(action.descriptionKey))
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 14)

                // Divider
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 1)
                    .padding(.horizontal, 18)

                // Detail lines
                VStack(spacing: 12) {
                    ForEach(Array(action.detailLines.enumerated()), id: \.offset) { _, detail in
                        HStack(spacing: 12) {
                            Image(systemName: detail.icon)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(action.queueStatus.queueType.color)
                                .frame(width: 20)

                            Text(languageManager.localized(detail.labelKey))
                                .font(.poppins(.medium, size: 13))
                                .foregroundColor(.secondary)

                            Text(" –  ")
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.secondary)

                            Text(detail.value)
                                .font(.poppins(.semiBold, size: 13))
                                .foregroundColor(detail.valueColor ?? AppColors.darkBlue)

                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)

                // Join Queue button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    router.navigate(to: .queueStatus(action.queueStatus))
                }) {
                    HStack(spacing: 8) {
                        Text(languageManager.localized(action.actionButtonKey))
                            .font(.poppins(.semiBold, size: 15))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        action.queueStatus.queueType.color,
                                        action.queueStatus.queueType.color.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: action.queueStatus.queueType.color.opacity(0.35), radius: 8, x: 0, y: 4)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
        }
    }

    // MARK: - Visit Complete Card

    private var visitCompleteCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(red: 80/255, green: 200/255, blue: 120/255).opacity(0.12))
                    .frame(width: 64, height: 64)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Color(red: 80/255, green: 200/255, blue: 120/255))
                    .scaleEffect(checkmarkScale)
            }

            Text(languageManager.localized("avp_visit_complete"))
                .font(.poppins(.semiBold, size: 17))
                .foregroundColor(AppColors.darkBlue)

            Text(languageManager.localized("avp_visit_complete_desc"))
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }

    // MARK: - Visit Progress Section

    private var visitProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(languageManager.localized("visit_progress"))
                .font(.poppins(.semiBold, size: 16))
                .foregroundColor(AppColors.darkBlue)

            VStack(spacing: 0) {
                ForEach(Array(journey.steps.enumerated()), id: \.element.id) { index, step in
                    ProgressStepRow(
                        step: step,
                        isLast: index == journey.steps.count - 1,
                        languageManager: languageManager
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        )
    }

    // MARK: - Bottom Action Bar

    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                // Back to Home
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    router.selectedTab = .home
                    while router.path.count > 1 {
                        router.path.removeLast()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text(languageManager.localized("avp_back_to_home"))
                            .font(.poppins(.semiBold, size: 15))
                    }
                    .foregroundColor(AppColors.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppColors.darkBlue.opacity(0.25), lineWidth: 1.5)
                    )
                }

                // Join Queue (if next action exists)
                if let action = journey.nextAction {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        router.navigate(to: .queueStatus(action.queueStatus))
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "person.line.dotted.person.fill")
                                .font(.system(size: 15, weight: .semibold))
                            Text(languageManager.localized(action.actionButtonKey))
                                .font(.poppins(.semiBold, size: 15))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            action.queueStatus.queueType.color,
                                            action.queueStatus.queueType.color.opacity(0.85)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: action.queueStatus.queueType.color.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 32)
        }
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Progress Step Row (Compact Stepper)

private struct ProgressStepRow: View {
    let step: VisitStep
    let isLast: Bool
    let languageManager: LanguageManager

    private var circleColor: Color {
        switch step.status {
        case .completed:  return Color(red: 80/255, green: 190/255, blue: 110/255)
        case .inProgress: return AppColors.brandBlue
        case .pending:    return Color(.systemGray4)
        case .skipped:    return Color(.systemGray5)
        }
    }

    private var lineColor: Color {
        switch step.status {
        case .completed:  return Color(red: 80/255, green: 190/255, blue: 110/255).opacity(0.4)
        case .inProgress: return AppColors.brandBlue.opacity(0.3)
        default:          return Color(.systemGray5)
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // ── Stepper indicator column ──
            VStack(spacing: 0) {
                ZStack {
                    // Outer ring for in-progress
                    if step.status == .inProgress {
                        Circle()
                            .stroke(AppColors.brandBlue.opacity(0.2), lineWidth: 2.5)
                            .frame(width: 34, height: 34)
                    }

                    Circle()
                        .fill(step.status == .pending || step.status == .skipped
                              ? circleColor.opacity(0.35) : circleColor)
                        .frame(width: 28, height: 28)

                    Group {
                        if step.status == .completed {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        } else if step.status == .inProgress {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 9, height: 9)
                        } else if step.status == .skipped {
                            Image(systemName: "minus")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .frame(width: 34, height: 34)

                if !isLast {
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: 2.5, height: 36)
                }
            }

            // ── Step content ──
            VStack(alignment: .leading, spacing: 3) {
                Text(languageManager.localized(step.localizationKey))
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(
                        step.status == .pending || step.status == .skipped
                        ? .secondary : AppColors.darkBlue
                    )

                HStack(spacing: 6) {
                    Text(languageManager.localized(step.status.localizationKey))
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(
                            step.status == .completed
                            ? Color(red: 80/255, green: 190/255, blue: 110/255)
                            : step.status == .inProgress ? AppColors.brandBlue : .secondary
                        )

                    if let time = step.completedTime {
                        Text("at \(time)")
                            .font(.poppins(.regular, size: 11))
                            .foregroundColor(.secondary.opacity(0.8))
                    }
                }
            }
            .padding(.top, 5)

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("Consultation → Lab") {
    AfterVisitProgressView(journey: .consultationToLab)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}

#Preview("Consultation → Pharmacy") {
    AfterVisitProgressView(journey: .consultationToPharmacy)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}

#Preview("Visit Complete") {
    AfterVisitProgressView(journey: .consultationComplete)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
