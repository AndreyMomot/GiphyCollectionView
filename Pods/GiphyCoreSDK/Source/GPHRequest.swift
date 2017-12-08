//
//  GPHRequest.swift
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

/// Represents a Giphy URLRequest Type
///
@objc public enum GPHRequestType: Int {
    /// Search Request.
    case search
    
    /// Trending Request.
    case trending
    
    /// Translate Request.
    case translate
    
    /// Random Item Request.
    case random
    
    /// Get an Item with ID.
    case get
    
    /// Get items with IDs.
    case getAll
    
    /// Get Term Suggestions.
    case termSuggestions
    
    /// Top Categories.
    case categories
    
    /// SubCategories of a Category.
    case subCategories

    /// Category Content.
    case categoryContent
}


/// Async Request Operations with Completion Handler Support
///
class GPHRequest: GPHAsyncOperationWithCompletion {
    // MARK: Properties

    /// URLRequest obj to handle the networking.
    var request: URLRequest
    
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    /// Type of the request so we do some edge-case handling (JSON/Mapping etc)
    /// More than anything so we can map JSON > GPH objs.
    let type: GPHRequestType
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter client: GPHClient object to handle the request.
    /// - parameter request: URLRequest to execute.
    /// - parameter type: Request type (GPHRequestType).
    /// - parameter completionHandler: GPHJSONCompletionHandler to return JSON or Error.
    ///
    init(_ client: GPHAbstractClient, request: URLRequest, type: GPHRequestType, completionHandler: @escaping GPHJSONCompletionHandler) {
        self.client = client
        self.request = request
        self.type = type
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: Operation function
    
    /// Override the Operation function main to handle the request
    ///
    override func main() {
        client.session.dataTask(with: request) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            #if !os(watchOS)
                if !self.client.isNetworkReachable() {
                    self.callCompletion(data: nil, response: response, error: GPHHTTPError(statusCode:100, description: "Network is not reachable"))
                    return
                }
            #endif

            do {
                guard let data = data else {
                    self.callCompletion(data: nil, response: response, error:GPHJSONMappingError(description: "Can not map API response to JSON, there is no data"))
                    return
                }
                
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let result = result as? GPHJSONObject {
                    // Got the JSON
                    let httpResponse = response! as! HTTPURLResponse
                    // Get the status code from the JSON if available and prefer it over the response code from HTTPURLRespons
                    // If not found return the actual response code from http
                    let statusCode = ((result["meta"] as? GPHJSONObject)?["status"] as? Int) ?? httpResponse.statusCode
                    
                    if httpResponse.statusCode != 200 || statusCode != 200 {
                        // Get the error message from JSON if available.
                        let errorMessage = (result["meta"] as? GPHJSONObject)?["msg"] as? String
                        // Prep the error
                        let errorAPIorHTTP = GPHHTTPError(statusCode: statusCode, description: errorMessage)
                        self.callCompletion(data: result, response: response, error: errorAPIorHTTP)
                        self.state = .finished
                        return
                    }
                    self.callCompletion(data: result, response: response, error: error)
                } else {
                    self.callCompletion(data: nil, response: response, error: GPHJSONMappingError(description: "Can not map API response to JSON"))
                }
            } catch {
                self.callCompletion(data: nil, response: response, error: error)
            }
            
            self.state = .finished
            
        }.resume()
    }
}


/// Router to generate URLRequest objects.
///
enum GPHRequestRouter {
    // MARK: Properties

    /// Search endpoint: query, type, offset, limit, rating, lang
    case search(String, GPHMediaType, Int, Int, GPHRatingType, GPHLanguageType)
    
    /// Trending endpoint: type, offset, limit, rating
    case trending(GPHMediaType, Int, Int, GPHRatingType)
    
    /// Translate endpoint: term, type, rating, lang
    case translate(String, GPHMediaType, GPHRatingType, GPHLanguageType)
    
    /// Random endpoint: query, type, rating
    case random(String, GPHMediaType, GPHRatingType)
    
    /// Get object endpoint: id
    case get(String)
    
    /// Get objects endpoint: ids
    case getAll([String])
    
    /// Term Suggestions endpoint: term to query
    case termSuggestions(String)
    
    /// Categories endpoint: type, offset, limit
    case categories(GPHMediaType, Int, Int, String)
    
    /// Categories endpoint for subcategories: category, type, offset, limit
    case subCategories(String, GPHMediaType, Int, Int, String)
    
    /// Category content endpoint: category, type, offset, limit, rating, lang
    case categoryContent(String, GPHMediaType, Int, Int, GPHRatingType, GPHLanguageType)
    
    /// Base endpoint url.
    static let baseURLString = "https://api.giphy.com/v1/"
    
    /// HTTP Method type.
    var method: String {
        switch self {
        default: return "GET"
        // in future when we have upload / auth / we will add PUT, DELETE, POST here
        }
    }
    
    // MARK: Helper functions
    
    /// Construct the request from url, method and parameters.
    ///
    /// - parameter apiKey: Api-key for the request.
    /// - returns: A URLRequest object constructed from the current type of the request.
    ///
    public func asURLRequest(_ apiKey: String) -> URLRequest {
        
        // Build the request endpoint
        var queryItems:[URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        let url: URL = {
            let relativePath: String?
            switch self {
            case .search(let query, let type, let offset, let limit, let rating, let lang):
                relativePath = "\(type.rawValue)s/search"
                queryItems.append(URLQueryItem(name: "q", value: query))
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
                queryItems.append(URLQueryItem(name: "lang", value: lang.rawValue))
            case .trending(let type, let offset, let limit, let rating):
                relativePath = "\(type.rawValue)s/trending"
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
            case .translate(let term, let type, let rating, let lang):
                relativePath = "\(type.rawValue)s/translate"
                queryItems.append(URLQueryItem(name: "s", value: term))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
                queryItems.append(URLQueryItem(name: "lang", value: lang.rawValue))
            case .random(let query, let type, let rating):
                relativePath = "\(type.rawValue)s/random"
                queryItems.append(URLQueryItem(name: "tag", value: query))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
            case .get(let id):
                relativePath = "gifs/\(id)"
            case .getAll(let ids):
                queryItems.append(URLQueryItem(name: "ids", value: ids.flatMap({$0}).joined(separator:",")))
                relativePath = "gifs"
            case .termSuggestions(let term):
                relativePath = "queries/suggest/\(term)"
            case .categories(let type, let offset, let limit, let sort):
                relativePath = "\(type.rawValue)s/categories"
                queryItems.append(URLQueryItem(name: "sort", value: "\(sort)"))
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
            case .subCategories(let category, let type, let offset, let limit, let sort):
                relativePath = "\(type.rawValue)s/categories/\(category)"
                queryItems.append(URLQueryItem(name: "sort", value: "\(sort)"))
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
            case .categoryContent(let category, let type, let offset, let limit, let rating, let lang):
                relativePath = "\(type.rawValue)s/categories/\(category)"
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
                queryItems.append(URLQueryItem(name: "lang", value: lang.rawValue))

            }
            
            var url = URL(string: GPHRequestRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = queryItems
            guard let fullUrl = urlComponents?.url else { return url }
            
            return fullUrl
        }()
        
        // Set up request parameters.
        let parameters: GPHJSONObject? = {
            switch self {
            default: return nil
            // in future when we have upload / auth / we will add PUT, DELETE, POST here
            }
        }()
        
        // Create the request.
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        if let parameters = parameters,
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            request.httpBody = data
        }
        return request
    }
}
