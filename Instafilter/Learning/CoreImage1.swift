//
//  CoreImage1.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CoreImage1: View {
    
    @State private var image: Image?

        var body: some View {
            VStack {
                image? // will show this View if it's not nil
                    .resizable()
                    .scaledToFit()
            }
            .onAppear(perform: loadImage)
            // First, notice how smoothly SwiftUI handles optional views – it just works! However, notice how I attached the onAppear() modifier to a VStack around the image, because if the optional image is nil then it won’t trigger the onAppear() function.
        }

        func loadImage() {
//            image = Image("Example") // this is a complicated way to show a SwiftUI Image, but it's required to make use of CIImage
            
            guard let inputImage = UIImage(named: "Example") else { return }
            let beginImage = CIImage(image: inputImage)

            let context = CIContext()
            
            // a Sepia filter:
            let currentFilter1 = CIFilter.sepiaTone()
            currentFilter1.inputImage = beginImage
            currentFilter1.intensity = 1
            
            // a pixellate filter
            let currentFilter2 = CIFilter.pixellate()
            currentFilter2.inputImage = beginImage
            currentFilter2.scale = 100
            
            // A Crystal filter:
            let currentFilter3 = CIFilter.crystallize()
            currentFilter3.inputImage = beginImage
            currentFilter3.radius = 200
            
            // a twirl distortion filter:
            let currentFilter4 = CIFilter.twirlDistortion()
            currentFilter4.inputImage = beginImage
            currentFilter4.radius = 1000
            currentFilter4.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
            
            // get a CIImage from our filter or exit if that fails
            guard let outputImage = currentFilter1.outputImage else { return }

            // attempt to get a CGImage from our CIImage
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                // convert that to a UIImage
                let uiImage = UIImage(cgImage: cgimg)

                // and convert that to a SwiftUI image
                image = Image(uiImage: uiImage)
            }
        }
}

struct CoreImage1_Previews: PreviewProvider {
    static var previews: some View {
        CoreImage1()
    }
}
