//
//  File.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation
import CryptoKit

extension LuckyCart {
        
    /// postCart
    
    public func postCart(completion: @escaping (Result<LCPostCart, Error>)->Void) throws {
        
        let header = LCRequestParameters.PostCart(cartId: "\(Model.testCart.id)",
                                                  shopperId: "\(Model.testCustomer.id)",
                                                  totalAti: "123.45")
        
        let request: LCRequest<LCRequestResponse.PostCart> = try network.buildRequest(name: .postCart,
                                                                                      parameters: nil,
                                                                                      body: header)
        
        try network.run(request) { response in
            guard let response = response as? LCPostCart else {
                completion(.failure(LuckyCart.Err.wrongResponseType))
                return
            }
            completion(.success(response))
        }
    }
    
    /// getGames
    
    public func getGames(completion: @escaping (Result<[LCGame], Error>)->Void) throws {
        let request: LCRequest<Model.Games> = try network.buildRequest(name: .getGames,
                                                                       parameters: LCRequestParameters.Games(customerId: customer.id, cartId: cart.id),
                                                                       body: nil)
        
        try network.run(request) { response in
            guard let response = response as? Model.Games else {
                completion(.failure(LuckyCart.Err.wrongResponseType))
                return
            }
            let games = response.games.map { LCGame($0) }
            completion(.success(games))
        }
    }
    
    /// getBannerSpaces
    
    public func getBannerSpaces(completion: @escaping (Result<LCBannerSpaces, Error>)->Void) throws {
        let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .getBannerSpaces,
                                                                              parameters: LCRequestParameters.BannerSpaces(customerId: customer.id),
                                                                              body: nil)
        
        try network.run(request) { response in
            guard let response = response as? Model.BannerSpaces else {
                completion(.failure(LuckyCart.Err.wrongResponseType))
                return
            }
            let bannerSpaces = LCBannerSpaces(response)
            self.bannerSpaces = bannerSpaces
            completion(.success(bannerSpaces))
        }
    }
    
    /// getBanner
    
    public func getBanner(banner: String, completion: @escaping (Result<LCBanner, Error>)->Void) throws {
        let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBanner,
                                                                        parameters: LCRequestParameters.Banner(customerId: customer.id, banner: banner),
                                                                        body: nil)
        
        try network.run(request) { response in
            guard let response = response as? Model.Banner else {
                completion(.failure(LuckyCart.Err.wrongResponseType))
                return
            }
            let banner = LCBanner(response)
            completion(.success(banner))
        }
    }
    
}
