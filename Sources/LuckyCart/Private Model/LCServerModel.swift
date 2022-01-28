//
//  ServerModel.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import Foundation

/// Server Model
///
/// The server model describes the entities as sent by or received from the LuckyCart server
///
/// This set of objects is private and is defined by the Lucky Cart team.
/// - Carts
/// - Games
/// - Banners

//extension LCNetwork {

struct Model {
    
    // MARK: - Customer and Cart
    
    struct Customer: Codable, Identifiable {
        public let id: String
        
        static let guest = Customer(id: "unknown")
    }
    
    /// LCCart
    
    struct Cart: Codable, Identifiable {
        public let id: String
    }
    
    // MARK: - Game
    
    /// LCGame
    
    internal struct Game: Codable, LCIdentifiable {
        internal var code: String
        internal var isGamePlayable: Bool
        internal var gameResult: LCGameResult
        internal var desktopGameUrl: URL
        internal var desktopGameImage: URL
        internal var mobileGameUrl: URL
        internal var mobileGameImage: URL
    }
    
    /// The Games as sent by server
    
    struct Games: Codable {
        var games: [Model.Game]
    }
    
    // MARK: - Banner Spaces
    
    /// The BannerSpaces as sent by server
    ///
    /// A banner ids dictionary keyed by String
    ///
    /// String is a string that can be freely created
    ///
    /// However, a collection of sample names and formats for banner spaces identification
    
    typealias BannerSpaces = [String: [String]]
    
    // MARK: - Banner and BannerAction
    
    /// Banner action
    
    struct BannerAction: Codable {
        var type: String
        var ref: String
    }
    
    /// LCBanner
    
    struct Banner: Codable {
        var image_url: URL
        var redirect_url: URL
        var name: String
        var campaign: String
        var space: String
        var action: BannerAction
    }
    
}
