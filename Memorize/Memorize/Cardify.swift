//
//  Cardify.swift
//  Memorize
//
//  Created by Timmy Lau on 2025-02-01.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    
    // init theisFaceUp when it gets passed in
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
//    let isFaceUp: Bool
    //make a computed var
    var isFaceUp: Bool {
        rotation  < 90
    }
    
    var rotation: Double
    var animatableData: Double {
        get {
            return rotation
        }
        set {
            rotation = newValue
        }
    }
    
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        //        .rotation3DEffect(.degrees(isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))//flip on its axis
        /// we have to say this is the rotation, cause as soon as we start providing this animatableData
        /// these animations stop working.  cause we told the animation system we are doing the animation.
        /// piecewise rotat the card
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))//flip on its axis
        
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
//        .modifier(Cardify(rotation: isFaceUp ? 0 : 180))
    }
}


