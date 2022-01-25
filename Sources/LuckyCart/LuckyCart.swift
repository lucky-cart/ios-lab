
//
//  LuckyCart.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Combine
import Foundation


/// Make your app/manager/controller object conform to this protocol to use LuckyCart

public protocol LuckyCartClient {
    
    /// Starts the LuckyCart framework
    func initLuckyCart()
    
    /// Generates the information needed by LuckyCart when checking out
    func luckyCartTicket(cartId: String) throws -> LCTicketComposer
}

/// LuckyCart API
///
/// The framework facade exposing public Lucky Cart APIs

public class LuckyCart: ObservableObject {
    
    public static var shared: LuckyCart!
    
    public var cacheEnabled: Bool = false
    
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

        static let customerIdMissing = Err(rawValue: "customerIdMissing")
        static let cartIdMissing = Err(rawValue: "cartIdMissing")

        static let ticketComposerKeyAlreadyPresent = Err(rawValue: "ticketComposer.keyAlreadyPresent")
        static let ticketComposerCustomerIdDoesNotMatchRequestCustomerId
        = Err(rawValue: "ticketComposer.customerIdDoesNotMatchRequestCustomerId")
        static let ticketComposerCartIdDoesNotMatchRequestCartId
        = Err(rawValue: "ticketComposer.cartIdDoesNotMatchRequestCartId")

        static let cantCreateImageWithDownloadedData = Err(rawValue: "cantCreateImageWithDownloadedData")
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
    
    @Published var cart: LCCart = LCCart()
    
    @Published var lastCheckOutResponse: LCPostCartResponse?
    
    /// Banner Spaces Cache
    @Published public internal(set) var bannerSpaces: LCBannerSpaces?
    
    /// Games Cache
    ///
    /// Value is published to trigger updates when games are reloaded ( to update game results )
    @Published public internal(set) var games: [LCGame]?

    /// Images Cache
    public var images: [URL: LCImage] = [:]
    
    // Fill the structures with your information here
    
    /// Initialize the framework
    ///
    /// - parameter authorization: The auth_key/secret pair needed to authorize api requests
    /// - parameter customer: If customer is nil, then a guest customer is used ( id = 'unknown' )
    /// - parameter cart: Pass a cart id, if cart id is nil then a new cart id is created with standard uuid
    
    @discardableResult
    public init(authorization: LCAuthorization,
                customer: LCCustomer? = nil) {
        if LuckyCart.shared != nil {
            fatalError("LuckyCart already initialized")
        }
        self.customer = customer ?? LCCustomer.guest
        self.network = LCNetwork(authorization: authorization)
        LuckyCart.shared = self
        
    }

    /// Opens a new cart
    
    public func newCart(with id: String = UUID().uuidString) {
        clearCache()
        self.cart = LCCart(id: id)
    }

    /// Set current user

    public func setUser(_ user: LCCustomer?) {
        clearCache()
        customer = user ?? LCCustomer.guest
        newCart()
    }
    
    /// Switch to guest user
    
    public func setGuestUser() {
        setUser(nil)
    }
    
    /// clearCache
    ///
    /// Clears all the bannerSpaces and games
    
    func clearCache() {
        self.bannerSpaces = nil
        self.games = nil
    }
    /// clearImagesCache
    ///
    /// Clears all the banner images
    
    func clearImagesCache() {
        self.images = [:]
    }
}
