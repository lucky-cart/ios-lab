
//
// LuckyCart.swift
//
// LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Combine

/// LuckyCart API
///
/// The framework facade exposing public Lucky Cart APIs

public class LuckyCart: ObservableObject {
    public static var shared: LuckyCart!
    
    /// Err
    ///
    /// A struct containaing all LuckyCart exceptions
    
    public struct Err: RawRepresentable, Error {
        public var rawValue: String
        
        public  init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        static let cantFormURL = Err(rawValue: "cantFormURL")
        static let unknownRequestName = Err(rawValue: "unknownRequestName")
        static let wrongResponseType = Err(rawValue: "wrongResponseType")
        static let cantCastDataToResponseType = Err(rawValue: "cantCastDataToResponseType")
        static let emptyResponse = Err(rawValue: "emptyResponse")
        static let authKeyMissing = Err(rawValue: "authKeyMissing")
        static let authorizationMissing = Err(rawValue: "authorizationMissing")
        
        static let ticketComposerKeyAlreadyPresent = Err(rawValue: "ticketComposer.keyAlreadyPresent")

    }

    /// network
    ///
    /// The Network object that manages the session
    ///
    /// Network is created in init with passed authorization
    
    let network: LCNetwork
    
    /// customer: The LuckyCart customer
    var customer: LCCustomer
    
    /// customer: The LuckyCart cart
    var cart: LCCart
    
    /// Banner Spaces Cache
    var bannerSpaces: LCBannerSpaces?
    
    /// Games Cache
    var games: [LCGame]?

    public var ticketComposer: LCTicketComposer?        // Generates the ticket that will be sent to LuckyCart
    // Fill the structures with your information here
    
    public init(authorization: LCAuthorization,
                customer: LCCustomer,
                cart: LCCart) {
        if LuckyCart.shared != nil {
            fatalError("LuckyCart already initialized")
        }
        self.customer = customer
        self.cart = cart
        self.network = LCNetwork(authorization: authorization)
        LuckyCart.shared = self
    }
}
