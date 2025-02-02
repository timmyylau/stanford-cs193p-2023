//
//  CardView.swift
//  Memorize
//
//  Created by Timmy Lau on 2025-02-01.
//

import SwiftUI


struct CardView: View {
    
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 4
        struct FontSize {
            static let large: CGFloat = 200
            static let small: CGFloat = 10
            static let scaleFactor = small / large
            
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
    
    var body: some View {
        //        ZStack {
        //            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        //
        //            Group {
        //                base.fill(.white)
        //                base.strokeBorder(lineWidth: Constants.lineWidth)
        //
        //
        //
        //                Pie(endAngle: .degrees(240))
        //                    .opacity(Constants.Pie.opacity)
        //                    .overlay(
        //                        Text(card.content)
        //                            .font(.system(size: Constants.FontSize.large ))
        //                            .minimumScaleFactor(Constants.FontSize.scaleFactor)
        //                            .aspectRatio(1, contentMode: .fit)
        //                            .multilineTextAlignment(.center)
        //                            .padding(Constants.Pie.inset)
        //                    )
        //                    .padding(Constants.inset)
        //            }
        //            .opacity(card.isFaceUp ? 1 : 0)
        //            base.fill()
        //                .opacity(card.isFaceUp ? 0 : 1)
        //        }
        
        
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.large ))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .aspectRatio(1, contentMode: .fit)
                    .multilineTextAlignment(.center)
                    .padding(Constants.Pie.inset)
            )
            .padding(Constants.inset)
            .cardify(isFaceUp: card.isFaceUp)
//            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        
    }
}

#Preview {
    //     Card = CardView.Card
    VStack{
        HStack {
            CardView(MemoryGame<String>.Card(id: "1", isFaceUp: false, isMatched: false, content: "A"))
            CardView(MemoryGame<String>.Card(id: "1", isFaceUp: true, isMatched: false, content: "A"))
        }
        
        HStack {
            CardView(MemoryGame<String>.Card(id: "1", isFaceUp: true, isMatched: true, content: "Thisis a very long text and i hope it fits in the card"))
            CardView(MemoryGame<String>.Card(id: "1", isFaceUp: true, isMatched: true, content: "A"))
        }
    }
    .padding()
    .foregroundStyle(.green)
}
