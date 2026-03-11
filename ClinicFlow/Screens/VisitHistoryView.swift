import SwiftUI

// MARK: - Main View

struct VisitHistoryView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    @State private var selectedSegment: Int = 0
    @State private var searchText: String = ""
    @State private var visits: [Visit] = Visit.samples
    @State private var appearAnimation = false

    private var filteredVisits: [Visit] {
        var result: [Visit]
        
        // Filter by segment
        switch selectedSegment {
        case 1: // Completed
            result = visits.filter { $0.status == .completed }
        case 2: // Cancelled
            result = visits.filter { $0.status == .cancelled }
        default: // All
            result = visits
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { visit in
                visit.visitType.localizedCaseInsensitiveContains(searchText) ||
                visit.doctorName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            VisitHistoryHeaderView(router: router)

            // ── Search Bar ──
            SearchBar(text: $searchText)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // ── Segment Tabs ──
            SegmentTabBar(
                selectedSegment: $selectedSegment,
                tabs: [
                    languageManager.localized("filter_all"),
                    languageManager.localized("status_completed"),
                    languageManager.localized("status_cancelled")
                ]
            )
            .padding(.horizontal, 20)

            // ── Visit List ──
            ScrollView(showsIndicators: false) {
                if filteredVisits.isEmpty {
                    EmptyVisitPlaceholder(searchText: searchText)
                        .padding(.top, 60)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(filteredVisits.enumerated()), id: \.element.id) { index, visit in
                            VisitCard(visit: visit)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.06),
                                    value: appearAnimation
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation { appearAnimation = true }
        }
        .onChange(of: selectedSegment) { _, _ in
            appearAnimation = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { appearAnimation = true }
            }
        }
        .onChange(of: searchText) { _, _ in
            appearAnimation = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { appearAnimation = true }
            }
        }
    }
}

// MARK: - Header

private struct VisitHistoryHeaderView: View {
    @Environment(LanguageManager.self) var languageManager
    let router: AppRouter

    var body: some View {
        ZStack {
            // Back button (left)
            HStack {
                BackButton {
                    router.goBack()
                }
                .padding(.leading, 20)
                Spacer()
            }

            // Centered title
            VStack(spacing: 4) {
                AppNameText(fontSize: 20)
                Text(languageManager.localized("visit_history"))
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(AppColors.darkBlue)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

// MARK: - Search Bar

private struct SearchBar: View {
    @Binding var text: String
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.gray.opacity(0.6))

            TextField("", text: $text, prompt: Text(languageManager.localized("search_placeholder"))
                .foregroundColor(.gray.opacity(0.5)))
                .font(.poppins(.regular, size: 15))
                .foregroundColor(AppColors.darkBlue)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Segment Tab Bar

private struct SegmentTabBar: View {
    @Binding var selectedSegment: Int
    let tabs: [String]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedSegment = index
                    }
                }) {
                    Text(title)
                        .font(.poppins(.semiBold, size: 14))
                        .foregroundColor(selectedSegment == index ? .white : AppColors.darkBlue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selectedSegment == index ? AppColors.brandBlue : Color.white)
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedSegment == index ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
    }
}

// MARK: - Visit Card

private struct VisitCard: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    let visit: Visit

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: visit.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Date
            Text(dateString)
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.gray.opacity(0.7))
                .padding(.bottom, 8)

            // Visit type and status
            HStack(alignment: .top) {
                Text(visit.visitType)
                    .font(.poppins(.semiBold, size: 18))
                    .foregroundColor(AppColors.darkBlue)

                Spacer()

                // Status badge
                Text(languageManager.localized(visit.status.localizationKey))
                    .font(.poppins(.semiBold, size: 12))
                    .foregroundColor(visit.status.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(visit.status.color.opacity(0.12))
                    )
            }
            .padding(.bottom, 6)

            // Doctor name with icon
            HStack(spacing: 6) {
                Image(systemName: "person.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.6))

                Text(visit.doctorName)
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 12)

            // View Details button
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                router.navigate(to: .pastAppointmentDetail(visit.toAppointment()))
            }) {
                Text(languageManager.localized("view_details"))
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.brandBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Empty Placeholder

private struct EmptyVisitPlaceholder: View {
    @Environment(LanguageManager.self) var languageManager
    let searchText: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))

            if searchText.isEmpty {
                Text(languageManager.localized("no_visits_found"))
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(.gray)
            } else {
                Text(languageManager.localized("no_search_results"))
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        VisitHistoryView()
            .environment(LanguageManager.shared)
            .environment(AppRouter.shared)
    }
}
