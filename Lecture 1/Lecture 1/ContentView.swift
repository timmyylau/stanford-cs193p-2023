//
//  ContentView.swift
//  Lecture 1
//
//  Created by Timmy Lau on 2025-01-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            CardView(isFaceUp: false)
            CardView(isFaceUp: true)
            CardView(isFaceUp: false)
            CardView(isFaceUp: true)
        }
        .padding(20)
        .foregroundStyle(.orange)
        
    }
}


struct CardView: View {
    var isFaceUp : Bool = false
    var body: some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 20).fill(Color.white)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 5)
                Text("💰")
                    .font(.largeTitle)
            }else {
                RoundedRectangle(cornerRadius: 20)
            }
        }
     }
}

#Preview {
    ContentView()
}
