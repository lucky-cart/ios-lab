//
//  ClientModel.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import Foundation
import SwiftUI

/// Client Model
///
/// The server model describes the Lucky cart entities as created/stored on device
///
/// This set of objects is public and can be freely accessed by LuckyCart API clients
/// - Customer
/// - Cart
/// - Link
/// - Game
/// - BannerSpaces
/// - Banner

// MARK: - Customer, Cart and Link

/// LCCustomer

public struct LCCustomer: Codable, Identifiable {
    public let id: String
    
    init(_ entity: Model.Customer) {
        id = entity.id
    }
}

/// LCCart

public struct LCCart: Codable, Identifiable {
    public let id: String
    
    init(_ entity: Model.Cart) {
        id = entity.id
    }
}

/// LCLink
///
/// Wraps a link to an url and an optional image url

public struct LCLink: Codable {
    public let url: URL
    public let imageUrl: URL?
    
    enum CodingKeys: String, CodingKey  {
        case url
        case imageUrl
    }
}

// MARK: - Game

/// LCGame

public class LCGame: Codable, LCIdentifiable {
    public var code: String
    public var isGamePlayable: Bool
    public var gameResult: LCGameResult
    public var desktopLink: LCLink
    public var mobileLink: LCLink
    
    private init() {
        fatalError("LCGame need to be created from a server entity")
    }
    
    /// Pass a Cart entity from private to public scope
    
    init(_ entity: Model.Game) {
        self.code = entity.code
        self.isGamePlayable = entity.isGamePlayable
        self.gameResult = entity.gameResult
        
        self.desktopLink = LCLink(url: entity.desktopGameUrl,
                                  imageUrl: entity.desktopGameImage)
        self.mobileLink = LCLink(url: entity.mobileGameUrl,
                                 imageUrl: entity.mobileGameImage)
    }
}

/// Game Results

public struct LCGameResult: RawRepresentable, Codable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let notPlayed = LCGameResult(rawValue: "not-played")
}

// MARK: - LCBannerSpaces

/// LCBannerSpaces

public struct LCBannerSpaces: Codable {
    public var homePage: [String]
    public var categories: [String]
    
    /// Init with server model object
    
    init(_ entity: Model.BannerSpaces) {
        self.homePage = entity.homepage
        self.categories = entity.categories
    }
}

// MARK: - Banner and BannerAction

/// LCBannerAction

public struct LCBannerAction: Codable {
    var type: LCBannerActionType
    var ref: String
    
    init(_ entity: Model.BannerAction) {
        self.type = LCBannerActionType(rawValue: entity.type)
        self.ref = entity.ref
    }
}

/// LCBanner

public struct LCBanner: Codable {
    public var imageUrl: URL
    public var redirectUrl: URL
    public var name: String
    public var campaign: String
    public var space: String
    public var action: LCBannerAction
    
    init(_ entity: Model.Banner) {
        self.imageUrl = entity.image_url
        self.redirectUrl = entity.redirect_url
        self.name = entity.name
        self.campaign = entity.campaign
        self.space = entity.space
        self.action = LCBannerAction(entity.action)
    }
}

/// Banner Action Types
///
/// - boutique
///

public struct LCBannerActionType: RawRepresentable, Codable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let boutique = LCBannerActionType(rawValue: "boutique")
}


