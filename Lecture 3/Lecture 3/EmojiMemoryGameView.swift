//
//  EmojiMemoryGameView.swift
//  Lecture 3
//
//  Created by Timmy Lau on 2025-01-25.
//

 

import SwiftUI

struct EmojiMemoryGameView: View {
    
    //pased into here becaused have to be marked as source of truth.
    // never say = here,
    // dont use @Stateobject -     •    Every time EmojiMemoryGameView updates (e.g., a button press), it recreates the EmojiMemoryGame object, resetting the game.

    @ObservedObject var viewModel: EmojiMemoryGame
    
     @State var cardCount: Int = 0
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            Button("Shuffle"){
                viewModel.shuffle()
            }
             
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 0)]) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
        .foregroundStyle(.orange)
        
    }
 
}



struct CardView: View {
 
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        let base = RoundedRectangle(cornerRadius: 20)
        ZStack {
            Group {
                base.fill(.white)
                 base
                    .strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200 ))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
             }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
     
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
