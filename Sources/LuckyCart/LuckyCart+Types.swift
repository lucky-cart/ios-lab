//
//  LuckyCart+Types.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 15/01/2022.
//

import Foundation

/// LuckyCart object identifiers

public protocol LCIdentifier : RawRepresentable, Codable, Hashable, CustomStringConvertible, ExpressibleByStringLiteral {
    
    static var identifier: String { get }
    
    var rawValue: String { get }
    
}

/// LCIdentifier
///
/// A generic path style identifier helper

public extension LCIdentifier where RawValue == String {
    
    /// byAppending
    /// Append characters to the identifier
    
    func byAppending(_ string: String) -> Self {
        Self(rawValue: "\(rawValue)\(Self.transform(string))")!
    }
    
    /// byAppendingComponent
    /// Append a new path extension to the identifier ( separate by .)

    func byAppendingComponent(_ string: String) -> Self {
        Self(rawValue: "\(rawValue).\(Self.transform(string))")!
    }
    
    /// description
    /// Returns the String representation
    var description: String {
        rawValue
    }
    
    var path: String {
        return Self.identifier + rawValue
    }
    
    /// Returns a lowercased string and replace spaces by underscores
    static func transform(_ string: String) -> String {
        string.lowercased().replacingOccurrences(of: " ", with: "_")
    }

}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any format

public struct LCBannerIdentifier: LCIdentifier {
    
    public static let identifier: String = "banner"
    
    public let rawValue: String

    /// Create a new identifier
    ///
    /// If the passed string is "Product 5314", the identifier will be `product_5314`
    ///
    /// ```
    /// print(LCBannerIdentifier.productDetail.byAppending("_100"))
    ///
    /// // result identifier = "product.detail.product_5314"
    /// ```
    
    public init(rawValue: String) {
        self.rawValue = Self.transform(rawValue)
    }
    
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }

    /// The identifier to use for a generic identifier
    
    public static let banner = LCBannerIdentifier(rawValue: "banner")
}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any string to define identifiers.
/// To provide more structured data, it is advised to use predefined prefixes

public struct LCBannerSpaceIdentifier: LCIdentifier {
    
    public static let identifier: String = "bannerspace"

    public let rawValue: String

    /// Returns a lowercased string and replace spaces by underscores
    static public func transform(_ string: String) -> String {
        string.lowercased().replacingOccurrences(of: " ", with: "_")
    }
        
    /// Create a new identifier
    ///
    /// If the passed string is "Product 5314", the identifier will be `product_5314`
    ///
    /// ```
    /// print(LCBannerSpaceIdentifier.productDetail.byAppending("Product 5314"))
    ///
    /// // result identifier = "product.detail.product_5314"
    /// ```
    
    public init(rawValue: String) {
        self.rawValue = Self.transform(rawValue)
    }
    
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }

    /// Some pre-defined spaces identifier
    
    /// The identifier to use for the application homepage
    public static let homePage = LCBannerSpaceIdentifier(rawValue: "homepage")
    
    /// The identifier to use for a categories browser
    public static let categories = LCBannerSpaceIdentifier(rawValue: "categories")
    
    /// The identifier to use for a categories browser
    public static let categoryDetail = LCBannerSpaceIdentifier(rawValue: "category.detail")
    
    /// The identifier to use for a products browser
    public static let products = LCBannerSpaceIdentifier(rawValue: "product.browser")
    
    /// The identifier to use for a product detail view
    public static let productDetail = LCBannerSpaceIdentifier(rawValue: "product.detail")
    
    /// The identifier to use for a brands browser
    public static let brands = LCBannerSpaceIdentifier(rawValue: "brand.browser")
    
    /// The identifier to use for a brand detail view
    
    public static let brandDetail = LCBannerSpaceIdentifier(rawValue: "brand.detail")
    
    /// The identifier to use for a generic identifier
    
    public static let generic = LCBannerSpaceIdentifier(rawValue: "generic")
    
    /// The identifier to use for a generic browser
    
    public static let browser = LCBannerSpaceIdentifier(rawValue: "generic.browser")

    /// The identifier to use for a generic detail
    
    public static let detail = LCBannerSpaceIdentifier(rawValue: "generic.detail")

    /// The identifier to use for an advert view
    
    public static let advert = LCBannerSpaceIdentifier(rawValue: "advert")
}

/// LCBoutiqueViewIdentifier
///
/// An identifier used to identify 'boutique' views.
/// A 'boutique' view is a view that can be opened by a banner action.
///
/// This identifier is used by the app to determine which view to open when a banner is selected by the user.

public struct LCBoutiqueViewIdentifier: LCIdentifier {
    public static var identifier: String = "view"
    
    public let rawValue: String

        
    /// Create a new identifier
    ///
    /// If the passed string is "Coffee Offers", the identifier will be `coffee_offers`
    ///
    /// ```
    /// print(LCViewIdentifier.boutique.byAppending("Coffee Offers"))
    ///
    /// // result identifier = "boutique.coffee_offers"
    /// ```
    
    public init(rawValue: String) {
        self.rawValue = Self.transform(rawValue)
    }
    
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }

    public static let homepage = LCBoutiqueViewIdentifier(rawValue: "homepage")
    
    public static let categories = LCBoutiqueViewIdentifier(rawValue: "categories")
    
    public static let boutique = LCBoutiqueViewIdentifier(rawValue: "boutique")

}

public protocol LCBoutiqueView {
    var boutiquePageIdentifier: LCBoutiqueViewIdentifier { get }
}
