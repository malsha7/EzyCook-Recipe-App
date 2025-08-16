//
//  ImagePicker.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-16.
//

import SwiftUI

struct ImagePicker: View {
    
    @Binding var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    // customized options
    var imageSize: CGFloat = 80
    var cornerRadius: CGFloat? = nil // nil for circle - value for rounded rectangle
    var placeholderIcon: String = "photo"
    var showCameraIcon: Bool = true
    var cameraIconSize: CGFloat = 24
    
    
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                showImagePicker = true
            }) {
                ZStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(
                                cornerRadius != nil ?
                                AnyShape(RoundedRectangle(cornerRadius: cornerRadius!)) :
                                AnyShape(Circle())
                            )
                    } else {
                        Group {
                            if cornerRadius != nil {
                                RoundedRectangle(cornerRadius: cornerRadius!)
                                    .fill(Color.appBlue.opacity(0.1))
                                    .frame(width: imageSize, height: imageSize)
                                    .overlay(
                                        Image(systemName: placeholderIcon)
                                            .foregroundColor(.appBlue.opacity(0.6))
                                            .font(.system(size: imageSize * 0.375))
                                    )
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: imageSize, height: imageSize)
                                    .overlay(
                                        Image(systemName: placeholderIcon)
                                            .foregroundColor(.appBlue.opacity(0.6))
                                            .font(.system(size: imageSize * 0.375))
                                    )
                            }
                        }
                    }
                    
                    // camera icon overlay
                    if showCameraIcon {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: cameraIconSize, height: cameraIconSize)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.appWhite)
                                    .font(.system(size: cameraIconSize * 0.5))
                            )
                            .offset(x: imageSize * 0.31, y: imageSize * 0.31)
                    }
                }
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showImagePicker) {
            ImagePickerController(image: $selectedImage)
        }
    }
}

// ImagePickerController helper
struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerController
        
        init(_ parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// helper for anyshape
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}
