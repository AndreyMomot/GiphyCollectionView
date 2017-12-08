//
//  GPHAbstractClient.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation


/// GIPHY Abstract API Client.
///
@objc public class GPHAbstractClient : NSObject {
    // MARK: Properties
    
    /// Giphy API key.
    @objc var _apiKey: String?

    /// Session
    var session: URLSession
    
    /// Default timeout for network requests. Default: 10 seconds.
    @objc public var timeout: TimeInterval = 10
    
    /// Operation queue used to keep track of network requests.
    let requestQueue: OperationQueue
    
    /// Maximum number of concurrent requests we allow per connection.
    private let maxConcurrentRequestsPerConnection = 4
    
    #if !os(watchOS)
    
    /// Network reachability detecter.
    var reachability: GPHNetworkReachability = GPHNetworkReachability()
    
    /// Network reachability status. Not supported in watchOS.
    @objc public var useReachability: Bool = true
    
    #endif
    
    // MARK: Initialization
    
    /// Initializer
    ///
    /// - parameter apiKey: Application api-key to access GIPHY endpoints.
    ///
    init(_ apiKey: String?) {
        self._apiKey = apiKey

        var clientHTTPHeaders: [String: String] = [:]
        clientHTTPHeaders["User-Agent"] = GPHAbstractClient.defaultUserAgent()
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = clientHTTPHeaders
        
        session = Foundation.URLSession(configuration: configuration)
        
        requestQueue = OperationQueue()
        requestQueue.name = "Giphy API Requests"
        requestQueue.maxConcurrentOperationCount = configuration.httpMaximumConnectionsPerHost * maxConcurrentRequestsPerConnection
        
        super.init()
    }
    
    // MARK: Request Methods and Helpers
    
    /// User-agent to be used per client
    ///
    /// - returns: Default User-Agent for the SDK
    ///
    private static func defaultUserAgent() -> String {
        
        guard
            let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String
            else { return "Giphy SDK (iOS)" }
        return "Giphy SDK v\(version) (iOS)"
    }
    
    
    /// Encode Strings for appending to URLs for endpoints like Term Suggestions/Categories
    ///
    /// - parameter string: String to be encoded.
    /// - returns: A cancellable operation.
    ///
    @objc
    func encodedStringForUrl(_ string: String) -> String {
        
        guard
            let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return string }
        return encoded
    }

    
    /// Perform a request
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func httpRequest(with request: URLRequest, type: GPHRequestType, completionHandler: @escaping GPHJSONCompletionHandler) -> Operation {
        
        let operation = GPHRequest(self, request: request, type: type, completionHandler: completionHandler)
        self.requestQueue.addOperation(operation)
        
        return operation
    }
    

    /// Perform a request to get a single result
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func getRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
        
        return self.httpRequest(with: request,
                                type: type,
                                completionHandler: GPHAbstractClient.parseJSONResponse(type: type,
                                                                                       media: media,
                                                                                       completionHandler: completionHandler))

    }
    
    
    /// Perform a request to get a list of results
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {

        return self.httpRequest(with: request,
                                type: type,
                                completionHandler: GPHAbstractClient.parseJSONResponse(type: type,
                                                                                       media: media,
                                                                                       completionHandler: completionHandler))
    }
    
    /// Perform a request to get a list of term suggestions
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listTermSuggestionsRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListTermSuggestionResponse>) -> Operation {
        
        return self.httpRequest(with: request,
                                type: type,
                                completionHandler: GPHAbstractClient.parseJSONResponse(type: type,
                                                                                       media: media,
                                                                                       completionHandler: completionHandler))
    }

    /// Perform a request to get a list of categories
    ///
    /// - parameter root: GPHCategory for which to obtain subcategories, or nil.
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listCategoriesRequest(_ root: GPHCategory? = nil, with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        return self.httpRequest(with: request,
                                type: type,
                                completionHandler: GPHAbstractClient.parseJSONResponse(root: root,
                                                                                       type: type,
                                                                                       media: media,
                                                                                       completionHandler: completionHandler))
    }
    
    /// Parses a JSON response to an HTTP request expected to return a particular GPHMappable response.
    ///
    /// - parameter root: root object under which to parse results
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter rendition: GPHRenditionType GIF rendition to prefer, if applicable.
    /// - parameter completionHandler: Completion handler to be notified of the parser's outcome.
    /// - returns: GPHJSONCompletionHandler to be used as a completion handler for an HTTP request.
    ///
    class func parseJSONResponse<T>(root: T.GPHRootObject? = nil,
                                 type: GPHRequestType,
                                 media: GPHMediaType,
                                 rendition: GPHRenditionType = .original,
                                 completionHandler: @escaping GPHCompletionHandler<T>) -> GPHJSONCompletionHandler where T : GPHResponse, T : GPHMappable {
        
        return { (data, response, error) in
            // Error returned
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            // Handle the (impossible?) case where there is no data back from the server,
            // but there is no error returned
            
            guard let data = data else {
                completionHandler(nil, GPHJSONMappingError(description: "No data returned from the server, but no error reported."))
                return
            }

            do {
                let mappableObject: T.GPHMappableObject = try T.mapData(root, data: data, request: type, media: media, rendition: rendition)
                guard let obj = mappableObject as? T else {
                    completionHandler(nil, GPHJSONMappingError(description: "Couldn't cast " + String(describing: T.GPHMappableObject.self) + " to " + String(describing: T.self) + " during JSON response parsing."))
                    return
                }
                completionHandler(obj, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    
    #if !os(watchOS)
    
    /// Figure out network connectivity
    ///
    /// - returns: `true` if network is reachable
    ///
    func isNetworkReachable() -> Bool {
        return !useReachability || reachability.isReachable()
    }
    
    #endif
}
