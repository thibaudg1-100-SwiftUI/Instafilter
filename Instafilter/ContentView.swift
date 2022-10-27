//
//  ContentView.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var processedImage: UIImage?
    
    // this initial assignment is ok if we want to use only one specific type of filter:
    //@State private var currentFilter = CIFilter.sepiaTone()
    // But if we need to chnage filter type later on, we must add a type constraint that allows more flexibility:
    @State private var currentFilter : CIFilter = CIFilter.sepiaTone()
    // now any type of 'CIFilter' can be assigned to 'currentFilter'
    // Adding that explicit type annotation means we’re throwing away some data: we’re saying that the filter must be a CIFilter but doesn’t have to conform to CISepiaTone any more
    
    // A Core Image context is an object that’s responsible for rendering a CIImage to a CGImage, or in more practical terms an object for converting the recipe for an image into an actual series of pixels we can work with.
    // Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive =  do not create it inside a function or loop...
    let context = CIContext()
    
    @State private var showingFilterDialog = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        showingFilterDialog = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterDialog) {
                // You will need to use 'Group' for more than 10 ButtonS	
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        // we don't want to directly show the selected image on screen, but process it in the current filter first
        //        image = Image(uiImage: inputImage)
        
        // Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash:
        //        currentFilter.inputImage = CIImage(image: inputImage)
        
        // it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey:
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        // Core Image is expecting a Float, which is not a Double, neither a CGFloat:
        //currentFilter.intensity = Float(filterIntensity)
        // We cannot use directly subscripting now that 'currentFilter' is no more a 'CIFilter & CISepiaTone' but a more generic 'CIFilter'
        // We must use a generic key-value assignment:
        // But will crash if a particular CIFilter doesn't have an intensity key...
        //currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        
        // So better request the list of kCIInputKey first
        let inputKeys = currentFilter.inputKeys
        // and then act on the existing keys to avoid any crash:
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        // you should add a sensible factor to the [0...1] range returned by the slider depending on what key you're setting up
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        // .extent specify the full extent of the picture
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg) // this init might return nil, even if Swift doesn't seem to know it...
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops: \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
