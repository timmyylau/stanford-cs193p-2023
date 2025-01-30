//
//  EmojiMemoryGame.swift
//  Lecture 3
//
//  Created by Timmy Lau on 2025-01-25.
//

import SwiftUI



/// class because its shared
class EmojiMemoryGame: ObservableObject {
    //<CardContent> is sent a <String>
    //    private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfEmojis: 12)
    
    @Published private var model = createMemoryGame()

    private static let emojis = ["🦄", "🐴", "🦓", "🦌", "🦙", "🦎", "🦍", "🦏", "🦐", "🦑", "🦒", "🦓"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 12) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return ""
            }
        }
    }
    
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose (_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    
    
}
