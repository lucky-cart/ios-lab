//
//  LuckyCart+Stage.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 16/01/2022.
//

import Foundation

/// LCStage
///
/// The current stage in LuckyCartSequence
///

public struct LCStage: RawRepresentable, Codable, Equatable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// The user is connecting to the LuckyCart api
    public static let connecting = LCStage(rawValue: "connecting")
    
    /// The user is connected, and browses the app
    public static let browsing = LCStage(rawValue: "browsing")
    
    /// The user is checking out ( time to request extra information if needed )
    public static let checkingOut = LCStage(rawValue: "checkingOut")
    
    /// The user has checked out and games are downloading
    public static let loadingGames = LCStage(rawValue: "loadingGames")
    
    /// The user has checked out and received the list of games.
    /// Now is browsing.
    /// The way the game are presented is up to the framework client.
    public static let browsingGames = LCStage(rawValue: "browsingGames")

    /// If a game is selected, stage is set to `playing`.
    /// When the game is closed, stage is set back to browsing games.
    /// If there is no more game available, stage is set to `allGamesPlayed`
    public static let playing = LCStage(rawValue: "playing")
    
    /// Nothing more to earn for the user
    public static let allGamesPlayed = LCStage(rawValue: "allGamesPlayed")

    
    /// The LuckyCart session is closed
    public static let closed = LCStage(rawValue: "closed")
}

