//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-17.
//

import SwiftUI




struct PaletteEditor: View {
    ///source of truth, referecne the palette back in the VM, and pass to the textfield
    @Binding var palette: Palette
    private let emojiFont = Font.system(size: 40)
    @State private var emojisToAdd: String = ""
    
    ///usually a bool, for one text field. but we have 2 text fields, so we use an enum
    enum Focused {
        case name
        case addEmojis
    }

    @FocusState private var focused: Focused?

    var body: some View {
        Form {
            Section(header: Text("Name")){
                ///binding all the way back to the VM, a binding to the binding of this palette -> VM
                TextField("Name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Emojis")){
                TextField("Add Emojis here", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) { oldValue, emojisToAdd in
                        ///change the VM directly
                        palette.emojis = (emojisToAdd + palette.emojis)
                            .filter{$0.isEmoji}
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear() {
            if palette.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
    
    var removeEmojis: some View {
        VStack {
            Text("Tap to Remove Emojis")
                .font(.caption)
                .foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}


///preview is tricky cause you need a binding now
///Answer: we make our own view for the preview
//#Preview {
//    @Previewable @State var palette = PaletteStore(named: "Preview").palettes.first!
//        
//    PaletteEditor(palette: $palette)
//}


struct PaletteEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var palette = PaletteStore(named: "Preview").palettes.first!
        var body: some View {
            PaletteEditor(palette: $palette)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}



//
//  PaletteEditor.swift
//  Emoji Art
//
//  Created by CS193p Instructor on 5/17/23.
//  Copyright (c) 2023 Stanford University
//

//import SwiftUI
//
//struct PaletteEditor: View {
//    @Binding var palette: Palette
//        
//    private let emojiFont = Font.system(size: 40)
//    
//    @State private var emojisToAdd: String = ""
//    
//    enum Focused {
//        case name
//        case addEmojis
//    }
//    
//    @FocusState private var focused: Focused?
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Name")) {
//                TextField("Name", text: $palette.name)
//                    .focused($focused, equals: .name)
//            }
//            Section(header: Text("Emojis")) {
//                TextField("Add Emojis Here", text: $emojisToAdd)
//                    .focused($focused, equals: .addEmojis)
//                    .font(emojiFont)
//                    .onChange(of: emojisToAdd) { emojisToAdd in
//                        palette.emojis = (emojisToAdd + palette.emojis)
//                            .filter { $0.isEmoji }
//                            .uniqued
//                    }
//                removeEmojis
//            }
//        }
//        .frame(minWidth: 300, minHeight: 350)
//        .onAppear {
//            if palette.name.isEmpty {
//                focused = .name
//            } else {
//                focused = .addEmojis
//            }
//        }
//    }
//    
//    var removeEmojis: some View {
//        VStack(alignment: .trailing) {
//            Text("Tap to Remove Emojis").font(.caption).foregroundColor(.gray)
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
//                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
//                    Text(emoji)
//                        .onTapGesture {
//                            withAnimation {
//                                palette.emojis.remove(emoji.first!)
//                                emojisToAdd.remove(emoji.first!)
//                            }
//                        }
//                }
//            }
//        }
//        .font(emojiFont)
//    }
//}

//struct PaletteEditor_Previews: PreviewProvider {
//    struct Preview: View {
//        @State private var palette = PaletteStore(named: "Preview").palettes.first!
//        var body: some View {
//            PaletteEditor(palette: $palette)
//        }
//    }
//    
//    static var previews: some View {
//        Preview()
//    }
//}

