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
    typealias Card = MemoryGame<String>.Card
    //pased into here becaused have to be marked as source of truth.
    // never say = here,
    // dont use @Stateobject - Every time EmojiMemoryGameView updates (e.g., a button press), it recreates the EmojiMemoryGame object, resetting the game.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    /// i am explicity making the size 50
    private let deckwidth: CGFloat = 50
    

    @State var cardCount: Int = 0
    
    
    /// var body is not private because body is part of the View protocol and in the view protocol its not private so we cant make it privaste
    var body: some View {
        VStack {
            //            ScrollView {
            cards.foregroundStyle(viewModel.color)
            //            }
            HStack {
                score
                Spacer()
                deck.foregroundStyle(viewModel.color)
                Spacer()
                shuffle
                
            }
            .font(.largeTitle)
        }
        //        .background(.yellow) //order matters
        .padding()
        //       .background(.yellow) //order matters
    }
    
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)//implicit animation, do not animate this view
    }
    
    private var shuffle: some View {
        
        Button("Shuffle"){
            withAnimation {
                viewModel.shuffle()
            }
        }
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
        
        
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            
            if isDealth(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) //matchedGeometryEffect is a way to make a view match the geometry of another view, matched below
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0) //zIndex is a way to stack views on top of each other
                    .onTapGesture {
                        //explicit animation, aniamted everything when i click a card
                        choose(card)
                    }
            }
        }
        
    }
    
    
    /// its @State because its a view state, its a view state because its a view that is keeping track of the cards that have been dealt
    /// not in the model, not part of the game, its part of the view
    @State private var dealt = Set<Card.ID>()
    
    private func isDealth(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter({!isDealth($0)})
    }
    
    
    @Namespace private var dealingNamespace
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                //                    .transition(.offset(
                //                        x: CGFloat.random(in: -1000...1000),
                //                        y: CGFloat.random(in: -1000...1000)
                //                    ))
                
                ///we used matchedGeometry here because we want the cardview to match the geometry
                ///fly from thedeck to their positions and size
                /// transitionn identity means no transition, at all, just appear
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                //                    .transition(.identity)
                /// it looks the same as transiton(.identity), but it is not, it is a different kind of transition
                /// it is a transition that is asymmetric, it has a different transition for insertion and removal
                /// does not overrride the matchedGeometryEffect
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                
                ///create a container thats the size and offer the space to the card inside it, uses all the space offered to it, dont really used.
                /// this entire time we have been programmatically setting the sizes throughout the app
                    .frame(width: deckwidth, height: deckwidth / aspectRatio)
                    .onTapGesture {
                        deal()

                    }
            }
        }
    }
    
    
    
    
    private func deal() {
        //deal the cards out
        var delay: TimeInterval = 0
        
        /// animaiton happnes instantly, and shows us over time
        /// delay subsequent cards to give the effect of dealing
        for card in viewModel.cards {
            /// withAnimaiton has a feature, it returns whatever is in the closure returns, widthAnimaton retunrs it too
            ///  has a implicit return eg retunr dealt.insert(card.id), closure 1 line is fine
            ///  and insert has a returns a tuple, so it returns that tuple
            ///  this is why we have to do _ =
            ///  another way is to put in a fucntion that doesnt return anthing
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    

    
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    //    @State private var lastScoreChange: (amount: Int, causedByCardId: Card.ID) = (amount: 0, causedByCardId: "")
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
        
        //        return lastScoreChange.1 == card.id ? lastScoreChange.0 : 0//obscure, avoid
    }
}


struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
