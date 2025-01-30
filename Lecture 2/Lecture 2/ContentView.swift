//
//  ContentView.swift
//  Lecture 2
//
//  Created by Timmy Lau on 2025-01-25.
//

import SwiftUI

struct ContentView: View {
    //    let emojis: Array<String> = ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐨", "🐵", "🐿️"]
    let emojis: [String] = ["🐶", "🐱", "🐭", "🐹", "🐼", "🐨", "🐵"]
    @State var cardCount: Int = 0
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountAdjusters
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 200))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
        
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
    
    var cardRemover: some View {
        return cardCountAdjuster(by: -1, symbol: "minus.circle.fill")
    }
    var cardAdder: some View {
        return cardCountAdjuster(by: +1, symbol: "plus.circle.fill")
    }
    
}



struct CardView: View {
    let content: String
    @State var isFaceUp : Bool = false
    var body: some View {
        let base = RoundedRectangle(cornerRadius: 20)
        ZStack {
            Group {
                base.fill(.white)
                 base
                    .strokeBorder(lineWidth: 2)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
