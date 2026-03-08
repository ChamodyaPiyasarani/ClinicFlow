import SwiftUI
import PhotosUI
import AVFoundation
import Photos

struct PharmacyView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            AppColors.background
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
                        LanguageSwitcher(fontSize: 14, showBackground: false)
                        NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color.white)
                
                // Pharmacy subtitle
                HStack {
                    Text(languageManager.localized("pharmacy_title"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                
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
                            // Action will be implemented later
                        }) {
                            Text(languageManager.localized("send_to_pharmacy"))
                                .font(.poppins(.semiBold, size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 50/255, green: 160/255, blue: 140/255))
                                .cornerRadius(14)
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
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showGallery) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
    }
}

// MARK: - Patient Info Card
private struct PatientInfoCard: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        HStack(spacing: 12) {
            // Patient Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 100/255, green: 180/255, blue: 120/255),
                                Color(red: 80/255, green: 160/255, blue: 140/255)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            // Patient details
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(AppColors.darkBlue)
                
                Text("\(languageManager.localized("patient_id_label")): CLF-1024")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
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
                // Camera icon
                ZStack {
                    Circle()
                        .fill(Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
                }
                .padding(.top, 8)
                
                // Text
                VStack(spacing: 8) {
                    Text(languageManager.localized("upload_prescription"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
                    
                    Text(languageManager.localized("jpg_png_supported"))
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.gray)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    // Choose from Gallery
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        requestPhotoLibraryPermission {
                            showGallery = true
                        }
                    }) {
                        Text(languageManager.localized("choose_from_gallery"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 50/255, green: 160/255, blue: 140/255))
                            .cornerRadius(12)
                    }
                    
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
                                .font(.system(size: 16))
                            Text(languageManager.localized("take_photo"))
                                .font(.poppins(.semiBold, size: 16))
                        }
                        .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.3), lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [8, 6])
                    )
                    .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.4))
            )
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
                    .fill(Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.15))
                    .frame(width: 24, height: 24)
                
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
            }
            .padding(.top, 2)
            
            // Info text
            VStack(alignment: .leading, spacing: 4) {
                Text(languageManager.localized("important"))
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(Color(red: 50/255, green: 160/255, blue: 140/255))
                
                Text(languageManager.localized("prescription_info"))
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

// MARK: - Permission Helper Functions
private func requestCameraPermission(completion: @escaping () -> Void) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
            if granted {
                completion()
            }
            // Even if denied, the system permission popup will have appeared
        }
    }
}

private func requestPhotoLibraryPermission(completion: @escaping () -> Void) {
    PHPhotoLibrary.requestAuthorization { status in
        DispatchQueue.main.async {
            if status == .authorized || status == .limited {
                completion()
            }
            // Even if denied, the system permission popup will have appeared
        }
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
}
