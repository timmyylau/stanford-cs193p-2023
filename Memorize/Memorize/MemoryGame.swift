//
//  MemorizeGame.swift
//  Lecture 3
//
//  Created by Timmy Lau on 2025-01-25.
//

import Foundation

///CardContent is a dont care, generic, now applies to entire MemoryGame including sub structs applies
/// Wider the generic scope more it will apply instead of on the card Struct, its on the entire MemoryGame struct
/// CardContent confroms    to Equatable because the where adds constraints
struct MemoryGame<CardContent> where CardContent: Equatable {
    
    //setter is private, get is fine
    private(set) var cards: Array<Card>
    
    private(set) var score: Int = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: "\(pairIndex+1)a", content: content))
            cards.append(Card(id: "\(pairIndex+1)b", content: content))
        }
    }
    
    
    /// if it was Int, it would cause the initializer error, cause free == nil case, so no error
    /// computer property - goes and looks at the cards for the card that is face up, get set
//    var indexOfTheOneAndOnlyFaceUpCard: Int?{
//        get{
//            var faceUpCardIndices: [Int] = []
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }                   
//            
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
//        }
//        /// make sure all other cards are face down
//        set{
//            for index in cards.indices {
//                if index == newValue {
//                    cards[index].isFaceUp = true
//                    
//                } else {
//                    cards[index].isFaceUp = false
//                }
//            }
//        }
//    }
    
    
    var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{
//            let faceUpCardIndices = cards.indices.filter { index in cards[index].isFaceUp}
            
            /// the array that comes back filtering the items that is face up, we get the ONLY one out of there
            /// dont even need return, because its handled by the .only which has the retunr there
              cards.indices.filter { index in cards[index].isFaceUp}.only

//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        
        /// set all the cards face down
        set{
             cards.indices.forEach{cards[$0].isFaceUp = (newValue == $0)}
        }
    }
    
 
    
    /// isFaceUp.toggle() doesnt not work, value vs reference type, we are getting a value type here
    mutating func choose(_ card: Card){
//        print("chose that \(card)")

        /// could be if let instead of guard let
//        guard let chosenIndex = cards.firstIndex(of: card) else { return  }
        /// return type of .firstIIndex is optional Int
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}){
            
            // no match, turn cards over
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true	
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                            
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                    
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                //turn card face up, no matter what
                cards[chosenIndex].isFaceUp = true
                
                /// check if the 2nd card selected matches,

            }

        }
    }
    
    
    /// optional Int, so if cant find, retunr nil
//     private func index(of card: Card) -> Int? {
//        for index in cards.indices {
//            if cards[index] == card {
//                return index
//            }
//        }
//         return nil
//    }
    
    //copy on write, swift does not let you mutate your own struc without putting mutating
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    
    
    
    
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
  
        
        /// checks if the 1st is == to the 2nd, conform to Equatable
        /// CardContent is our generic, dont care, but lhs.content == rhs.content makes us require CardContent to also be Equatable
        /// dont need the code below anymore because it all vars are equiatable,
        //        static func == (lhs: Card, rhs: Card) -> Bool {
        //            return lhs.isFaceUp == rhs.isFaceUp &&
        //            lhs.isMatched == rhs.isMatched &&
        //            lhs.content == rhs.content
        //        }
        
        var id: String
//        var isFaceUp = false
        // using Property Observers
        var isFaceUp = false {
            didSet {
                
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
            
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        var hasBeenSeen: Bool = false
        
        var debugDescription: String {
            return "Card ID: \(id),  \(isFaceUp ? "up" : "down"), isMatched: \(isMatched), content: \(content)"
        }
        
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
    }
    
    
    
    
}

/// i am in an Array
/// i can use first, count, things are in the Array, i AM an array
extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
