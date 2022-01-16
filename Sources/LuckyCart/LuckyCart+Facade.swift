//
//  LuckyCart+Facade.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation
import CryptoKit

/// LuckyCart Facade Requests
///
/// Public request calls.
///
/// When request is called, the private request is called, then the result is casted to client model, and finally cached

extension LuckyCart {
    
    /// postCart
    
    public func postCart(completion: @escaping (Result<LCPostCart, Error>)->Void) throws {
        
        let header = LCRequestParameters.PostCart(cartId: "\(Model.testCart.id)",
                                                  shopperId: "\(Model.testCustomer.id)",
                                                  totalAti: "123.45",
                                                  ticketComposer: ticketComposerClosure())
        
        let request: LCRequest<LCRequestResponse.PostCart> = try network.buildRequest(name: .postCart,
                                                                                      parameters: nil,
                                                                                      body: header)
        
        try network.run(request) { response in
            switch response {
            case .success(let result):
                completion(.success(LCPostCart(result)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// getGames
    
    public func getGames(completion: @escaping (Result<[LCGame], Error>)->Void) throws {
        
        if let cachedGames = games {
            print("[luckycart.cache] Return cached games")
            completion(Result.success(cachedGames))
            return
        }
        
        let request: LCRequest<Model.Games> = try network.buildRequest(name: .getGames,
                                                                       parameters: LCRequestParameters.Games(customerId: customer.id, cartId: cart.id),
                                                                       body: nil)
        
        try network.run(request) { response in
            switch response {
            case .success(let result):
                let games = result.games.map { LCGame($0) }
                // Cache available games
                self.games = games
                completion(.success(games))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// getBannerSpaces
    
    public func getBannerSpaces(completion: @escaping (Result<LCBannerSpaces, Error>)->Void) throws {
        
        if let cachedBannerSpaces = bannerSpaces {
            print("[luckycart.cache] Return cached banner spaces")
            completion(Result.success(cachedBannerSpaces))
            return
        }
        
        let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .getBannerSpaces,
                                                                              parameters: LCRequestParameters.BannerSpaces(customerId: customer.id),
                                                                              body: nil)
        
        try network.run(request) { response in
            switch response {
            case .success(let result):
                let bannerSpaces = LCBannerSpaces(result)
                self.bannerSpaces = bannerSpaces
                completion(.success(bannerSpaces))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// getBanner
    
    public func getBanner(bannerIdentifier: LCBannerIdentifier, completion: @escaping (Result<LCBanner, Error>)->Void) throws {
        
        if let cachedBanner = bannerSpaces?.banners[bannerIdentifier] {
            print("[luckycart.cache] Return cached banner `\(bannerIdentifier)`")
            completion(Result.success(cachedBanner))
            return
        }
        
        let request: LCRequest<Model.Banner>
        = try network.buildRequest(name: .getBanner,
                                   parameters: LCRequestParameters.Banner(customerId: customer.id,
                                                                          banner: bannerIdentifier),
                                   body: nil)
        
        try network.run(request) { response in
            
            switch response {
            case .success(let result):
                var banner = LCBanner(result)
                // Identifier is not returned by server, so we set the identifier here
                banner.identifier = bannerIdentifier
                // Cache the result
                self.bannerSpaces?.banners[bannerIdentifier] = banner
                completion(.success(banner))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
