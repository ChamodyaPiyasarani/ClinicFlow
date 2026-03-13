import SwiftUI
import PhotosUI
import AVFoundation
import Photos

struct PharmacyView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager
    
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var selectedImage: UIImage?
    
    @State private var showJoinQueueConfirmation = false
    @State private var pendingQueueStatus: QueueStatus? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color(red: 248/255, green: 249/255, blue: 252/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    // Back button
                    HStack {
                        BackButton {
                            router.goBack()
                        }
                        Spacer()
                    }
                    
                    // Centered title
                    AppNameText(fontSize: 20)
                    
                    // Trailing icons
                    HStack(spacing: 4) {
                        Spacer()
                        NotificationIcon(unreadCount: 3, iconSize: 22)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(Color.white.opacity(0.001))
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                
                // Pharmacy subtitle
                Text(languageManager.localized("pharmacy_title"))
                    .font(.poppins(.semiBold, size: 18))
                    .foregroundColor(AppColors.darkBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                // MARK: - Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Patient Info Card
                        PatientInfoCard()
                        
                        // Upload Section
                        UploadPrescriptionSection(
                            selectedImage: $selectedImage,
                            showCamera: $showCamera,
                            showGallery: $showGallery
                        )
                        
                        // Important Info
                        ImportantInfoSection()
                        
                        // Send to Pharmacy Button
                        Button(action: {
                            // Haptic feedback
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            // Build realistic QueueStatus for Pharmacy
                            let newStatus = QueueStatus(
                                id: "Q-PHARM-\(UUID().uuidString.prefix(4))",
                                queueType: .pharmacy,
                                tokenNumber: "P-\(Int.random(in: 100...999))",
                                queuePosition: 12,
                                peopleAhead: 11,
                                estimatedWaitMinutes: 20,
                                checkInTime: formattedCurrentTime(),
                                locationName: "Pharmacy - Ground Floor",
                                locationDetail: "Building A, Ground Floor",
                                steps: [
                                    VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: formattedCurrentTime()),
                                    VisitStep(id: "s2", localizationKey: "step_pharmacy", icon: "pills.fill", status: .inProgress, completedTime: nil),
                                ],
                                isActive: true,
                                floor: .floor1,
                                area: .pharmacy
                            )
                            
                            
                            // Set as pending for confirmation
                            pendingQueueStatus = newStatus
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showJoinQueueConfirmation = true
                            }
                        }) {
                            Text(languageManager.localized("send_to_pharmacy"))
                                .font(.poppins(.semiBold, size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 70/255, green: 175/255, blue: 155/255),
                                            Color(red: 60/255, green: 165/255, blue: 145/255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .padding(.top, 20)
                }
            }
            
            // Bottom Navigation Bar
            BottomNavBar()
        }
        .overlay {
            if showJoinQueueConfirmation, let queueStatus = pendingQueueStatus {
                GlassyConfirmationPopup(
                    isPresented: $showJoinQueueConfirmation,
                    icon: "pills.fill",
                    iconColors: [Color(red: 70/255, green: 175/255, blue: 155/255), Color(red: 60/255, green: 165/255, blue: 145/255)],
                    titleKey: "join_queue_title",
                    messageKey: "join_queue_confirmation",
                    confirmLabelKey: "join_now",
                    onConfirm: {
                        toastManager.show(.success, message: "toast_prescription_sent")
                        router.currentQueueStatus = queueStatus
                        router.selectedTab = .home
                        router.goBack() 
                    }
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
                .environment(languageManager)
                .environment(router)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
                .environment(languageManager)
                .environment(router)
        }
    }

    private func formattedCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

// MARK: - Patient Info Card
private struct PatientInfoCard: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        HStack(spacing: 14) {
            // Patient Avatar
            ProfessionalAvatarView(
                size: 60,
                gradientColors: [
                    Color(red: 200/255, green: 220/255, blue: 160/255),
                    Color(red: 160/255, green: 180/255, blue: 120/255)
                ]
            )
            
            // Patient details
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.poppins(.semiBold, size: 18))
                    .foregroundColor(Color(red: 35/255, green: 60/255, blue: 95/255))
                
                Text("\(languageManager.localized("patient_id_label")): CLF-1024")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(Color(red: 130/255, green: 145/255, blue: 160/255))
            }
            
            Spacer()
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
}

// MARK: - Upload Prescription Section
private struct UploadPrescriptionSection: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @Binding var showGallery: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Dashed border container
            VStack(spacing: 20) {
                if let image = selectedImage {
                    // Image Preview with Success Indicator
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()
                        
                        // Action Buttons Overlay
                        HStack(spacing: 10) {
                            // Remove Button
                            Button(action: {
                                withAnimation {
                                    selectedImage = nil
                                }
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            
                            // Success Indicator
                            ZStack {
                                Circle()
                                    .fill(Color(red: 70/255, green: 175/255, blue: 155/255))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .shadow(radius: 4)
                        }
                        .padding(10)
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    // Upload UI
                    VStack(spacing: 20) {
                        // Camera icon
                        ZStack {
                            Circle()
                                .fill(Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.18))
                                .frame(width: 72, height: 72)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255))
                        }
                        .padding(.top, 12)
                        
                        // Text
                        VStack(spacing: 8) {
                            Text(languageManager.localized("upload_prescription"))
                                .font(.poppins(.semiBold, size: 17))
                                .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255))
                            
                            Text(languageManager.localized("jpg_png_supported"))
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(Color(red: 150/255, green: 160/255, blue: 170/255))
                        }
                    }
                }
                
                // Buttons
                VStack(spacing: 13) {
                    // Choose from Gallery
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        requestPhotoLibraryPermission {
                            showGallery = true
                        }
                    }) {
                        Text(selectedImage == nil ? languageManager.localized("choose_from_gallery") : "Change Photo")
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 70/255, green: 175/255, blue: 155/255),
                                        Color(red: 60/255, green: 165/255, blue: 145/255)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                            .shadow(color: Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                    
                    if selectedImage == nil {
                        // Take Photo
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            requestCameraPermission {
                                showCamera = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 17))
                                Text(languageManager.localized("take_photo"))
                                    .font(.poppins(.semiBold, size: 16))
                            }
                            .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.25), lineWidth: 1.5)
                            )
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 12)
            }
            .padding(.vertical, selectedImage == nil ? 28 : 12)
            .padding(.horizontal, selectedImage == nil ? 0 : 12)
            .background(Color(red: 252/255, green: 253/255, blue: 254/255))
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2.5, dash: selectedImage == nil ? [10, 6] : [])
                    )
                    .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.35))
            )
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Important Info Section
private struct ImportantInfoSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Info icon
            ZStack {
                Circle()
                    .fill(Color(red: 70/255, green: 175/255, blue: 155/255).opacity(0.18))
                    .frame(width: 28, height: 28)
                
                Text("i")
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255))
            }
            .padding(.top, 1)
            
            // Info text
            VStack(alignment: .leading, spacing: 5) {
                Text(languageManager.localized("important"))
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundColor(Color(red: 70/255, green: 175/255, blue: 155/255))
                
                Text(languageManager.localized("prescription_info"))
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(Color(red: 135/255, green: 150/255, blue: 165/255))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(18)
        .background(Color(red: 245/255, green: 252/255, blue: 250/255))
        .cornerRadius(14)
        .padding(.horizontal, 20)
    }
}

// MARK: - Permission Helper Functions
private func requestCameraPermission(completion: @escaping () -> Void) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch status {
    case .authorized:
        // Already authorized, proceed
        completion()
    case .notDetermined:
        // Request permission - this will show the iOS permission popup
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    completion()
                }
            }
        }
    case .denied, .restricted:
        // Permission was denied - the user needs to enable it in Settings
        // The app can show an alert here if needed
        break
    @unknown default:
        break
    }
}

private func requestPhotoLibraryPermission(completion: @escaping () -> Void) {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch status {
    case .authorized, .limited:
        // Already authorized, proceed
        completion()
    case .notDetermined:
        // Request permission - this will show the iOS permission popup
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                if newStatus == .authorized || newStatus == .limited {
                    completion()
                }
            }
        }
    case .denied, .restricted:
        // Permission was denied - the user needs to enable it in Settings
        // The app can show an alert here if needed
        break
    @unknown default:
        break
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PharmacyView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
        .environment(ToastManager.shared)
}
