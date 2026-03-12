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

    // Active step for the stepper
    private var currentStepIndex: Int {
        queueStatus.steps.firstIndex(where: { $0.status == .inProgress }) ?? 0
    }

    private var completedSteps: Int {
        queueStatus.steps.filter { $0.status == .completed }.count
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // ── Header ──
                headerBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        statusHeroCard
                            .opacity(statusCardAppear ? 1 : 0)
                            .offset(y: statusCardAppear ? 0 : 30)

                        quickStatsRow
                            .opacity(statusCardAppear ? 1 : 0)
                            .offset(y: statusCardAppear ? 0 : 20)

                        locationCard
                            .opacity(locationAppear ? 1 : 0)
                            .offset(y: locationAppear ? 0 : 20)

                        visitProgressSection
                            .opacity(stepperAppear ? 1 : 0)
                            .offset(y: stepperAppear ? 0 : 20)

                        notificationBanner
                            .opacity(footerAppear ? 1 : 0)
                            .offset(y: footerAppear ? 0 : 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 120)
                }
            }
            .background(AppColors.background)

            // ── Floating Leave Queue Bar ──
            leaveQueueBar
                .opacity(footerAppear ? 1 : 0)
                .offset(y: footerAppear ? 0 : 30)
            
            BottomNavBar()
        }
        .navigationBarHidden(true)
        .alert(languageManager.localized("leave_queue"), isPresented: $showLeaveAlert) {
            Button(languageManager.localized("cancel"), role: .cancel) {}
            Button(languageManager.localized("leave_queue_confirm"), role: .destructive) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                toastManager.show(.warning, message: "toast_queue_left")
                router.goBack()
            }
        } message: {
            Text(languageManager.localized("leave_queue_message"))
        }
        .onAppear { triggerStaggeredAnimations() }
    }

    // MARK: - Staggered Animations

    private func triggerStaggeredAnimations() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.05)) {
            headerAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.12)) {
            statusCardAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.2)) {
            locationAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.28)) {
            stepperAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.36)) {
            footerAppear = true
        }
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.5)) {
            pulseToken = true
        }
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

    // MARK: - Status Hero Card

    private var statusHeroCard: some View {
        VStack(spacing: 0) {
            // Colored header strip
            ZStack {
                LinearGradient(
                    colors: [queueStatus.queueType.color, queueStatus.queueType.color.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 8) {
                    // Queue type badge
                    HStack(spacing: 6) {
                        Image(systemName: queueStatus.queueType.icon)
                            .font(.system(size: 12, weight: .semibold))
                        Text(languageManager.localized(queueStatus.queueType.localizationKey))
                            .font(.poppins(.semiBold, size: 12))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.22)))

                    // Token Number — large, prominent
                    Text(queueStatus.tokenNumber)
                        .font(.poppins(.bold, size: 40))
                        .foregroundColor(.white)
                        .scaleEffect(pulseToken ? 1.03 : 1.0)

                    Text(languageManager.localized("token_number"))
                        .font(.poppins(.medium, size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.vertical, 28)
            }

            // White bottom section — queue position
            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    // Queue Position
                    VStack(spacing: 4) {
                        Text("\(queueStatus.queuePosition)")
                            .font(.poppins(.bold, size: 32))
                            .foregroundColor(queueStatus.queueType.color)
                        Text(languageManager.localized("queue_position"))
                            .font(.poppins(.medium, size: 11))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    // Divider
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 1, height: 40)

                    // People Ahead
                    VStack(spacing: 4) {
                        Text("\(queueStatus.peopleAhead)")
                            .font(.poppins(.bold, size: 32))
                            .foregroundColor(AppColors.darkBlue)
                        Text(languageManager.localized("people_ahead"))
                            .font(.poppins(.medium, size: 11))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 16)

                // Active badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(languageManager.localized("active_status"))
                        .font(.poppins(.semiBold, size: 12))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.1))
                )
                .padding(.bottom, 16)
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: queueStatus.queueType.color.opacity(0.15), radius: 16, x: 0, y: 8)
    }

    // MARK: - Quick Stats Row

    private var quickStatsRow: some View {
        HStack(spacing: 12) {
            QuickStatPill(
                icon: "clock.fill",
                label: languageManager.localized("estimated_wait"),
                value: "\(queueStatus.estimatedWaitMinutes) \(languageManager.localized("minutes_short"))",
                color: .orange
            )

            QuickStatPill(
                icon: "arrow.right.circle.fill",
                label: languageManager.localized("check_in_time"),
                value: queueStatus.checkInTime,
                color: queueStatus.queueType.color
            )
        }
    }

    // MARK: - Location Card

    private var locationCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(queueStatus.queueType.color.opacity(0.1))
                    .frame(width: 46, height: 46)
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(queueStatus.queueType.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(languageManager.localized("location"))
                    .font(.poppins(.medium, size: 11))
                    .foregroundColor(.secondary)
                Text(queueStatus.locationName)
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                Text(queueStatus.locationDetail)
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    // MARK: - Visit Progress Stepper

    private var visitProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(languageManager.localized("visit_progress"))
                .font(.poppins(.semiBold, size: 16))
                .foregroundColor(AppColors.darkBlue)

            VStack(spacing: 0) {
                ForEach(Array(queueStatus.steps.enumerated()), id: \.element.id) { index, step in
                    StepperRow(
                        step: step,
                        isLast: index == queueStatus.steps.count - 1,
                        accentColor: queueStatus.queueType.color,
                        languageManager: languageManager
                    )
                }
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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

    // MARK: - Floating Leave Queue Bar

    private var leaveQueueBar: some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showLeaveAlert = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text(languageManager.localized("leave_queue"))
                        .font(.poppins(.semiBold, size: 15))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.red.opacity(0.85), Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .padding(.horizontal, 20)
            }
            .padding(.top, 12)
            .padding(.bottom, 30)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Quick Stat Pill

private struct QuickStatPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(color)
                Text(label)
                    .font(.poppins(.medium, size: 11))
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.poppins(.bold, size: 16))
                .foregroundColor(AppColors.darkBlue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Stepper Row

private struct StepperRow: View {
    let step: VisitStep
    let isLast: Bool
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

    private var lineColor: Color {
        step.status == .completed ? accentColor.opacity(0.5) : Color(.systemGray4)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // ── Stepper indicator ──
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(circleColor.opacity(step.status == .pending ? 0.2 : 1.0))
                        .frame(width: 36, height: 36)

                    if step.status == .completed {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    } else if step.status == .inProgress {
                        // Pulsing ring for active step
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 28, height: 28)
                        Image(systemName: step.icon)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: step.icon)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(step.status == .skipped ? Color(.systemGray3) : Color(.systemGray2))
                    }
                }

                if !isLast {
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: 2.5, height: 40)
                }
            }

            // ── Step content ──
            VStack(alignment: .leading, spacing: 4) {
                Text(languageManager.localized(step.localizationKey))
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(step.status == .pending || step.status == .skipped ? .secondary : AppColors.darkBlue)

                HStack(spacing: 6) {
                    Text(languageManager.localized(step.status.localizationKey))
                        .font(.poppins(.medium, size: 11))
                        .foregroundColor(step.status == .inProgress ? accentColor : .secondary)

                    if let time = step.completedTime {
                        Text("·")
                            .foregroundColor(.secondary)
                        Text(time)
                            .font(.poppins(.medium, size: 11))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.top, 6)

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    QueueStatusView(queueStatus: .opdSample)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
