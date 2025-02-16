//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-13.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocument//viewmodel
    typealias Emoji = EmojiArt.Emoji
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    
    
    private let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
//            ScrollingEmojis(emojis)
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
            
        }
    }
    
    
    private var documentBody: some View {
        ///geometry reader is a view that gives you the size of the view that it is in and the coordinate space of the view that it is in.
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)///scales == zoom, scale by a number 1 is the normal, no gesturing i use 1
                    .offset(pan + gesturePan)///plus works because of the extension
            }
            //            .gesture(zoomGesture)
            .gesture(panGesture.simultaneously(with: zoomGesture))//switch over, when the other gesture is detected
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
                
            }
        }
    }
    
    
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero /// when we use offsets in swiftui, we use CGSize , typeallias    //    @State private var pan: CGOffset = .init(width: 100, height: 100)/// infer the type using init, else CGOffset(...)
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    /// the pinch, its on the Zstack so its recognized anywhere, makes sense like an image
    /// MagnificationGesture is deprecated -> use MagnifyGesture instead, it uses .updating
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                //                zoom *= inMotionPinchScale//this worked for me lol
                ///the whole system is designed to only have @Gesturestate be modified in hereh
                gestureZoom = inMotionPinchScale
                
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale
            }
    }
    
    ///pan gesture
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation//only update gesturestate just like above
            }
            .onEnded { value in
                pan += value.translation//+= doesnt work, but extension fixes it in CGOffset,
                
            }
    }
    
    
    @ViewBuilder ///fixes the returing 2 views issue, now it return 1 view a Tuple view
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background) { phase in
            if let image = phase.image {
                image
            } else if let url = document.background {
                if phase.error != nil {
                    Text("\(url) failed to load")
                } else {
                    ProgressView()
                }
            }
                 
        }
            .position(Emoji.Position.zero.in(geometry))///centerd in the emojis arts postion
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
        
    }
    
    
    /// make its fly back, if it does not accept the drop, cant have mutiple drops
    /// only one transferable -> have to make your own transferable -> sturldata
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: paletteEmojiSize / zoom ///have to also adjust the size of the emoji dropped based on the zoom

                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    

    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            //            x: Int(location.x - center.x),
            //            y: Int(-(location.y - center.y))
            
            ///issue before added code is that the emojis position dont know with relation to the pannning and zooming,
            ///center keeps getting moved when panned, and the distance from middle keeps getting zoomed out -> dezoom it
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom)
        )
    }
}












#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
