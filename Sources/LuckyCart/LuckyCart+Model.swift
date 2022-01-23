//
//  LuckyCart+Model.swift
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
    
    public init(id: String) {
        self.id = id
    }
    
    init(_ entity: ModelEntity) {
        id = entity.id
    }

    static let guest = LCCustomer(Model.Customer.guest)
}

/// LCCart

public struct LCCart: Codable, LCEntity, Identifiable {
    typealias ModelEntity = Model.Cart
    
    public let id: String
    
    public init(id: String = UUID().uuidString) {
        self.id = id
    }

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

    /// image
    ///
    /// Published property. Interface can listen to update when image is available
    public var image: UIImage? = nil

    enum CodingKeys: String, CodingKey {
        case url
        case imageUrl
    }
    
    public var isEnabled: Bool = true
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
                                  imageUrl: entity.desktopGameImage,
                                  isEnabled: entity.isGamePlayable)
        
        
        self.mobileLink = LCLink(url: entity.mobileGameUrl,
                                 imageUrl: entity.mobileGameImage,
                                 isEnabled: entity.isGamePlayable)
    }
}

/// Game Results

public struct LCGameResult: RawRepresentable, Codable, Equatable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let notPlayed = LCGameResult(rawValue: "not-played")
    public static let won = LCGameResult(rawValue: "won")
    public static let lost = LCGameResult(rawValue: "lost")
}

// MARK: - LCBannerSpaces

/// LCBannerSpace

public struct LCBannerSpace: Codable, Identifiable {
    public var id: UUID = UUID()
    public var identifier: LCBannerSpaceIdentifier
    public var bannerIds: [LCBannerIdentifier]
}

/// LCEntity

protocol LCEntity {
    associatedtype ModelEntity: Codable
    
    init(_ entity: ModelEntity)
}

/// LCBannerSpaces

public struct LCBannerSpaces: Codable, LCEntity, CustomStringConvertible {
    
    typealias ModelEntity = Model.BannerSpaces
    
    /// spaces
    ///
    /// The loaded spaces.
    
    public var spaces = [LCBannerSpaceIdentifier: LCBannerSpace]()

    /// banners
    ///
    /// The loaded banners.
    
    public var banners = [LCBannerIdentifier: LCBanner]()
    
    public var sortedSpaces: [LCBannerSpace] {
        return Array(spaces.values).sorted { lhs, rhs in
            return lhs.identifier.rawValue < rhs.identifier.rawValue
        }
    }

    public var description: String {
        
        let lines: [String] = spaces.map { key, bannerSpace in
            let bannerids = bannerSpace.bannerIds.map { "`\($0)`" }
            return "`\(key.rawValue)` : \(bannerids.joined(separator: ", "))"
        }
        return lines.joined(separator: "\r")
    }

    /// subscript by LCBannerSpaceIdentifier
    ///
    /// Allow usage of brackets on banner spaces object
    /// ```
    /// let homePageBanners = myBannerSpaces[.homepage]
    /// ```
    
    public subscript (key: LCBannerSpaceIdentifier) -> LCBannerSpace? {
        return spaces[key]
    }

    /// Init with server model object
    
    init(_ entity: ModelEntity) {
        entity.forEach { key, value in
            let spaceIdentifier = LCBannerSpaceIdentifier(key)
            spaces[spaceIdentifier] = LCBannerSpace(identifier: spaceIdentifier, bannerIds: value.map {
                LCBannerIdentifier($0)
            })
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
    
    public var identifier: LCBannerIdentifier?

    public var link: LCLink
    public var name: String
    public var campaign: String
    public var space: String
    public var action: LCBannerAction
    
    init(_ entity: Model.Banner) {
        self.link = LCLink(url: entity.redirect_url, imageUrl: entity.image_url, isEnabled: true)
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


public struct LCPostCartResponse: Codable, LCEntity {

    var ticket: String
    var mobileUrl: URL?
    var tabletUrl: URL?
    var desktopUrl: URL?
    var baseMobileUrl: URL?
    var baseTabletUrl: URL?
    var baseDesktopUrl: URL?
    
    init(_ entity: Model.PostCartResponse) {
        self.ticket = entity.ticket
        self.mobileUrl = URL(string: entity.mobileUrl)
        self.tabletUrl = URL(string: entity.tabletUrl)
        self.desktopUrl = URL(string: entity.desktopUrl)
        self.baseMobileUrl = URL(string: entity.baseMobileUrl)
        self.baseTabletUrl = URL(string: entity.baseTabletUrl)
        self.baseDesktopUrl = URL(string: entity.baseDesktopUrl)
    }
}

