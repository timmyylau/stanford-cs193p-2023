//
//  EmojiMemoryGameView.swift
//  Lecture 3
//
//  Created by Timmy Lau on 2025-01-25.
//

/// ViewBuilder allowed to combine views to single view out of it
/// TupleView, a view that can cotian a number of views - up to like 11 views, then use ForEach

import SwiftUI

struct EmojiMemoryGameView: View {
    
    //pased into here becaused have to be marked as source of truth.
    // never say = here,
    // dont use @Stateobject - Every time EmojiMemoryGameView updates (e.g., a button press), it recreates the EmojiMemoryGame object, resetting the game.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    @State var cardCount: Int = 0
    
    
    /// var body is not private because body is part of the View protocol and in the view protocol its not private so we cant make it privaste
    var body: some View {
        VStack {
            ScrollView {
                cards
                    .foregroundStyle(viewModel.color)
                    .animation(.default, value: viewModel.cards)
            }
             Spacer()
            Button("Shuffle"){
                viewModel.shuffle(
                )
            }
        }
//        .background(.yellow) //order matters
        .padding()
//       .background(.yellow) //order matters
    }
    
    /// var cards, its a computer property, its just a regular function, NOT a ViewBuilder,
    /// so when doing lets say
    /// let aspectRation = CGFloat = 2/3
    /// GeometryReader ...
    /// its not returing a view because theres a let aspectRatio.... there, and a View Geometry Reader { ...
    /// you could say
    /// let aspectRation = CGFloat = 2/3
    /// return GeometryReader ... cause then you are actually reuting a view, instead you can use @ViewBuidler
    //    @ViewBuilder 
    private var cards : some View {
        //        let aspectRatio: CGFloat = 2/3
        /// columns: [GridItem(), GridItem(), GridItem()]
        ///defeault arg to GridItem(.flexible), .adaptive, .fixed, .flexible are enums
        /// spacing is platform dependent, for the perfect size we make it 0, padding we add
        /// make the view inside it LazyVGrid, take up all the space offered to it)
        //        GeometryReader { geometry in
        //            let gridItemSize = gridItemWidthThatFits(
        //                count: viewModel.cards.count,
        //                size: geometry.size,
        //                atAspectRatio: cardAspectRatio
        //            )
        //
        //            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
        //                ///when we shuffle the card the indicies change,  so foreach still thinks its the same order
        //                ///  we dont want to foreach over the indicies, we want to foreach over the Card itself, change associattion
        //                ///  associate the view with the actual card, so when the card movie in the array -> the view moves,
        //                ///  now has to confrom to hashable, no more \.self,
        //                ///  need hashable and identifiable to make is hash table -> hook up each to a view
        //                ///  now the ForEach can tell whcih cards go with which views, now it propely shuffles, moves view to new spot
        //                ForEach
        
        
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio){ card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
}




struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
