//
//  LuckyCart+Requests.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import Foundation

/// The requests on client side.
///
/// These functions calls the private requests, and transform the results from server model to client model.
/// They should not be called from the app.
///
/// The final public API to be used by client app is provided in the file `LuckyCart+Facade`.

internal extension LuckyCart {
    
    /// sendCart
    
    func sendCart(cartId: String, ticketComposer: LCTicketComposer, completion: @escaping (Result<LCPostCartResponse, Error>)->Void) {
        
        let body = LCRequestParameters.SendCart(customerId: customer.id,
                                                cartId: cartId,
                                                ticketComposer:  ticketComposer)
        do {
            let request: LCRequest<Model.PostCartResponse> = try network.buildRequest(name: .sendCart,
                                                                                      parameters: nil,
                                                                                      body: body)
            try network.run(request) { response in
                switch response {
                case .success(let result):
                    self.lastError = nil
                    completion(.success(LCPostCartResponse(result)))
                case .failure(let error):
                    self.lastError = error
                    completion(.failure(error))
                }
            }
        }
        catch {
            self.lastError = error
            completion(.failure(error))
        }
    }
    
    /// getGames
    ///
    /// Will return cached version if available
    
    func getGames(cartId: String, reload: Bool = false, completion: @escaping (Result<[LCGame], Error>)->Void) {
        if cacheEnabled, let cachedGames = games, reload == false {
            print("[luckycart.cache] Return cached games")
            completion(Result.success(cachedGames))
            return
        }
        
        do {
            let request: LCRequest<Model.Games> = try network.buildRequest(name: .getGames,
                                                                           parameters: LCRequestParameters.Games(customerId: customer.id, cartId: cartId),
                                                                           body: nil)
            try network.run(request) { response in
                switch response {
                case .success(let result):
                    let games = result.games.map { LCGame($0) }
                    // Cache available games
                    self.lastError = nil
                    self.games = games
                    completion(.success(games))
                case .failure(let error):
                    self.lastError = error
                    completion(.failure(error))
                }
            }
        }
        catch {
            self.lastError = error
            completion(.failure(error))
        }
    }
    
    /// ListAvailableBanners
    ///
    /// Will return cached version if available
    
    func ListAvailableBanners(completion: @escaping (Result<LCBannerSpaces, Error>)->Void) {
        
        if cacheEnabled, let cachedBannerSpaces = bannerSpaces {
            print("[luckycart.cache] Return cached banner spaces")
            completion(Result.success(cachedBannerSpaces))
            return
        }
        
        do {
            let parameters = LCRequestParameters.BannerSpaces(customerId: customer.id)
            let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .ListAvailableBanners,
                                                                                  parameters: parameters,
                                                                                  body: nil)
            
            try network.run(request) { response in
                switch response {
                case .success(let result):
                    let bannerSpaces = LCBannerSpaces(result)
                    self.lastError = nil
                    self.bannerSpaces = bannerSpaces
                    completion(.success(bannerSpaces))
                case .failure(let error):
                    self.lastError = error
                    completion(.failure(error))
                }
            }
        }
        catch {
            self.lastError = error
            completion(.failure(error))
        }
        
    }
    
    /// getBanner
    ///
    /// Will return cached version if available
    
    func getBanner(bannerSpaceIdentifier: String,
                   bannerIdentifier: String,
                   format: String,
                   completion: @escaping (Result<LCBanner, Error>)->Void) {
        
        if cacheEnabled, let cachedBanner = bannerSpaces?.banners[bannerIdentifier] {
            print("[luckycart.cache] Return cached banner `\(bannerIdentifier)`")
            completion(Result.success(cachedBanner))
            return
        }
        
        do {
            let parameters = LCRequestParameters.Banner(customerId: customer.id,
                                                        bannerSpaceId: bannerSpaceIdentifier,
                                                        bannerId: bannerIdentifier,
                                                        format: format)
            
            let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBanner,
                                                                            parameters: parameters,
                                                                            body: nil)
            
            try network.run(request) { response in
                switch response {
                case .success(let result):
                    var banner = LCBanner(result)
                    // Identifier is not returned by server, so we set the identifier here
                    banner.identifier = bannerIdentifier
                    self.lastError = nil
                    
                    // Cache the result
                    self.bannerSpaces?.banners[bannerIdentifier] = banner
                    completion(.success(banner))
                case .failure(let error):
                    self.lastError = error
                    completion(.failure(error))
                }
            }
        }
        catch {
            self.lastError = error
            completion(.failure(error))
        }
    }
    
    /// getImage
    ///
    /// Will return cached version if available
    
    func getImage(url: URL, completion: @escaping (Result<LCImage, Error>)->Void) {
        
        if let cachedImage = images[url] {
            print("[luckyCart.getImage] - Returns cached image")
            completion(.success(cachedImage))
            return
        }
        do {
            try network.downloadData(url: url) { response in
                switch response {
                case .success(let data):
                    guard let image = LCImage(data: data) else {
                        completion(.failure(LuckyCart.Err.cantCreateImageWithDownloadedData))
                        return
                    }
                    self.lastError = nil
                    // Cache the result
                    self.images[url] = image
                    completion(.success(image))
                case .failure(let error):
                    self.lastError = error
                    completion(.failure(error))
                }
            }
        }
        catch {
            completion(.failure(error))
        }
    }
}
