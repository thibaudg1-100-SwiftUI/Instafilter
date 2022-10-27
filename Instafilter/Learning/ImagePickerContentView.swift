//
//  ImagePickerContentView.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI

struct ImagePickerContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
            // the 'onChange' modifier cannot be attached here or it won't be triggered
        }
        .onChange(of: inputImage) { _ in loadImage() }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        // if you just need to write an image in the device photo library:
//        UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil) // but it might not work if the user didn't accept the writing permission, and you won't know be notified if the saving action succeeded or failed, so will result in poor UX most likely
        
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
}

struct ImagePickerContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerContentView()
            .previewDevice("iPhone 13")
    }
}
