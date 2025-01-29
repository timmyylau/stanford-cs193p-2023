//
//  MemorizeGame.swift
//  Lecture 3
//
//  Created by Timmy Lau on 2025-01-25.
//

import Foundation

///CardContent is a dont care, generic, now applies to entire MemoryGame including sub structs applies
/// Wider the generic scope more it will apply instead of on the card Struct, its on the entire MemoryGame struct
struct MemoryGame<CardContent> {
    
    //setter is private, get is fine
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    
    
    func choose(card: Card){
        
    }
    
    //copy on write, swift does not let you mutate your own struc without putting mutating 
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    
    
    struct Card {
        var isFaceUp = true 
        var isMatched = false
        let content: CardContent
        
    }
}


