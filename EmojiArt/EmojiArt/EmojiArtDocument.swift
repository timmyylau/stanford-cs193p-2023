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
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
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
    
    var bbox: CGRect {
        var bbox = CGRect.zero
        for emoji in emojiArt.emojis {
            bbox = bbox.union(emoji.bbox)
        }
        if let backgroundSize = background.uiImage?.size {
            bbox = bbox.union(CGRect(center: .zero, size: backgroundSize))
        }
        return bbox
    }

    
    // MARK: - Access to the Model, computed properties
    var emojis: [Emoji] { emojiArt.emojis }
    
//    var background: URL? {
//        emojiArt.background
//    }
    @Published var background: Background = .none
    
    // MARK: - Background Image
    
    @MainActor
    private func fetchBackgroundImage() async {
        if let url = emojiArt.background {
            background = .fetching(url)
            do {
                ///before the fix - i got the purple error here beause it was because it was when this gets published, draw this image
                ///added the Main Actor to this function
                ///now checking the image for the when i come back, did my world change scenario, 
                let image = try await fetchUIImage(from: url)
                if url == emojiArt.background {
                    background = .found(image)
                }
            } catch {
                background = .failed("Couldn't set background: \(error.localizedDescription)")
            }
        } else {
            background = .none
        }
    }
    
    private func fetchUIImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            throw FetchError.badImageData
        }
    }
    
    enum FetchError: Error {
        case badImageData
    }
    
    /// step through the states of fetching the image
    enum Background {
        case none
        case fetching(URL)
        case found(UIImage)
        case failed(String)
        
        var uiImage: UIImage? {
            switch self {
            case .found(let uiImage): return uiImage
            default: return nil
            }
        }
        
        var urlBeingFetched: URL? {
            switch self {
            case .fetching(let url): return url
            default: return nil
            }
        }
        
        var isFetching: Bool { urlBeingFetched != nil }
        
        var failureReason: String? {
            switch self {
            case .failed(let reason): return reason
            default: return nil
            }
        }
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
    var bbox: CGRect {
        CGRect(
            center: position.in(nil),
            size: CGSize(width: CGFloat(size), height: CGFloat(size))
        )
    }
}


extension EmojiArt.Emoji.Position {
    /// takes a geometry proxy and returns a CGPoint, the backticks bypasses the reserved word
    func `in`(_ geometry: GeometryProxy?) -> CGPoint {
        let center = geometry?.frame(in: .local).center ?? .zero
        
        /// the CGFloat(x) is from the model
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
        
    }
}

