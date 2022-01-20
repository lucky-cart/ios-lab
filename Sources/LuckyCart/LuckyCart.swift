
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
    
    @Published public var lastError: Error?
    
    /// customer: The LuckyCart customer
    ///
    /// if customer is nil, a lucky cart guest customer will be used in requests
    
    @Published public private(set) var customer: LCCustomer
    
    /// cart
    ///
    /// The LuckyCart cart
    
    @Published var cart: LCCart
    
    @Published var lastCheckOutResponse: LCPostCartResponse?
    
    /// Banner Spaces Cache
    @Published var bannerSpaces: LCBannerSpaces?
    
    /// Games Cache
    @Published var games: [LCGame]?

    public var ticketComposer: LCTicketComposer?        // Generates the ticket that will be sent to LuckyCart
    // Fill the structures with your information here
    
    /// Initialize the framework
    ///
    /// - parameter authorization: The auth_key/secret pair needed to authorize api requests
    /// - parameter customer: If customer is nil, then a guest customer is used ( id = 'unknown' )
    /// - parameter cart: Pass a cart id, if cart id is nil then a new cart id is created with standard uuid
    
    public init(authorization: LCAuthorization,
                customer: LCCustomer? = nil,
                cart: LCCart? = nil) {
        if LuckyCart.shared != nil {
            fatalError("LuckyCart already initialized")
        }
        self.customer = customer ?? LCCustomer.guest
        self.cart = cart ?? LCCart()
        self.network = LCNetwork(authorization: authorization)
        LuckyCart.shared = self
    }
    
    /// Set current user
    
    func setUser(_ user: LCCustomer?) {
        customer = user ?? LCCustomer.guest
    }
    
    func setGuestUser() {
        customer = LCCustomer.guest
    }
}
