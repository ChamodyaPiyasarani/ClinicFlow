import SwiftUI

/// Represents a medical record entry
struct MedicalRecord: Identifiable, Hashable {
    let id: String
    let title: String
    let date: String
    let provider: String
    let type: String
}

/// Represents a patient profile in the app.
struct PatientProfile: Identifiable, Hashable {
    let id: String
    let name: String
    let nickname: String?
    let relationship: String
    let avatarColor: Color
    let hairColor: Color
    let shirtColor: Color
    let isActive: Bool
    let allergiesCount: Int?
    
    // Detailed profile information
    let dateOfBirth: String
    let gender: String
    let bloodType: String
    let phone: String
    let email: String
    let allergies: [String]
    let medicalHistory: [MedicalRecord]
    
    /// Hardcoded sample profiles
    static let sampleProfiles: [PatientProfile] = [
        PatientProfile(
            id: "CF-2024-002",
            name: "Sarah Johnson",
            nickname: "Mother",
            relationship: "Family Member",
            avatarColor: Color(red: 200/255, green: 220/255, blue: 200/255),
            hairColor: Color(red: 160/255, green: 120/255, blue: 80/255),
            shirtColor: Color(red: 180/255, green: 140/255, blue: 180/255),
            isActive: false,
            allergiesCount: 2,
            dateOfBirth: "March 15, 1985",
            gender: "Female",
            bloodType: "O+",
            phone: "+94 70 234 5678",
            email: "sarah@gmail.com",
            allergies: ["Penicillin", "Shellfish"],
            medicalHistory: [
                MedicalRecord(
                    id: "1",
                    title: "Check Up",
                    date: "Jan 16, 2026",
                    provider: "Dr. Michael Chan - General Medicine",
                    type: "checkup"
                ),
                MedicalRecord(
                    id: "2",
                    title: "Blood Test",
                    date: "Dec 10, 2025",
                    provider: "Laboratory - Routine Screening",
                    type: "lab"
                ),
                MedicalRecord(
                    id: "3",
                    title: "Vaccination",
                    date: "Nov 20, 2025",
                    provider: "Dr. Lisa Park - Flu Shot",
                    type: "vaccination"
                )
            ]
        ),
        PatientProfile(
            id: "CF-2024-001",
            name: "John Doe",
            nickname: nil,
            relationship: "Primary Account",
            avatarColor: Color(red: 200/255, green: 220/255, blue: 160/255),
            hairColor: Color(red: 139/255, green: 90/255, blue: 43/255),
            shirtColor: Color(red: 70/255, green: 130/255, blue: 220/255),
            isActive: true,
            allergiesCount: nil,
            dateOfBirth: "June 22, 1990",
            gender: "Male",
            bloodType: "A+",
            phone: "+94 71 234 5678",
            email: "john.doe@example.com",
            allergies: [],
            medicalHistory: []
        ),
        PatientProfile(
            id: "CF-2024-003",
            name: "Emma Johnson",
            nickname: "Daughter",
            relationship: "Daughter",
            avatarColor: Color(red: 180/255, green: 200/255, blue: 210/255),
            hairColor: Color(red: 200/255, green: 150/255, blue: 90/255),
            shirtColor: Color(red: 100/255, green: 180/255, blue: 140/255),
            isActive: false,
            allergiesCount: nil,
            dateOfBirth: "April 10, 2015",
            gender: "Female",
            bloodType: "B+",
            phone: "+94 71 234 5678",
            email: "parent@example.com",
            allergies: [],
            medicalHistory: []
        )
    ]
}
