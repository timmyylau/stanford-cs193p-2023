//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-13.
//

import SwiftUI

// ViewModel
class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
            
        }
    }
    
    ///in our sandbox, save to our document directory, we made our own .emojiart type
    ///concert to json and write to
    private let autosaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
    
    private func save(to url: URL) {
        do {
            
            let data = try? emojiArt.json()
            try data?.write(to: url)
        }
        catch let error {
            print("EmojiArt error while autosaving \(error.localizedDescription)")
        }
    }
    
    
    /// retrieve on init
    init () {
 
    }
    
    
//    init(){
        ///load from
        
        //        emojiArt.addEmoji("😀", at: EmojiArt.Emoji.Position(x: 0, y: 0), size: 40)
        //can use the init for type inference
//        emojiArt.addEmoji("😀", at: .init(x: -200, y: 150), size: 40)
//        emojiArt.addEmoji("🚀", at: .init(x: 50, y: 50), size: 40)
//    }
    
    
    private func autosave() {
        save(to: autosaveURL)
        print("i auto save to \(autosaveURL)")
    }
    
    

    
    // MARK: - Access to the Model, computed properties
    var emojis: [Emoji] { emojiArt.emojis }
    
    var background: URL? {
        emojiArt.background
    }
    
    
    
    // MARK: - Intents
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
}

///this code is not part of the model, it is part of the view
extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    /// takes a geometry proxy and returns a CGPoint, the backticks bypasses the reserved word
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        
        /// the CGFloat(x) is from the model
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
        
    }
}

