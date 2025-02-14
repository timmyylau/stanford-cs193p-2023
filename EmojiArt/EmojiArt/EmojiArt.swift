//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-13.
//

import Foundation


struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]() // add emoji to the model.

    
    private var uniqueEmojiId = 0 
    
    //copy on write,
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqueEmojiId))
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int  
            var y: Int
            
            /// Self is the type of what your code is in, so if you are in a struct, Self is the struct, if you are in a class, Self is the class
            /// this case Self is EmojiArt.Emoji.Position
            /// same as Position(x: 0, y: 0) instaed of Self(x: 0, y: 0)
            static let zero = Self(x: 0, y: 0)
            
        }
        
    }
}

