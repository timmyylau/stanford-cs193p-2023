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
        
        
        ///takes whateveer viewbuilder, slice in peices and does it repeatedly
        ///Timeline view is a view that takes a viewbuilder and a timeline, and it will take that viewbuilder and slice it into pieces and do it repeatedly
        /// CPU vs Battery vs performance tradeoff
        TimelineView(.animation(minimumInterval: 1/10)) { timeline in
            ///disappear from the UI when its matched, fades out
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContent.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    //	.modifier(Cardify(isFaceUp: card.isFaceUp))
            } else {
                Color.clear //leaves a clear rectangle
            }
         }
    }
    
    var cardContent: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.large ))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .aspectRatio(1, contentMode: .fit)
            .multilineTextAlignment(.center)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)//implicit aniamtion, independent
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: 1).repeatForever(autoreverses: false)
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
