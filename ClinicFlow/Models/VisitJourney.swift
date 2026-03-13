import SwiftUI

// MARK: - Visit Journey

/// Represents the full visit journey after consultation is completed.
/// Dynamically adapts steps based on the patient's chosen path.
struct VisitJourney: Identifiable, Hashable {
    let id: String
    let doctorName: String
    let department: String
    let departmentKey: String
    let date: Date
    let timeSlot: String
    let tokenNumber: String
    let completedStepKey: String          // e.g. "step_consultation"
    let nextAction: NextVisitAction?      // nil if journey is complete
    var steps: [VisitStep]
}

// MARK: - Next Visit Action

/// Describes the next action in the patient's journey.
struct NextVisitAction: Hashable {
    let titleKey: String          // e.g. "next_action_lab_test"
    let descriptionKey: String    // e.g. "next_action_lab_desc"
    let detailLines: [ActionDetail]
    let actionButtonKey: String   // e.g. "join_queue"
    let queueStatus: QueueStatus  // The queue to join
}

/// A single detail line in the next-action card (label + value).
struct ActionDetail: Hashable {
    let icon: String
    let labelKey: String
    let value: String
    let valueColor: Color?

    init(icon: String, labelKey: String, value: String, valueColor: Color? = nil) {
        self.icon = icon
        self.labelKey = labelKey
        self.value = value
        self.valueColor = valueColor
    }
}

// MARK: - Sample Data

extension VisitJourney {

    /// After consultation → Lab test required
    static let consultationToLab = VisitJourney(
        id: "VJ-001",
        doctorName: "Dr. Sarah Johnson",
        department: "Cardiology",
        departmentKey: "dept_cardiology",
        date: Date(),
        timeSlot: "4:30 PM",
        tokenNumber: "A-2847",
        completedStepKey: "step_consultation",
        nextAction: NextVisitAction(
            titleKey: "next_action_lab_test",
            descriptionKey: "next_action_lab_desc",
            detailLines: [
                ActionDetail(icon: "flask.fill", labelKey: "next_detail_test_category", value: "Full Blood Count (FBC)"),
                ActionDetail(icon: "building.2.fill", labelKey: "next_detail_lab_location", value: "2nd floor (Lab No.2)"),
                ActionDetail(icon: "exclamationmark.triangle.fill", labelKey: "next_detail_priority", value: "Urgent", valueColor: Color(red: 230/255, green: 80/255, blue: 60/255)),
            ],
            actionButtonKey: "join_queue",
            queueStatus: .labFromConsultation
        ),
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "9:15 AM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .completed, completedTime: "9:45 AM"),
            VisitStep(id: "s3", localizationKey: "step_lab_tests", icon: "flask.fill", status: .inProgress, completedTime: nil),
            VisitStep(id: "s4", localizationKey: "step_pharmacy", icon: "pills.fill", status: .pending, completedTime: nil),
        ]
    )

    /// After consultation → Pharmacy (no lab needed)
    static let consultationToPharmacy = VisitJourney(
        id: "VJ-002",
        doctorName: "Dr. Priya Sharma",
        department: "Dermatology",
        departmentKey: "dept_dermatology",
        date: Date(),
        timeSlot: "11:00 AM",
        tokenNumber: "A-2830",
        completedStepKey: "step_consultation",
        nextAction: NextVisitAction(
            titleKey: "next_action_pharmacy",
            descriptionKey: "next_action_pharmacy_desc",
            detailLines: [
                ActionDetail(icon: "pills.fill", labelKey: "next_detail_prescription", value: "3 medications prescribed"),
                ActionDetail(icon: "building.2.fill", labelKey: "next_detail_pharmacy_location", value: "Ground Floor, Counter 2"),
            ],
            actionButtonKey: "join_queue",
            queueStatus: .pharmacySample
        ),
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "10:15 AM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .completed, completedTime: "10:50 AM"),
            VisitStep(id: "s3", localizationKey: "step_lab_tests", icon: "flask.fill", status: .skipped, completedTime: nil),
            VisitStep(id: "s4", localizationKey: "step_pharmacy", icon: "pills.fill", status: .inProgress, completedTime: nil),
        ]
    )

    /// After consultation → Visit complete (no further steps)
    static let consultationComplete = VisitJourney(
        id: "VJ-003",
        doctorName: "Dr. Michael Chen",
        department: "Orthopedics",
        departmentKey: "dept_orthopedics",
        date: Date(),
        timeSlot: "02:30 PM",
        tokenNumber: "A-2848",
        completedStepKey: "step_consultation",
        nextAction: nil,
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "2:00 PM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .completed, completedTime: "2:25 PM"),
        ]
    )

    static let samples: [VisitJourney] = [consultationToLab, consultationToPharmacy, consultationComplete]
}

// MARK: - Lab-from-Consultation Queue Sample

extension QueueStatus {
    static let labFromConsultation = QueueStatus(
        id: "Q-005",
        queueType: .lab,
        tokenNumber: "L-1098",
        queuePosition: 4,
        peopleAhead: 3,
        estimatedWaitMinutes: 18,
        checkInTime: "9:50 AM",
        locationName: "Lab - 2nd floor (Lab No.2)",
        locationDetail: "Building B, 2nd Floor",
        steps: [
            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "9:15 AM"),
            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .completed, completedTime: "9:45 AM"),
            VisitStep(id: "s3", localizationKey: "step_lab_tests", icon: "flask.fill", status: .inProgress, completedTime: nil),
            VisitStep(id: "s4", localizationKey: "step_pharmacy", icon: "pills.fill", status: .pending, completedTime: nil),
        ],
        isActive: true
    )
}
