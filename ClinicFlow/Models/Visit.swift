import SwiftUI

// MARK: - Visit Status

enum VisitStatus: String, Hashable {
    case completed
    case cancelled

    var localizationKey: String {
        switch self {
        case .completed: return "status_completed"
        case .cancelled: return "status_cancelled"
        }
    }

    var color: Color {
        switch self {
        case .completed: return Color(red: 80/255, green: 180/255, blue: 100/255)
        case .cancelled: return Color.red
        }
    }
}

// MARK: - Visit

/// A single visit history record.
struct Visit: Identifiable, Hashable {
    let id: String
    let visitType: String // e.g., "Laboratory", "General OPD", "Cardiology"
    let visitTypeKey: String // For localization
    let doctorName: String
    let date: Date
    let status: VisitStatus
}

// MARK: - Sample Data

extension Visit {
    static let samples: [Visit] = [
        Visit(
            id: "v1",
            visitType: "Laboratory",
            visitTypeKey: "visit_laboratory",
            doctorName: "Dr. Michael Chen",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))!,
            status: .completed
        ),
        Visit(
            id: "v2",
            visitType: "General OPD",
            visitTypeKey: "dept_general_medicine",
            doctorName: "Dr. Emily Roberts",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 10))!,
            status: .completed
        ),
        Visit(
            id: "v3",
            visitType: "Cardiology",
            visitTypeKey: "dept_cardiology",
            doctorName: "Dr. James Wilson",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))!,
            status: .cancelled
        ),
        Visit(
            id: "v4",
            visitType: "Pediatrics",
            visitTypeKey: "dept_pediatrics",
            doctorName: "Dr. Sarah Martinez",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 28))!,
            status: .completed
        ),
        Visit(
            id: "v5",
            visitType: "Dermatology",
            visitTypeKey: "dept_dermatology",
            doctorName: "Dr. Ahmed Hassan",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 20))!,
            status: .completed
        ),
        Visit(
            id: "v6",
            visitType: "Orthopedics",
            visitTypeKey: "dept_orthopedics",
            doctorName: "Dr. Lisa Chang",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 15))!,
            status: .cancelled
        ),
    ]
}
