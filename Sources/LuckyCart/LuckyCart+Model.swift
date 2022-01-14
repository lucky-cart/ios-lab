//
//  ClientModel.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import Foundation
import SwiftUI

/// LCTypes
///
/// The common types used in LuckyCart framework.
/// These types are used either on client and server side
///
/// We choose a struct here to allow extension in modules

protocol LCIdentifiable: Identifiable {
    var code: String { get set }
}

extension LCIdentifiable {
    public var id: String {
        get { code }
        set { code = newValue }
    }
}

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

public struct LCCustomer: Codable, LCEntity, Identifiable {
    typealias ModelEntity = Model.Customer
    
    public let id: String
    
    init(_ entity: ModelEntity) {
        id = entity.id
    }
}

/// LCCart

public struct LCCart: Codable, LCEntity, Identifiable {
    typealias ModelEntity = Model.Cart
    
    public let id: String
    
    init(_ entity: ModelEntity) {
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

public class LCGame: Codable, LCEntity, LCIdentifiable {
    typealias ModelEntity = Model.Game

    public var code: String
    public var isGamePlayable: Bool
    public var gameResult: LCGameResult
    public var desktopLink: LCLink
    public var mobileLink: LCLink
    
    private init() {
        fatalError("LCGame need to be created from a server entity")
    }
    
    /// Pass a Cart entity from private to public scope
    
    required init(_ entity: ModelEntity) {
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

/// LCBannerSpace

public struct LCBannerSpace: Codable, Identifiable {
    public var id: String { get { identifier } set { identifier = newValue }}
    public var identifier: String
    public var bannerIds: [String]
    
    // Banners Cache
    
    public var banners = [String: LCBanner]()
}

/// LCEntity

protocol LCEntity {
    associatedtype ModelEntity: Codable
    
    init(_ entity: ModelEntity)
}

/// LCBannerSpaces

public struct LCBannerSpaces: Codable, LCEntity {
    
    typealias ModelEntity = Model.BannerSpaces
    
    public var spaces = [LCBannerSpace]()
    
    public subscript (key: String) -> LCBannerSpace? {
        return spaces.first { $0.identifier == key }
    }
    /// Init with server model object
    
    init(_ entity: ModelEntity) {
        entity.forEach { key, value in
            spaces.append(LCBannerSpace(identifier: key, bannerIds: value))
        }
    }
}

// MARK: - Banner and BannerAction

/// LCBannerAction

public struct LCBannerAction: Codable, LCEntity {
    
    typealias ModelEntity = Model.BannerAction

    public var type: LCBannerActionType
    public var ref: String
    
    init(_ entity: ModelEntity) {
        self.type = LCBannerActionType(rawValue: entity.type)
        self.ref = entity.ref
    }
}

/// LCBanner

public struct LCBanner: Codable, LCEntity, Identifiable {
    
    public var id = UUID()
    
    public var identifier: String?

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


public struct LCPostCart: Codable, LCEntity {

    var ticket: String
    var mobileUrl: URL?
    var tabletUrl: URL?
    var desktopUrl: URL?
    var baseMobileUrl: URL?
    var baseTabletUrl: URL?
    var baseDesktopUrl: URL?
    
    init(_ entity: LCRequestResponse.PostCart) {
        self.ticket = entity.ticket
        self.mobileUrl = URL(string: entity.mobileUrl)
        self.tabletUrl = URL(string: entity.tabletUrl)
        self.desktopUrl = URL(string: entity.desktopUrl)
        self.baseMobileUrl = URL(string: entity.baseMobileUrl)
        self.baseTabletUrl = URL(string: entity.baseTabletUrl)
        self.baseDesktopUrl = URL(string: entity.baseDesktopUrl)
    }
}

