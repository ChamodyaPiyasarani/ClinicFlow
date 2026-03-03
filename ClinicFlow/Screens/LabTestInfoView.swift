//
//  LabTestInfoView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

struct LabTestInfoView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @Binding var isPresented: Bool
    var onProceed: () -> Void
    
    var body: some View {
        ZStack {
            // Blur Background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    // Back button
                    HStack {
                        BackButton {
                            dismissModal()
                        }
                        Spacer()
                    }
                    
                    // Centered title
                    VStack(spacing: 2) {
                        Text("CLINICFLOW")
                            .font(.poppins(.bold, size: 20))
                            .foregroundColor(AppColors.darkBlue)
                        Text("LAB Test")
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(AppColors.darkBlue.opacity(0.7))
                    }
                    
                    // Notification bell
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.darkBlue)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 9, height: 9)
                                .offset(x: 2, y: -2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color.white)
                
                // MARK: - Content Area
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Spacer
                        Color.clear.frame(height: 8)
                        
                        // Instructions Card
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text("Instructions !")
                                .font(.poppins(.semiBold, size: 18))
                                .foregroundColor(AppColors.darkBlue)
                                .padding(.bottom, 4)
                            
                            // Instructions List
                            VStack(alignment: .leading, spacing: 14) {
                                InstructionItem(
                                    icon: "fork.knife",
                                    title: "Fasting may be required",
                                    description: "Do not eat or drink (except water) for 8-12 hours if instructed."
                                )
                                
                                InstructionItem(
                                    icon: "pills.fill",
                                    title: "Take medicines only if advised",
                                    description: "Continue or stop medications only as directed by your doctor."
                                )
                                
                                InstructionItem(
                                    icon: "drop.fill",
                                    title: "Drink water",
                                    description: "Stay well hydrated unless told otherwise."
                                )
                                
                                InstructionItem(
                                    icon: "smoke.fill",
                                    title: "Avoid alcohol and smoking",
                                    description: "Do not consume alcohol or smoke at least 24 hours before the test."
                                )
                                
                                InstructionItem(
                                    icon: "clock.fill",
                                    title: "Arrive on time",
                                    description: "Reach the lab 10-15 minutes early."
                                )
                                
                                InstructionItem(
                                    icon: "doc.text.fill",
                                    title: "Carry required documents",
                                    description: "Bring your test request form and identification."
                                )
                                
                                InstructionItem(
                                    icon: "person.fill.questionmark",
                                    title: "Inform the lab staff",
                                    description: "Tell staff if you are pregnant, diabetic, or have allergies."
                                )
                                
                                InstructionItem(
                                    icon: "figure.run",
                                    title: "Avoid heavy exercise",
                                    description: "Do not do strenuous activity before the test."
                                )
                            }
                            
                            // Bottom message
                            Text("Please follow these instructions for accurate test results.")
                                .font(.poppins(.medium, size: 14))
                                .foregroundColor(AppColors.brandBlue)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                                .padding(.bottom, 4)
                        }
                        .padding(20)
                        .background(
                            Color(red: 220/255, green: 240/255, blue: 245/255)
                        )
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        
                        // OK Button
                        Button(action: {
                            // Haptic feedback
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                            
                            // Small delay before proceeding
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onProceed()
                            }
                        }) {
                            Text("OK")
                                .font(.poppins(.semiBold, size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 70/255, green: 140/255, blue: 160/255),
                                            Color(red: 60/255, green: 120/255, blue: 140/255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(14)
                                .shadow(color: Color(red: 70/255, green: 140/255, blue: 160/255).opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Bottom spacer
                        Color.clear.frame(height: 16)
                    }
                    .padding(.vertical, 8)
                }
                .background(AppColors.background)
            }
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 8)
            .padding(.vertical, 40)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    private func dismissModal() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - Instruction Item Component
struct InstructionItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.brandBlue)
                .frame(width: 24)
                .padding(.top, 2)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                
                Text(description)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(Color.gray.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    @Previewable @State var isPresented = true
    
    ZStack {
        // Background content (simulating previous screen)
        AppColors.background.ignoresSafeArea()
        
        if isPresented {
            LabTestInfoView(isPresented: $isPresented) {
                print("Proceeding to Lab Tests")
            }
            .environment(languageManager)
            .environment(router)
        }
    }
}
