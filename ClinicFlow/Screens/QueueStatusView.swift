import SwiftUI

// MARK: - Queue Status View

struct QueueStatusView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager

    let queueStatus: QueueStatus

    // Animation states
    @State private var headerAppear = false
    @State private var statusCardAppear = false
    @State private var locationAppear = false
    @State private var stepperAppear = false
    @State private var footerAppear = false
    @State private var showLeaveAlert = false
    @State private var pulseToken = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // ── Hero Token Card ──
                        heroTokenCard
                            .opacity(statusCardAppear ? 1 : 0)
                            .offset(y: statusCardAppear ? 0 : 30)

                        // ── Stats Row ──
                        statsRow
                            .opacity(statusCardAppear ? 1 : 0)
                            .offset(y: statusCardAppear ? 0 : 20)

                        // ── Location Card ──
                        locationCard
                            .opacity(locationAppear ? 1 : 0)
                            .offset(y: locationAppear ? 0 : 20)

                        // ── Horizontal Visit Progress ──
                        horizontalProgressSection
                            .opacity(stepperAppear ? 1 : 0)
                            .offset(y: stepperAppear ? 0 : 20)

                        // ── Notification Banner ──
                        notificationBanner
                            .opacity(footerAppear ? 1 : 0)
                            .offset(y: footerAppear ? 0 : 20)

                        // ── Leave Queue Button ──
                        leaveQueueButton
                            .opacity(footerAppear ? 1 : 0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }

                BottomNavBar()
            }
            .background(AppColors.background)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
            .onAppear {
                router.currentQueueStatus = queueStatus
                triggerStaggeredAnimations()
            }

            // ── Leave Queue Confirmation Popup ──
            if showLeaveAlert {
                LeaveQueueConfirmationPopup(
                    isPresented: $showLeaveAlert,
                    onConfirm: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        toastManager.show(.warning, message: "toast_queue_left")
                        router.currentQueueStatus = nil
                        router.goBack()
                    }
                )
            }
        }
    }

    // MARK: - Animations

    private func triggerStaggeredAnimations() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.05)) { headerAppear = true }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.12)) { statusCardAppear = true }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.2)) { locationAppear = true }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.28)) { stepperAppear = true }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.36)) { footerAppear = true }
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(0.5)) { pulseToken = true }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            BackButton { router.goBack() }
            Spacer()
            AppNameText(fontSize: 18)
            Spacer()
            NotificationIcon(unreadCount: 2, iconSize: 18, showBackground: true)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .opacity(headerAppear ? 1 : 0)
    }

    // MARK: - Hero Token Card

    private var heroTokenCard: some View {
        ZStack {
            // Gradient background
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            queueStatus.queueType.color,
                            queueStatus.queueType.color.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Subtle decorative circles
            GeometryReader { geo in
                Circle()
                    .fill(Color.white.opacity(0.07))
                    .frame(width: 140, height: 140)
                    .offset(x: geo.size.width - 60, y: -40)
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 100, height: 100)
                    .offset(x: -30, y: geo.size.height - 40)
            }

            VStack(spacing: 0) {
                // Top row: queue type badge + active indicator
                HStack {
                    // Queue type pill
                    HStack(spacing: 6) {
                        Image(systemName: queueStatus.queueType.icon)
                            .font(.system(size: 11, weight: .semibold))
                        Text(languageManager.localized(queueStatus.queueType.localizationKey))
                            .font(.poppins(.semiBold, size: 11))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white.opacity(0.2)))

                    Spacer()

                    // Active pill
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 7, height: 7)
                            .scaleEffect(pulseToken ? 1.3 : 1.0)
                        Text(languageManager.localized("active_status"))
                            .font(.poppins(.semiBold, size: 11))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white.opacity(0.15)))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Token Number — centrepiece, highlighted
                VStack(spacing: 6) {
                    Text(languageManager.localized("token_number").uppercased())
                        .font(.poppins(.bold, size: 10))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)

                    Text(queueStatus.tokenNumber)
                        .font(.poppins(.bold, size: 52))
                        .foregroundColor(.white)
                        .scaleEffect(pulseToken ? 1.05 : 1.0)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .padding(.vertical, 24)

                // Bottom divider
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 20)

                // Queue Position + People Ahead
                HStack(spacing: 0) {
                    VStack(spacing: 3) {
                        Text("\(queueStatus.queuePosition)")
                            .font(.poppins(.bold, size: 30))
                            .foregroundColor(.white)
                        Text(languageManager.localized("queue_position"))
                            .font(.poppins(.medium, size: 10))
                            .foregroundColor(.white.opacity(0.75))
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 36)

                    VStack(spacing: 3) {
                        Text("\(queueStatus.peopleAhead)")
                            .font(.poppins(.bold, size: 30))
                            .foregroundColor(.white)
                        Text(languageManager.localized("people_ahead"))
                            .font(.poppins(.medium, size: 10))
                            .foregroundColor(.white.opacity(0.75))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 20)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: queueStatus.queueType.color.opacity(0.3), radius: 20, x: 0, y: 10)
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatChip(
                icon: "clock.fill",
                label: languageManager.localized("estimated_wait"),
                value: "\(queueStatus.estimatedWaitMinutes) \(languageManager.localized("minutes_short"))",
                color: .orange
            )
            StatChip(
                icon: "arrow.right.circle.fill",
                label: languageManager.localized("check_in_time"),
                value: queueStatus.checkInTime,
                color: queueStatus.queueType.color
            )
        }
    }

    // MARK: - Location Card (tapping navigates to MapView)

    private var locationCard: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            router.selectedTab = .map
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(queueStatus.queueType.color.opacity(0.12))
                        .frame(width: 46, height: 46)
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(queueStatus.queueType.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(languageManager.localized("location"))
                        .font(.poppins(.medium, size: 10))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.8)
                    Text(queueStatus.locationName)
                        .font(.poppins(.semiBold, size: 13))
                        .foregroundColor(AppColors.darkBlue)
                    Text(queueStatus.locationDetail)
                        .font(.poppins(.regular, size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.brandBlue.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "map.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Horizontal Visit Progress

    private var horizontalProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(languageManager.localized("visit_progress"))
                .font(.poppins(.semiBold, size: 15))
                .foregroundColor(AppColors.darkBlue)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(queueStatus.steps.enumerated()), id: \.element.id) { index, step in
                        HStack(spacing: 0) {
                            HorizontalStepNode(
                                step: step,
                                accentColor: queueStatus.queueType.color,
                                languageManager: languageManager
                            )

                            if index < queueStatus.steps.count - 1 {
                                // Connector line
                                Rectangle()
                                    .fill(
                                        step.status == .completed
                                            ? queueStatus.queueType.color.opacity(0.5)
                                            : Color(.systemGray4)
                                    )
                                    .frame(width: 24, height: 2)
                                    .padding(.bottom, 22)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    // MARK: - Notification Banner

    private var notificationBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.brandBlue.opacity(0.1))
                    .frame(width: 38, height: 38)
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.brandBlue)
            }

            Text(languageManager.localized("waiting_for_turn"))
                .font(.poppins(.medium, size: 13))
                .foregroundColor(AppColors.darkBlue)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.brandBlue.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(AppColors.brandBlue.opacity(0.12), lineWidth: 1)
                )
        )
    }

    // MARK: - Leave Queue Button

    private var leaveQueueButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showLeaveAlert = true
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 13, weight: .medium))
                Text(languageManager.localized("leave_queue"))
                    .font(.poppins(.medium, size: 13))
            }
            .foregroundColor(Color.red.opacity(0.55))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.red.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.red.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 4)
    }
}

// MARK: - Stat Chip

private struct StatChip: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.poppins(.regular, size: 10))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.poppins(.bold, size: 14))
                    .foregroundColor(AppColors.darkBlue)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Horizontal Step Node

private struct HorizontalStepNode: View {
    let step: VisitStep
    let accentColor: Color
    let languageManager: LanguageManager

    private var circleColor: Color {
        switch step.status {
        case .completed:  return accentColor
        case .inProgress: return accentColor
        case .pending:    return Color(.systemGray4)
        case .skipped:    return Color(.systemGray5)
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            // Step circle
            ZStack {
                Circle()
                    .fill(circleColor.opacity(step.status == .pending || step.status == .skipped ? 0.18 : 1.0))
                    .frame(width: 34, height: 34)

                if step.status == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                } else if step.status == .inProgress {
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 26, height: 26)
                    Image(systemName: step.icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: step.icon)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(.systemGray3))
                }
            }

            // Step label
            Text(languageManager.localized(step.localizationKey))
                .font(.poppins(.medium, size: 9))
                .foregroundColor(
                    step.status == .pending || step.status == .skipped
                        ? .secondary
                        : AppColors.darkBlue
                )
                .multilineTextAlignment(.center)
                .frame(width: 58)

            // Status / time
            if let time = step.completedTime {
                Text(time)
                    .font(.poppins(.regular, size: 8))
                    .foregroundColor(.secondary)
            } else {
                Text(languageManager.localized(step.status.localizationKey))
                    .font(.poppins(.regular, size: 8))
                    .foregroundColor(step.status == .inProgress ? accentColor : .secondary)
            }
        }
        .frame(width: 60)
    }
}

// MARK: - Leave Queue Confirmation Popup

private struct LeaveQueueConfirmationPopup: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var isPresented: Bool
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismissModal() }

            VStack(spacing: 0) {
                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 72, height: 72)
                            .blur(radius: 8)

                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 64, height: 64)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.red.opacity(0.2), radius: 12, x: 0, y: 4)

                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.red.opacity(0.9), Color.red],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .padding(.top, 36)

                    VStack(spacing: 10) {
                        Text(languageManager.localized("leave_queue"))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(AppColors.darkBlue)

                        Text(languageManager.localized("leave_queue_message"))
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }

                    VStack(spacing: 12) {
                        Button(action: {
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { isPresented = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onConfirm() }
                        }) {
                            Text(languageManager.localized("leave_queue_confirm"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        LinearGradient(colors: [Color.red.opacity(0.9), Color.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .topLeading, endPoint: .center)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                .shadow(color: Color.red.opacity(0.4), radius: 12, x: 0, y: 6)
                        }

                        Button(action: { dismissModal() }) {
                            Text(languageManager.localized("cancel"))
                                .font(.poppins(.medium, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(LinearGradient(colors: [Color.white.opacity(0.6), Color.gray.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.85))
                        .background(RoundedRectangle(cornerRadius: 32, style: .continuous).fill(.regularMaterial))
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(Color.black.opacity(0.05), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
            .padding(.horizontal, 28)
            .scaleEffect(isPresented ? 1 : 0.9)
            .opacity(isPresented ? 1 : 0)
        }
        .transition(.opacity)
    }

    private func dismissModal() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { isPresented = false }
    }
}

// MARK: - Preview

#Preview {
    QueueStatusView(queueStatus: .opdSample)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
        .environment(ToastManager.shared)
}
