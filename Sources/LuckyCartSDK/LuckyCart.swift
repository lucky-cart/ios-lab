//
//  LuckyCartSDK.swift
//
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation
import Combine

public class LuckyCart {
    
    public static let shared = LuckyCart()
    private var cancellables = Set<AnyCancellable>()

    public init() {
    }
    
    ///
    /// configuration
    ///
    /// Variable to set Lucky Cart SDK Configuration
    /// for  configurable values like siteKey, customer,  retries, retryDelay or APIs base URLs
    ///
    public let configuration: LCConfiguration = LCConfiguration.shared
    
    
    ///
    /// setSiteKey
    ///
    ///  Function to set the siteKey to identify client app for LuckyCart Services
    ///
    public func setSiteKey(_ siteKey: String?) {
        guard let siteKey = siteKey else { return }
        configuration.siteKey = siteKey
    }
    
    ///
    /// setUser
    ///
    ///  Function to set the customer/client to identify your current user for LuckyCart Services
    ///
    public func setUser(_ customer: String?) {
        guard let customer = customer else{ return }
        configuration.customer = customer
    }
    
    public func setPollingConfiguration(retryAfter: Double = 0.5,
                                        maxAttempts: Int = 5) {
        configuration.apiRetries = maxAttempts
        configuration.apiRetryDelay = retryAfter
    }
    
    ///
    /// sendShopperEvent
    ///
    /// Function with completion use to send an event to Lucky Cart
    ///
    public func sendShopperEvent(eventName: LCEventName,
                                 payload: LCEventPayload?,
                                 completion: @escaping (Bool?) -> Void) {
        
        guard let siteKey = LCConfiguration.shared.siteKey else {
            print("LUCKY CART :: ERROR :: NO SITEKEY")
            return
        }
        
        guard let url = URL(string: "\(LCConfiguration.shared.eventBaseUrl)/event") else {
            print("LUCKY CART :: ERROR :: BAD EVENT API URL")
            return
        }
        
        print("LUCKY CART :: \(url)")
        let eventModel = LCEventModel(shopperId: LCConfiguration.shared.customer ?? "unknown",
                                   siteKey: siteKey,
                                   eventName: eventName,
                                   payload: payload)
        let body = try? JSONEncoder().encode(eventModel)
        let requestModel = LCRequestModel(url: url,
                                          method: .post,
                                          body: body)
        
        LCRequestManager<Bool>.shared.request(with: requestModel)
            .sink { completions in
                switch completions {
                case .finished:
                    break
                case .failure(let error):
                    print("LUCKY CART :: ERROR :: \(error)")
                }
            } receiveValue: { isSended in
                print("LUCKY CART :: EVENT \(eventName) SENDED WITH SUCCESS")
                completion(isSended)
            }
            .store(in: &cancellables)
        
    }
    
    ///
    /// getBannersExperience
    ///
    /// Function with completion to get a list of Banner Experiences to show on your page
    ///
    public func getBannersExperience(pageType: String,
                                     format: String,
                                     platform: String? = "mobile",
                                     pageId: String? = .none,
                                     store: String? = .none,
                                     storeType: String? = .none,
                                     completion: @escaping ([LCBannerExperience]?)->Void) {
        
        getBannersExperience(pageType: pageType,
                             format: format,
                             platform: platform,
                             pageId: pageId,
                             store: store,
                             storeType: storeType,
                             retries: LCConfiguration.shared.apiRetries,
                             completion: completion)
    }
    
    ///
    /// getBannerExperienceDetail
    ///
    /// Function with completion to get a single Banner Experience to show on your page
    ///
    public func getBannerExperienceDetail(pageType: String,
                                          format: String,
                                          platform: String? = "mobile",
                                          pageId: String? = .none,
                                          store: String? = .none,
                                          storeType: String? = .none,
                                          completion: @escaping (LCBannerExperience?)->Void) {
        
        
        getBannerExperienceDetail(pageType: pageType,
                                  format: format,
                                  platform: platform,
                                  pageId: pageId,
                                  store: store,
                                  storeType: storeType,
                                  retries: LCConfiguration.shared.apiRetries,
                                  completion: completion)
    }
    
    ///
    /// getBannersExperience
    ///
    /// Function with completion to get some Game Experiences
    ///
    public func getGamesAccess(count: Int? = 1,
                               filters: LCGameFilter,
                               completion: @escaping ([LCGamesExperience]?)->Void) {
        
        getGamesAccess(count: count,
                       filters: filters,
                       retries: LCConfiguration.shared.apiRetries,
                       completion: completion)
    }
}

extension LuckyCart {
    
    private func getBannersExperience(pageType: String,
                                     format: String,
                                     platform: String? = "mobile",
                                     pageId: String? = .none,
                                     store: String? = .none,
                                     storeType: String? = .none,
                                     retries: Int,
                                     completion: @escaping ([LCBannerExperience]?)->Void) {
        guard let siteKey = LCConfiguration.shared.siteKey else {
            print("LUCKY CART :: ERROR :: NO SITEKEY")
            return
        }
        
        
        if retries > 0 {
            let urlString = "\(LCConfiguration.shared.displayerBaseUrl)/\(siteKey)/\(LCConfiguration.shared.customer ?? "unknown")/banners/\(platform ?? "mobile")/\(pageType)/\(format)"
            var urlComponent = URLComponents(string: urlString)
            if let pageId = pageId {
                urlComponent?.queryItems?.append(URLQueryItem(name: "pageId",
                                                              value: pageId))
            }
            if let store = store {
                urlComponent?.queryItems?.append(URLQueryItem(name: "store",
                                                              value: store))
            }
            if let storeType = storeType {
                urlComponent?.queryItems?.append(URLQueryItem(name: "store_type",
                                                              value: storeType))
            }
            print("LUCKY CART :: \(String(describing: urlComponent))")
            guard let url = urlComponent?.url else {
                print("LUCKY CART :: ERROR :: BAD DISPLAYER API URL")
                return
            }
            
            let requestModel = LCRequestModel(url: url,
                                              method: .get,
                                              body: nil)
            
            LCRequestManager<LCBannerModel>.shared.request(with: requestModel)
                .sink { completions in
                    switch completions {
                    case .finished:
                        break
                    case .failure(let error):
                        print("LUCKY CART :: ERROR :: \(error)")
                    }
                } receiveValue: { [weak self] bannerModel in
                    print("LUCKY CART :: GET BANNERS RESPONSE :: \(String(describing: bannerModel.bannerList))")
                    if bannerModel.bannerList?.count ?? 0 > 0 {
                        completion(bannerModel.bannerList)
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + LCConfiguration.shared.apiRetryDelay) {
                            self?.getBannersExperience(pageType: pageType,
                                                       format: format,
                                                       platform: platform,
                                                       pageId: pageId,
                                                       store: store,
                                                       storeType: storeType,
                                                       retries: (retries - 1),
                                                       completion: completion)
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func getBannerExperienceDetail(pageType: String,
                                          format: String,
                                          platform: String? = "mobile",
                                          pageId: String? = .none,
                                          store: String? = .none,
                                          storeType: String? = .none,
                                          retries: Int,
                                          completion: @escaping (LCBannerExperience?)->Void) {
        
        guard let siteKey = LCConfiguration.shared.siteKey else {
            print("LUCKY CART :: ERROR :: NO SITEKEY")
            return
        }
        
        if retries > 0 {
            let urlString = "\(LCConfiguration.shared.displayerBaseUrl)/\(siteKey)/\(LCConfiguration.shared.customer ?? "unknown")/banner/\(platform ?? "mobile")/\(pageType)/\(format)"
            var urlComponent = URLComponents(string: urlString)
            var queryItems: [URLQueryItem] = []
            if let pageId = pageId {
                queryItems.append(URLQueryItem(name: "pageId",
                                               value: pageId))
            }
            if let store = store {
                queryItems.append(URLQueryItem(name: "store",
                                               value: store))
            }
            if let storeType = storeType {
                queryItems.append(URLQueryItem(name: "store_type",
                                               value: storeType))
            }
            urlComponent?.queryItems = queryItems
            print("LUCKY CART :: \(String(describing: urlComponent?.url))")
            guard let url = urlComponent?.url else {
                print("LUCKY CART :: ERROR :: BAD DISPLAYER API URL")
                return
            }
            
            let requestModel = LCRequestModel(url: url,
                                              method: .get,
                                              body: nil)
            
            LCRequestManager<LCBannerModel>.shared.request(with: requestModel)
                .sink { completions in
                    switch completions {
                    case .finished:
                        break
                    case .failure(let error):
                        print("LUCKY CART :: ERROR :: \(error)")
                    }
                } receiveValue: { [weak self] bannerModel in
                    print("LUCKY CART :: GET BANNER RESPONSE :: \(String(describing: bannerModel.banner))")
                        if let banner = bannerModel.banner {
                            completion(banner)
                        }
                        else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + LCConfiguration.shared.apiRetryDelay) {
                                self?.getBannerExperienceDetail(pageType: pageType,
                                                                format: format,
                                                                platform: platform,
                                                                pageId: pageId,
                                                                store: store,
                                                                storeType: storeType,
                                                                retries: (retries - 1),
                                                                completion: completion)
                            }
                        }
                }
                .store(in: &cancellables)
        }
    }
    
    private func getGamesAccess(count: Int? = 1,
                               filters: LCGameFilter,
                               retries: Int,
                               completion: @escaping ([LCGamesExperience]?)->Void) {
        
        guard let siteKey = LCConfiguration.shared.siteKey else {
            print("LUCKY CART :: ERROR :: NO SITEKEY")
            return
        }
        
        if retries > 0 {
            
            let urlString = "\(LCConfiguration.shared.gameBaseUrl)/game-experiences-access"
            var urlComponent = URLComponents(string: urlString)
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "shopperId",
                                           value: LCConfiguration.shared.customer ?? "unknown"))
            queryItems.append(URLQueryItem(name: "siteKey",
                                           value: siteKey))
            queryItems.append(URLQueryItem(name: "count",
                                           value: String(count ?? 1)))
            urlComponent?.queryItems = queryItems
            print("LUCKY CART :: \(String(describing: urlComponent?.url))")
            guard let url = urlComponent?.url else {
                print("LUCKY CART :: ERROR :: BAD GAME EXPERIENCE API URL")
                return
            }
            
            let body = try? JSONEncoder().encode(filters)
            let requestModel = LCRequestModel(url: url,
                                              method: .post,
                                              body: body)
            
            LCRequestManager<[LCGamesExperience]>.shared.requestWithRetry(with: requestModel)
                .sink { completions in
                    switch completions {
                    case .finished:
                        break
                    case .failure(let error):
                        print("LUCKY CART :: ERROR :: \(error)")
                    }
                } receiveValue: { [weak self] gamesExperiences in
                    print("LUCKY CART :: GET GAMES EXPERIENCES RESPONSE :: \(String(describing: gamesExperiences))")
                    
                    if gamesExperiences.count > 0 {
                        completion(gamesExperiences)
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + LCConfiguration.shared.apiRetryDelay) {
                            self?.getGamesAccess(count: count,
                                                 filters: filters,
                                                 retries: (retries - 1),
                                                 completion: completion)
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
}
