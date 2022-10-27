//
//  ImagePicker.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI
import PhotosUI

struct ImagePicker_Previews: PreviewProvider {
    // PreviewProvider conformnace requires the following static property
    // and allows us to display a Preview in the Canvas for a View written in Swift!!
    static var previews: some View {
        // let's mimick the way this UIViewController will appear in the parent SwiftUI View:
        VStack {
            
        }
        .sheet(isPresented: .constant(true)) {
            ImagePicker(image: .constant(nil))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    // What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it. This means we can set the binding value in our image picker and have it actually update a value being stored somewhere else – in ContentView, for example.
    @Binding var image: UIImage?
    
    // a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view
    // SwiftUI’s coordinators are designed to act as delegates for UIKit view controllers
    // “delegates” are objects that respond to events that occur elsewhere.
    // it must a class, because it has to inherit from 'NSObject' class
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        // func required for PHPickerViewControllerDelegate protocol conformance:
        // That method receives two objects we care about: the picker view controller that the user was interacting with, plus an array of the users selections because it’s possible to let the user select multiple images at once
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Tell the picker to go away
            picker.dismiss(animated: true)
            
            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else { return }
            
            // If this provider has an image we can use it:
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    self.parent.image = image as? UIImage
                    // We need the typecast for UIImage – that’s because the data we’re provided could in theory be anything. Yes, I know we specifically asked for photos, but PHPickerViewControllerDelegate calls this same method for any kind of media, which is why we need to be careful.
                }
            }
        }
        
    }
    
    // Even though the Coordinator class is inside a UIViewControllerRepresentable struct, SwiftUI won’t automatically use it for the view’s coordinator. Instead, we need to add a new method called makeCoordinator(), which SwiftUI will automatically call if we implement it:
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // return an instance of our class Coordinator
    }
    
    // makeUIViewController(), which is responsible for creating the initial view controller:
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images // show only the images from the device's library

        let picker = PHPickerViewController(configuration: config)
        // to tell the PHPickerViewController that when something happens in the UIKit View Controller, it should tell our coordinator:
        picker.delegate = context.coordinator // our SwiftUI coordinator will act as a UIKit delegate that responds to events
        return picker
    }
    
    // updateUIViewController(), which is designed to let us update the view controller when some SwiftUI state changes:
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // We aren’t going to be using updateUIViewController(), so you can just delete the “code” line from there so that the method is empty.
    }
    
    // first type the line below and Xcode will bring up a useful error that enable to inject the 2 func signature easily
    // you can remove the line after:
    //typealias UIViewControllerType = PHPickerViewController
}
