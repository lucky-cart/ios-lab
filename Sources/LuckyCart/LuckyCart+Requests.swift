//
//  LuckyCart+Requests.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 18/01/2022.
//

import Foundation

/// First version requests
///
///
internal extension LuckyCart {
    
    /// postCart
    
    func postCart(ticketComposer: LCTicketComposer, completion: @escaping (Result<LCPostCartResponse, Error>)->Void) {
        
        let body = LCRequestParameters.PostCart(ticketComposer: ticketComposer)
        do {
            let request: LCRequest<Model.PostCartResponse> = try network.buildRequest(name: .postCart,
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
    
    func getGames(reload: Bool = false, completion: @escaping (Result<[LCGame], Error>)->Void) {
        if cacheEnabled, let cachedGames = games, reload == false {
            print("[luckycart.cache] Return cached games")
            completion(Result.success(cachedGames))
            return
        }
        
        do {
            let request: LCRequest<Model.Games> = try network.buildRequest(name: .getGames,
                                                                           parameters: LCRequestParameters.Games(customerId: customer.id, cartId: cart.id),
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
    
    /// getBannerSpaces
    ///
    /// Will return cached version if available
    
    func getBannerSpaces(completion: @escaping (Result<LCBannerSpaces, Error>)->Void) {
        
        if cacheEnabled, let cachedBannerSpaces = bannerSpaces {
            print("[luckycart.cache] Return cached banner spaces")
            completion(Result.success(cachedBannerSpaces))
            return
        }
        
        do {
            let parameters = LCRequestParameters.BannerSpaces(customerId: customer.id)
            let request: LCRequest<Model.BannerSpaces> = try network.buildRequest(name: .getBannerSpaces,
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
    
    func getBanner(bannerSpaceIdentifier: LCBannerSpaceIdentifier,
                   bannerIdentifier: LCBannerIdentifier,
                   completion: @escaping (Result<LCBanner, Error>)->Void) {
        
        if cacheEnabled, let cachedBanner = bannerSpaces?.banners[bannerIdentifier] {
            print("[luckycart.cache] Return cached banner `\(bannerIdentifier)`")
            completion(Result.success(cachedBanner))
            return
        }
        
        do {
            let parameters = LCRequestParameters.Banner(customerId: customer.id, bannerSpaceId: bannerSpaceIdentifier, bannerId: bannerIdentifier)
            
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

// MARK: - Extra Requests

extension LuckyCart {

    /// Load all banners
    ///
    /// All banners definitions for a given space are loaded as soon as a banner space view is displayed
    
    private func loadAllBanners(for spaceIdentifier: LCBannerSpaceIdentifier,
                                failure: @escaping (Error)->Void,
                                success: @escaping (LCBanner)->Void) {
        loadBannerSpaces(failure: failure) { bannerSpaces in
            bannerSpaces[spaceIdentifier]?.bannerIds.forEach { identifier in
                self.getBanner(bannerSpaceIdentifier: spaceIdentifier, bannerIdentifier: identifier) { result in
                    switch result {
                    case .failure(let error):
                        self.lastError = error
                        print("[luckycart.load.banners] GetBanner(`\(identifier)`) Error:\r\(error.localizedDescription)")
                        failure(error)
                    case .success(let banner):
                        self.lastError = nil
                        print("[luckycart.load.banners] GetBanner(`\(identifier)`) succeed:\r\(banner)")
                        success(banner)
                    }
                }
            }
        }
    }
    
}
