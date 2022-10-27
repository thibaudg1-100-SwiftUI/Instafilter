//
//  ImageSaver.swift
//  Instafilter
//
//  Created by RqwerKnot on 18/03/2022.
//

import UIKit

// to write an image to the photo library and read the response, we need some sort of class that inherits from NSObject. Inside there we need a method with a precise signature that’s marked with @objc, and we can then call that from UIImageWriteToSavedPhotosAlbum()

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)? // optional, so that it's not mandatory to provide it
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        // Mark the method using a special compiler directive called #selector, which asks Swift to make sure the method name exists where we say it does:
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    // Add an attribute called @objc to the method, which tells Swift to generate code that can be read by Objective-C:
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error) // optional, so that if it has not been provided, it's simply not triggered
        } else {
            successHandler?()
        }
    }
}

/*
 Before I show you the code, I want to mention the fourth parameter. So, the first one is the image to save, the second one is an object that should be notified about the result of the save, the third one is the method on the object that should be run, and then there’s the fourth one. We aren’t going to be using it here, but you need to be aware of what it does: we can provide any sort of data here, and it will be passed back to us when our completion method is called.

 This is what UIKit calls “context”, and it helps you identify one image save operation from another. You can provide literally anything you want here, so UIKit uses the most hands-off type you can imagine: a raw chunk of memory that Swift makes no guarantees about whatsoever. This has its own special type name in Swift: UnsafeRawPointer.
*/
