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
    var rawValue: String { get }
}

/// LCIdentifier
///
/// A generic path style identifier helper

public extension LCIdentifier where RawValue == String {
    
    /// byAppending
    /// Append characters to the identifier
    
    func byAppending(_ string: String) -> Self {
        Self(rawValue: "\(rawValue)\(string)")!
    }
    
    /// description
    /// Returns the String representation
    var description: String {
        rawValue
    }
}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any format

public struct LCBannerIdentifier: LCIdentifier {
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}


/// LCBannerFormat
///
/// A string that is used to identify banner formats.
///
/// Client application can use any format

public struct LCBannerFormat: LCIdentifier {
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any string to define identifiers.
/// To provide more structured data, it is advised to use predefined prefixes

public struct LCBannerSpaceIdentifier: LCIdentifier {

    public let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}

/// LCBoutiqueViewIdentifier
///
/// An identifier used to identify 'boutique' views.
/// A 'boutique' view is a view that can be opened by a banner action.
///
/// This identifier is used by the app to determine which view to open when a banner is selected by the user.

public struct LCBoutiqueViewIdentifier: LCIdentifier {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ string: String) { self.init(rawValue: string) }
    public init(stringLiteral value: String) { self.init(rawValue: value) }
}

public protocol LCBoutiqueView {
    var boutiquePageIdentifier: LCBoutiqueViewIdentifier { get }
}
