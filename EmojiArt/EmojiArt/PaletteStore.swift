//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-14.
//

import SwiftUI

/// viewmodel called stored -> when the VM stores something, it stores all the Palletes
/// we make it persists
class PaletteStore: ObservableObject {
    let name: String
    ///not private, not going to protect the mdoel, the VM is offering up the Model to the View directly (delete, add, change)
    
    @Published var palettes: [Palette] {
        ///cant delete the last palette, careful can end in an inifinte loop if not checked
        didSet {
            if palettes.isEmpty, !oldValue.isEmpty {
                palettes = oldValue
            }
        }
    }
    
    
    init(named name:String) {
        self.name = name
        palettes = Palette.builtins
        
        if palettes.isEmpty {
            palettes = [Palette(name: "Warning", emojis: "⚠️")]
        }
    }
    
    
    ///make sure it is never array out of bouncds
    @Published private var _cursorIndex = 0
    var cursorIndex: Int {
        get {boundsCheckedPaletteIndex(_cursorIndex)}
        set {_cursorIndex = boundsCheckedPaletteIndex(newValue)}
    }
    
    private func boundsCheckedPaletteIndex(_ index: Int) -> Int {
        var index = index % palettes.count ///make sure in the count stapce
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    // MARK: - Adding Palettes
    
    // these functions are the recommended way to add Palettes to the PaletteStore
    // since they try to avoid duplication of Identifiable-ly identical Palettes
    // by first removing/replacing any Palette with the same id that is already in palettes
    // it does not "remedy" existing duplication, it just does not "cause" new duplication
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
    }
    
    func append(_ palette: Palette) { // at end of palettes
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
    func append(name: String, emojis: String) {
        append(Palette(name: name, emojis: emojis))
    }
}

extension PaletteStore: Hashable {
    static func == (lhs: PaletteStore, rhs: PaletteStore) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    
    
}
