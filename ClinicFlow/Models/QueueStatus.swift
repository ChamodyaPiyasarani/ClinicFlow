import SwiftUI

// MARK: - Queue Type

/// The type of queue a user can join.
enum QueueType: String, Hashable, CaseIterable {
    case opd
    case lab
    case labReport
    case appointment
    case pharmacy

    var localizationKey: String {
        switch self {
        case .opd:         return "queue_type_opd"
        case .lab:         return "queue_type_lab"
        case .labReport:   return "queue_type_lab_report"
        case .appointment: return "queue_type_appointment"
        case .pharmacy:    return "queue_type_pharmacy"
        }
    }

    var icon: String {
        switch self {
        case .opd:         return "plus.circle.fill"
        case .lab:         return "flask.fill"
        case .labReport:   return "doc.text.fill"
        case .appointment: return "calendar"
        case .pharmacy:    return "pills.fill"
        }
    }

    var color: Color {
        switch self {
        case .opd:         return AppColors.opdBlue
        case .lab:         return AppColors.labGreen
        case .labReport:   return Color(red: 160/255, green: 130/255, blue: 200/255)
        case .appointment: return AppColors.brandBlue
        case .pharmacy:    return AppColors.pharmacyGreen
        }
    }
}

// MARK: - Visit Step

/// A single step in the visit journey.
struct VisitStep: Identifiable, Hashable {
    let id: String
    let localizationKey: String
    let icon: String
    var status: VisitStepStatus
    var completedTime: String?
}

enum VisitStepStatus: String, Hashable {
    case completed
    case inProgress
    case pending
    case skipped

    var localizationKey: String {
        switch self {
        case .completed:  return "step_completed"
        case .inProgress: return "step_in_progress"
        case .pending:    return "step_pending"
        case .skipped:    return "step_skipped"
        }
    }
}

// MARK: - Queue Status

/// Represents the current queue status for a user.
struct QueueStatus: Identifiable, Hashable {
    let id: String
    let queueType: QueueType
    let tokenNumber: String
    let queuePosition: Int
    let peopleAhead: Int
    let estimatedWaitMinutes: Int
    let checkInTime: String
    let locationName: String
    let locationDetail: String
    var steps: [VisitStep]
    var isActive: Bool
}

// MARK: - Sample Data

extension QueueStatus {
    /// OPD Queue sample: Registration → Consultation → Lab → Pharmacy
    static let opdSample = QueueStatus(
        id: "Q-001",
        queueType: .opd,
        tokenNumber: "#A-2084",
        queuePosition: 8,
        peopleAhead: 7,
        estimatedWaitMinutes: 42,
        checkInTime: "10:45 AM",
        locationName: "Room - 1st floor (Room No. A01)",
        locationDetail: "Building A, 1st Floor",
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "9:15 AM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .inProgress, completedTime: nil),
            VisitStep(id: "s3", localizationKey: "step_lab_tests", icon: "flask.fill", status: .pending, completedTime: nil),
            VisitStep(id: "s4", localizationKey: "step_pharmacy", icon: "pills.fill", status: .pending, completedTime: nil),
        ],
        isActive: true
    )

    /// Lab Queue sample: Registration → Lab Test → Report Collection
    static let labSample = QueueStatus(
        id: "Q-002",
        queueType: .lab,
        tokenNumber: "#L-1042",
        queuePosition: 3,
        peopleAhead: 2,
        estimatedWaitMinutes: 15,
        checkInTime: "11:00 AM",
        locationName: "Lab - 2nd floor (Room No. B05)",
        locationDetail: "Building B, 2nd Floor",
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "10:30 AM"),
            VisitStep(id: "s2", localizationKey: "step_lab_tests", icon: "flask.fill", status: .inProgress, completedTime: nil),
            VisitStep(id: "s3", localizationKey: "step_report_collection", icon: "doc.text.fill", status: .pending, completedTime: nil),
        ],
        isActive: true
    )

    /// Appointment Queue sample: Registration → Consultation
    static let appointmentSample = QueueStatus(
        id: "Q-003",
        queueType: .appointment,
        tokenNumber: "#A-2847",
        queuePosition: 5,
        peopleAhead: 4,
        estimatedWaitMinutes: 25,
        checkInTime: "2:00 PM",
        locationName: "Room - 1st floor (Room No. A01)",
        locationDetail: "Building A, 1st Floor",
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "1:45 PM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .inProgress, completedTime: nil),
        ],
        isActive: true
    )

    /// Pharmacy Queue sample: Registration → Pharmacy
    static let pharmacySample = QueueStatus(
        id: "Q-004",
        queueType: .pharmacy,
        tokenNumber: "#P-0312",
        queuePosition: 12,
        peopleAhead: 11,
        estimatedWaitMinutes: 20,
        checkInTime: "3:15 PM",
        locationName: "Pharmacy - Ground floor",
        locationDetail: "Building A, Ground Floor",
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "3:00 PM"),
            VisitStep(id: "s2", localizationKey: "step_pharmacy", icon: "pills.fill", status: .inProgress, completedTime: nil),
        ],
        isActive: true
    )

    static let samples: [QueueStatus] = [opdSample, labSample, appointmentSample, pharmacySample]
}
