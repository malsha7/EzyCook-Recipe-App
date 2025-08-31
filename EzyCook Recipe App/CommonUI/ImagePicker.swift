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
                print("ImagePicker: Button tapped, showing image picker")
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
            
            if selectedImage != nil {
                Text("Image selected: \(Int(selectedImage!.size.width))x\(Int(selectedImage!.size.height))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showImagePicker) {
            print(" ImagePicker: Sheet dismissed")
            
            if selectedImage != nil {
                print("ImagePicker: Image was selected during picker session")
            } else {
                print("ImagePicker: No image was selected or selection failed")
            }
        } content: {
            ImagePickerController(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                print("ImagePicker: selectedImage changed - New size: \(image.size)")
            } else {
                print("ImagePicker: selectedImage changed - Image cleared")
            }
        }
    }
}

// ImagePickerController helper
struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        print(" ImagePickerController: Creating UIImagePickerController")
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
       
    }
    
    func makeCoordinator() -> Coordinator {
        print("ImagePickerController: Creating coordinator")
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerController
        
        init(_ parent: ImagePickerController) {
            self.parent = parent
            super.init()
            print(" Coordinator: Initialized")
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print(" Coordinator: Image picker finished with info:")
            print("  Available keys: \(info.keys)")
            
            if let originalImage = info[.originalImage] as? UIImage {
                print(" Coordinator: Found original image - Size: \(originalImage.size)")
                parent.image = originalImage
                print(" Coordinator: Set parent.image to selected image")
            } else {
                print(" Coordinator: No original image found in info")
            }
            
           
            if let editedImage = info[.editedImage] as? UIImage {
                print(" Coordinator: Found edited image - Size: \(editedImage.size)")
                parent.image = editedImage
            }
            
            print("Coordinator: Dismissing picker...")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print(" Coordinator: Image picker was cancelled")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
      
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            print(" Coordinator: Legacy delegate method called")
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
