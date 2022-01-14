//
//  LCStage.swift
//  
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

struct LCStage: RawRepresentable, Codable, Equatable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let connecting = LCStage(rawValue: "connecting")
    static let browsing = LCStage(rawValue: "browsing")
    static let checkingOut = LCStage(rawValue: "checkingOut")
    static let browsingGames = LCStage(rawValue: "browsingGames")
    static let playing = LCStage(rawValue: "playing")
}
