//
//  LCNetwork.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.

import Foundation

/// LCNetwork
///
/// The LuckyCart network layer
///
/// The network layer manage a LuckyCart networking session

internal class LCNetwork {
    
    var authorization: LCAuthorization
    
    lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    init(authorization: LCAuthorization) {
        self.authorization = authorization
    }
    
    // MARK: - Run Requests
    
    /// run
    ///
    /// Runs the request.
    ///
    /// Completion is called with the decoded server model object, or the error if any occured.
    
    func run<T>(_ request: LCRequest<T>, completion: @escaping (Result<T, Error>)->Void) throws {
        
        print("[luckycart.network] - Run [\(request.method)] \(try request.url().absoluteString)")
        let urlRequest = try request.makeURLRequest()
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(LuckyCart.Err.emptyResponse))
                }
                return
            }
            
            do {
                guard let castedData = try request.response(data: data) as? T else {
                    DispatchQueue.main.async {
                        completion(.failure(LuckyCart.Err.cantCastDataToResponseType))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(castedData))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    /// downloadData
    ///
    /// Fetch data asynchronously.
    /// This is used to download banners imaga data.
    
    func downloadData(url: URL, completion: @escaping (Result<Data, Error>)->Void) throws {
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(LuckyCart.Err.emptyResponse))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
