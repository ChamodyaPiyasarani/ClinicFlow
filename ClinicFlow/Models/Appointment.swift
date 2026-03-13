import SwiftUI

// MARK: - Department

/// Clinic department for appointment booking.
struct ClinicDepartment: Identifiable, Hashable {
    let id: String
    let name: String
    let localizationKey: String
    let icon: String
    let color: Color
}

// MARK: - Doctor

/// Doctor available for appointments.
struct Doctor: Identifiable, Hashable {
    let id: String
    let name: String
    let specialization: String
    let specializationKey: String
    let department: String
    let consultationFee: Int
    let availableDays: [Int] // 1=Sun ... 7=Sat
}

// MARK: - Time Slot

/// A bookable time slot.
struct TimeSlot: Identifiable, Hashable {
    let id: String
    let time: String        // e.g. "10:30 AM"
    let hour: Int
    let minute: Int
    var isAvailable: Bool
}

// MARK: - Appointment Status

enum AppointmentStatus: String, Hashable {
    case confirmed
    case pending
    case completed
    case cancelled

    var localizationKey: String {
        switch self {
        case .confirmed:  return "status_confirmed"
        case .pending:    return "status_pending"
        case .completed:  return "status_completed"
        case .cancelled:  return "status_cancelled"
        }
    }

    var color: Color {
        switch self {
        case .confirmed:  return Color(red: 80/255, green: 180/255, blue: 100/255)
        case .pending:    return Color(red: 235/255, green: 180/255, blue: 60/255)
        case .completed:  return Color(red: 120/255, green: 140/255, blue: 160/255)
        case .cancelled:  return Color.red
        }
    }
}

// MARK: - Appointment

/// A single appointment record.
struct Appointment: Identifiable, Hashable {
    let id: String
    let doctorName: String
    let department: String
    let departmentKey: String
    let specialization: String
    let date: Date
    let timeSlot: String
    let status: AppointmentStatus
    let consultationFee: Int
    let tokenNumber: String
    let patientName: String
    let contactNumber: String
    let reasonForVisit: String
}

// MARK: - Sample Data

extension ClinicDepartment {
    static let samples: [ClinicDepartment] = [
        ClinicDepartment(id: "d1", name: "Cardiology", localizationKey: "dept_cardiology", icon: "heart.fill", color: Color(red: 220/255, green: 80/255, blue: 80/255)),
        ClinicDepartment(id: "d2", name: "Orthopedics", localizationKey: "dept_orthopedics", icon: "figure.walk", color: Color(red: 90/255, green: 160/255, blue: 220/255)),
        ClinicDepartment(id: "d3", name: "Dermatology", localizationKey: "dept_dermatology", icon: "hand.raised.fill", color: Color(red: 180/255, green: 130/255, blue: 200/255)),
        ClinicDepartment(id: "d4", name: "Pediatrics", localizationKey: "dept_pediatrics", icon: "figure.and.child.holdinghands", color: Color(red: 100/255, green: 190/255, blue: 150/255)),
        ClinicDepartment(id: "d5", name: "Neurology", localizationKey: "dept_neurology", icon: "brain.head.profile", color: Color(red: 150/255, green: 120/255, blue: 200/255)),
        ClinicDepartment(id: "d6", name: "General Medicine", localizationKey: "dept_general_medicine", icon: "stethoscope", color: AppColors.brandBlue),
    ]
}

extension Doctor {
    static let samples: [Doctor] = [
        Doctor(id: "doc1", name: "Dr. Sarah Johnson", specialization: "Cardiology", specializationKey: "dept_cardiology", department: "d1", consultationFee: 3200, availableDays: [2, 3, 4, 5, 6]),
        Doctor(id: "doc2", name: "Dr. Michael Chen", specialization: "Orthopedics", specializationKey: "dept_orthopedics", department: "d2", consultationFee: 2800, availableDays: [2, 4, 6]),
        Doctor(id: "doc3", name: "Dr. Priya Sharma", specialization: "Dermatology", specializationKey: "dept_dermatology", department: "d3", consultationFee: 2500, availableDays: [2, 3, 5, 6]),
        Doctor(id: "doc4", name: "Dr. Amanda Lee", specialization: "Pediatrics", specializationKey: "dept_pediatrics", department: "d4", consultationFee: 2200, availableDays: [2, 3, 4, 5]),
        Doctor(id: "doc5", name: "Dr. David Park", specialization: "Neurology", specializationKey: "dept_neurology", department: "d5", consultationFee: 3500, availableDays: [3, 4, 5]),
        Doctor(id: "doc6", name: "Dr. Nimal Perera", specialization: "General Medicine", specializationKey: "dept_general_medicine", department: "d6", consultationFee: 1800, availableDays: [2, 3, 4, 5, 6, 7]),
    ]
}

extension TimeSlot {
    static func generateSlots() -> [TimeSlot] {
        let times = [
            ("09:00 AM", 9, 0), ("09:30 AM", 9, 30),
            ("10:00 AM", 10, 0), ("10:30 AM", 10, 30),
            ("11:00 AM", 11, 0), ("11:30 AM", 11, 30),
            ("02:00 PM", 14, 0), ("02:30 PM", 14, 30),
            ("03:00 PM", 15, 0), ("03:30 PM", 15, 30),
            ("04:00 PM", 16, 0), ("04:30 PM", 16, 30),
        ]
        return times.enumerated().map { idx, t in
            TimeSlot(id: "ts\(idx)", time: t.0, hour: t.1, minute: t.2, isAvailable: Bool.random() || idx < 4)
        }
    }
}

extension Appointment {
    static let samples: [Appointment] = {
        let cal = Calendar.current
        let today = Date()
        return [
            Appointment(
                id: "A-2847",
                doctorName: "Dr. Sarah Johnson",
                department: "Cardiology",
                departmentKey: "dept_cardiology",
                specialization: "Cardiology",
                date: cal.date(byAdding: .hour, value: 3, to: today) ?? today,
                timeSlot: "02:30 PM",
                status: .confirmed,
                consultationFee: 3200,
                tokenNumber: "A-2847",
                patientName: "John Doe",
                contactNumber: "+94 71 234 5678",
                reasonForVisit: "Routine checkup"
            ),
            Appointment(
                id: "A-2848",
                doctorName: "Dr. Michael Chen",
                department: "Orthopedics",
                departmentKey: "dept_orthopedics",
                specialization: "Orthopedics",
                date: cal.date(byAdding: .day, value: 1, to: today) ?? today,
                timeSlot: "10:00 AM",
                status: .pending,
                consultationFee: 2800,
                tokenNumber: "A-2848",
                patientName: "John Doe",
                contactNumber: "+94 71 234 5678",
                reasonForVisit: "Knee pain follow-up"
            ),
            Appointment(
                id: "A-2830",
                doctorName: "Dr. Priya Sharma",
                department: "Dermatology",
                departmentKey: "dept_dermatology",
                specialization: "Dermatology",
                date: cal.date(byAdding: .day, value: -5, to: today) ?? today,
                timeSlot: "11:00 AM",
                status: .completed,
                consultationFee: 2500,
                tokenNumber: "A-2830",
                patientName: "John Doe",
                contactNumber: "+94 71 234 5678",
                reasonForVisit: "Skin rash consultation"
            ),
        ]
    }()
}
