//
//  LCServer.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import Foundation

/// LCServer
///
/// The different servers that can be accessed from client are declared as static.
/// - api : https://api.luckycart.com
/// - promoMatching : https://promomatching.luckycart.com

struct LCServer: RawRepresentable {
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let any = LCServer(rawValue: "")
    
    static let api = LCServer(rawValue: "https://api.luckycart.com/")
    
    static let promo = LCServer(rawValue: "https://promomatching.luckycart.com/")
    
    func url() throws -> URL {
        guard let url = URL(string: self.rawValue) else {
            throw LuckyCart.Err.cantFormURL
        }
        return url
    }
    
    func buildURL(_ path: String) throws -> URL {
        guard let url = URL(string: "\(try url().absoluteString)\(path)") else {
            throw LuckyCart.Err.cantFormURL
        }
        return url
    }
}

/// LCConnection
///
/// Associates a server and an authorization.
/// LCConnection is then associated to `LCRequest` objects to finalize it
/// - compose final path using server url
/// - authorize request

class LCConnection {
    var server: LCServer
    var authorization: LCAuthorization?
    
    init(server: LCServer, authorization: LCAuthorization?) {
        self.authorization = authorization
        self.server = server
    }
    
    func authorize(_ authorization: LCAuthorization?) {
        self.authorization = authorization
    }
    
    static func api(authorization: LCAuthorization) -> LCConnection {
        return LCConnection(server: .api, authorization: authorization)
    }
    
    static func promo(authorization: LCAuthorization) -> LCConnection {
        return LCConnection(server: .promo, authorization: authorization)
    }
    
    /// Creates a new unauthorized connection to any url.
    ///
    /// This type of connection is used to download images or other resources
    static func any(authorization: LCAuthorization? = nil) -> LCConnection {
        return LCConnection(server: .any, authorization: nil)
    }
}
