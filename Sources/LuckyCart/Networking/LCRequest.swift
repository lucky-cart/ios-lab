//
//  LCRequest.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.

import Foundation

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )
///
/// Extend by adding static definitions in the LCRequest+<Request Name>.swift
///
/// Example:
/// ```
/// extension LCRequestName {
///     static let fetchThings = LCRequestName(rawValue: "fetchThings",
///                                            server: .api,
///                                            path: "things/mobile/fetch",
///                                            method: "GET")
/// }
/// ```

struct LCRequestName: RawRepresentable, Equatable, CustomStringConvertible {
    
    var rawValue: String
    
    /// The server to use for this request ( api or promomatching )
    var server: LCServer
    
    /// The resource path
    ///
    /// Full path will be generated using <server><path> + <dynamic_path><dynamic_parameters>
    var path: String = ""
    
    /// The http method to use for this request
    var method: String = "GET"
    
    var description: String { rawValue }
    
    init(rawValue: String) {
        self.server = .api
        self.path = ""
        self.method = "GET"
        self.rawValue = rawValue
    }
    
    init(rawValue: String, server: LCServer, path: String, method: String) {
        self.server = server
        self.path = path
        self.method = method
        self.rawValue = rawValue
    }
}


/// Parameters structs that are passed to request must conform to this protocol

protocol LCRequestParametersBase {
    
    func pathExtension(for request: LCRequestBase) throws -> String
    func parametersString(for request: LCRequestBase) throws -> String
}

/// LCRequestParameters
///
/// Scopes the request parameters structures.

struct LCRequestParameters {
    // Add extensions in the LCRequest+<Request Name>.swift
}

/// LCRequestResponse
///
/// Scopes all responses structures

struct LCRequestResponse: Codable {
    // Add extensions in the LCRequest+<Request Name>.swift
}

/// LCRequestBase
///
/// Request base protocol

protocol LCRequestBase {
    
    /// The request name
    ///
    /// Request name is a struct that holds:
    /// - the name ("myrequest")
    /// - the server to use ( api or promomatching )
    /// - the resource path and the method
    var name: LCRequestName { get set }
    
    /// The parameters ( parameters must be convertible to url string "?param1=_&param2=_" )
    var parameters: LCRequestParametersBase? { get set }
    
    /// The request body ( parameters must be convertible in a dictionary )
    var body: LCRequestParametersBase? { get set }
    
    /// The connection ( server/authorization ) used by this request
    var connection: LCConnection { get set }
    
    /// Returns the decoded response
    func response(data: Data) throws -> Codable
}

/// LCRequestBase
///
/// Common request functions

extension LCRequestBase {
    
    /// server
    ///
    /// Returns the server from name
    var server: LCServer { name.server }
    
    /// method
    ///
    /// Returns the request HTTP Method from name
    var method: String { name.method }
    
    /// pathPrefix
    ///
    /// Returns the request path prefix ( "<server><path_prefix>" ) if any
    /// Path prefix is the constant resource path
    var pathPrefix: String { name.path }
    
    
    /// pathExtension
    ///
    /// Returns the path starting after the server path ( "<server>/<path_extension>/" )
    func pathExtension() throws -> String {
        let out = [
            "\(name.path)",
            "\(try parameters?.pathExtension(for: self) ?? "")",
            "\(try parameters?.parametersString(for: self) ?? "")"
        ].joined()
        return out
    }
    
    /// path
    ///
    /// Returns the full path
    func path() throws -> String {
        try url().absoluteString
    }
    
    /// url
    ///
    /// Returns: The request url
    func url() throws -> URL {
        try server.buildURL(try pathExtension())
    }
    
    /// makeURLRequest
    ///
    /// Make a foundation URLRequest from LuckyCart LCRequest
    ///
    /// - Returns: a platform URLRequest
    
    func makeURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try url())
        urlRequest.httpMethod = name.method
        if let body = self.body as? LCRequestParameters.PostCart {
            urlRequest.httpBody = try body.json(for: self)
        }
        return urlRequest
    }
    
}

/// LCRequest
///
/// The Request structure, conforming to LCRequestBase
///
/// LCRequest is type constrained by the response Type.
/// This is necessary to determine the type of entity to decode with received data
internal struct LCRequest<T: Codable>: LCRequestBase {
    var connection: LCConnection
    
    var name: LCRequestName
    
    /// The parameters to encode in url
    var parameters: LCRequestParametersBase?
    
    /// The request body
    var body: LCRequestParametersBase?
    
    /// response
    ///
    /// Parse the response data
    
    func response(data: Data) throws -> Codable {
#if DEBUG
        let s = String(data: data, encoding: .utf8) ?? "<Wrong String Data - Should be .utf8>"
        print("[LuckyCart.Network] - Make `\(T.self)` response with data :\r--->\r\(s)\r<---\r")
#endif
        
        let response = try JSONDecoder().decode(T.self, from: data)
        
#if DEBUG
        print("[LuckyCart.Network] - Response :\r--->\r\(response)\r<---\r")
#endif
        return response
    }
}

extension LCNetwork {
    
    func buildRequest<T>(name: LCRequestName,
                         parameters: LCRequestParametersBase?,
                         body: LCRequestParametersBase?) throws -> LCRequest<T> {
        let connection = LCConnection(server: name.server, authorization: authorization)
        return LCRequest<T>(connection: connection, name: name, parameters: parameters, body: body)
    }
}
