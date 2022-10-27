//
//  MakeItChange.swift
//  Instafilter
//
//  Created by RqwerKnot on 17/03/2022.
//

import SwiftUI

struct MakeItChange: View {
    
    @State private var blurAmount = 0.0

        var body: some View {
            VStack {
                Text("Hello, World!")
                    .blur(radius: blurAmount)

                Slider(value: $blurAmount, in: 0...20)
                    .onChange(of: blurAmount) { newValue in
                        print("New value is \(newValue)")
                    }
                // this is the proper way to observe change of a property wrapper and react to it
                // you can attach this modifier anywhere in the View hierarchy, not necessarly to the View triggering the change
            }
        }
}

struct MakeItChange_Previews: PreviewProvider {
    static var previews: some View {
        MakeItChange()
    }
}
