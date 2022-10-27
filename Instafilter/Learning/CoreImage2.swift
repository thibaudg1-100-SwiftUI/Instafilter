//
//  CoreImage2.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CoreImage2: View {
    @State private var image: Image?

        var body: some View {
            VStack {
                image?
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
            
            // there’s a lot we can do using only the modern API. But for this project we’re going to use the older API for setting values such as radius and scale because it lets us set values dynamically – we can literally ask the current filter what values it supports, then send them on in.
            let currentFilter = CIFilter.twirlDistortion()
            currentFilter.inputImage = beginImage

            let amount = 1.0

            let inputKeys = currentFilter.inputKeys

            if inputKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
            if inputKeys.contains(kCIInputRadiusKey) {
                currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
            if inputKeys.contains(kCIInputScaleKey) {
                currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
            
            // With that in place, you can now change the twirl distortion to any other filter and the code will carry on working – each of the adjustment values are sent in only if they are supported.
            
            // get a CIImage from our filter or exit if that fails
            guard let outputImage = currentFilter.outputImage else { return }

            // attempt to get a CGImage from our CIImage
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                // convert that to a UIImage
                let uiImage = UIImage(cgImage: cgimg)

                // and convert that to a SwiftUI image
                image = Image(uiImage: uiImage)
            }
        }
}

struct CoreImage2_Previews: PreviewProvider {
    static var previews: some View {
        CoreImage2()
    }
}
