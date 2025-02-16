//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-13.
//

import Foundation


struct EmojiArt: Codable {
    var background: URL?//codable yes
    private(set) var emojis = [Emoji]() // add emoji to the model, codable yes cause its an array, but of emojis which is not Codable

    private var uniqueEmojiId = 0
    
    /// try ? cause can throw
//    func json() -> Data? {
//        return try? JSONEncoder().encode(self)
//    }
    
    /// if that try throws an error, its goint to throw up to who ever called it
    func json() throws -> Data {
        let encoded =  try JSONEncoder().encode(self)
        print("EmojirArt = \(String(data: encoded, encoding: .utf8) ?? "nil")")
        return encoded
    }
    
    ///init itself as json
    init(json: Data) throws {
        /// self = is fine because its a value type, value type can replace its entire selves with self =
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    ///no free init cause we added the one above,
    ///init with no arguemnts, we add this one, have to explicitly put it back
    init (){
        
    }
    
    //copy on write,
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqueEmojiId))
    }
    
    struct Emoji: Identifiable, Codable {
        let string: String
        var position: Position //not Codable
        var size: Int
        var id: Int
        
        ///now everything is Codeable, make sure sub structs are also codeable, codable all the way down
        struct Position: Codable {
            var x: Int
            var y: Int
            
            /// Self is the type of what your code is in, so if you are in a struct, Self is the struct, if you are in a class, Self is the class
            /// this case Self is EmojiArt.Emoji.Position
            /// same as Position(x: 0, y: 0) instaed of Self(x: 0, y: 0)
            static let zero = Self(x: 0, y: 0)
            
        }
        
    }
}

