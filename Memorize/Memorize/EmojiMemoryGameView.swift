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
    // dont use @Stateobject - Every time EmojiMemoryGameView updates (e.g., a button press), it recreates the EmojiMemoryGame object, resetting the game.
    @ObservedObject var viewModel: EmojiMemoryGame
    
     @State var cardCount: Int = 0
    var body: some View {
        VStack {
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Spacer()
            Button("Shuffle"){
                viewModel.shuffle(
                    
                )
            }
             
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 0)]) {
            ///when we shuffle the card the indicies change,  so foreach still thinks its the same order
            ///  we dont want to foreach over the indicies, we want to foreach over the Card itself, change associattion
            ///  associate the view with the actual card, so when the card movie in the array -> the view moves,
            ///  now has to confrom to hashable, no more \.self,
            ///  need hashable and identifiable to make is hash table -> hook up each to a view
            ///  now the ForEach can tell whcih cards go with which views, now it propely shuffles, moves view to new spot
            ForEach(viewModel.cards, id: \.id) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
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
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
     
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
