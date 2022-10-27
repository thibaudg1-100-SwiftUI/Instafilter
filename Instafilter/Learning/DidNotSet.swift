//
//  DidNotSet.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI

struct DidNotSet: View {
    
    @State private var blurAmount = 0.0 {
        didSet {
            print("New value is \(blurAmount)")
        }
        // this property observer is not watching the Double, but is actually watching the @State property (State<Double>) which is a struct that is not changing
    }
    // it is generally not recommended to use a property observer on a property wrapper, as it is not gauranteed that it will be triggered even when property is somehow evolving

        var body: some View {
            VStack {
                Text("Hello, World!")
                    .blur(radius: blurAmount)
                
                // using the Slider won't trigger the didSet property observer, and no statement will print:
                Slider(value: $blurAmount, in: 0...20)
                // the Slider uses the projectedValue of State<Double> blurAmount which has no setter, and therefore won't trigger the didSet property observer when the slider is in use
                // "our binding is directly changing the internally stored value, which means the property observer is never being triggered."
                
                // using the Button will trigger the didSet property observer, and a statement will print:
                Button("Random Blur") {
                    blurAmount = Double.random(in: 0...20)
                    // this assignment tells Swift to set (change, edit) the wrappedValue of the @State property wrapper
                    // the wrappedValue setter is a non mutating setter, which means it won't actually change the value of wrappedValue, but will store away its values for SwiftUI to refresh UI
                    // "but that when we set the value it won’t actually change the State<Double> struct itself. Behind the scenes, it sends that value off to SwiftUI for storage in a place where it can be modified freely, so it’s true that the struct itself never changes."
                }
            }
        }
}

struct DidNotSet_Previews: PreviewProvider {
    static var previews: some View {
        DidNotSet()
    }
}
