//
//  CustomPropertyWrappers.swift
//  Instafilter
//
//  Created by RqwerKnot on 28/03/2022.
//

import SwiftUI

// What property wrappers let us do is use that for any kind of property in a struct or class. Even better, it only takes one step: writing @propertyWrapper before the NonNegative struct, like this:
@propertyWrapper
struct NonNegative<Value: BinaryInteger> {
    var value: Value

    init(wrappedValue: Value) {
        if wrappedValue < 0 {
            value = 0
        } else {
            value = wrappedValue
        }
    }

    var wrappedValue: Value {
        get { value }
        set {
            if newValue < 0 {
                value = 0
            } else {
                value = newValue
            }
        }
    }
}

// In case you hadn’t guessed from their name, property wrappers can only be used on properties rather than plain variables or constants, so to try ours out we’re going to put it inside a User struct like this:
struct User {
    @NonNegative var score = 0
}

struct CustomPropertyWrappers: View {
    
    @State private var user1 = User()
    
    var body: some View {
        VStack {
            Text("Your score is: \(user1.score)")
            
            Button("Increment") {
                user1.score += 1
            }
            
            Button("Decrement") {
                user1.score -= 1
            }
        }
    }
}

struct CustomPropertyWrappers_Previews: PreviewProvider {
    static var previews: some View {
        CustomPropertyWrappers()
            .previewDevice("iPhone 13")
    }
}
