//
//  Palette.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-14.
//

import Foundation

/// when adding Codable, we get an interesting message
/// let id = UUID() Immutable property will not be decoded because it is declared with an initial value which cannot be overwritten
/// because its a let, it is set at creation time and never set again
/// when you are decoding youself it creates an empty Palette and sets all the vars -  what decoding means
/// so we cant have any of our vars that are going to be decoded be a LET, they have to be vars
/// when it gets devodede it can be set backt o what it was when it was stored by the encoder
/// Answer: change the let id to var id
struct Palette: Identifiable, Codable, Hashable{
    //    let id = UUID()
    var id = UUID()
    var name: String
    var emojis: String
    
    
    
    ///a bug in this code, before it was     static let builtins: [Palette] =  [
    /// it was a static let of an array of Pallets
    /// if i were to create 2 palette stores (VM) with different names both of them set to builtins
    /// end up haiving palletes with the same ID because the builtin array, these apllets when i create them, they get an ID,
    /// Answer: change to var, and add computed to return this array
    /// meaing when some asks for builtins, it makes new one, runs this computer code again and get new onees with new  ids
    static var builtins: [Palette] { [
            Palette(name: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"),
            Palette(name: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳"),
            Palette(name: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻"),
            Palette(name: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔"),
            Palette(name: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲"),
            Palette(name: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻"),
            Palette(name: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪"),
            Palette(name: "COVID", emojis: "💉🦠😷🤧🤒"),
            Palette(name: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠")
        ] }
}
