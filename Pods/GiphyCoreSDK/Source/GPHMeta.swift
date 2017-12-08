//
//  GPHMeta.swift
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

/// Represents a Giphy Response Meta Info
///
@objc public class GPHMeta: NSObject {
    // MARK: Properties

    /// Unique response id.
    public fileprivate(set) var responseId: String
    
    /// Status (200, 404...)
    public fileprivate(set) var status: Int
    
    /// Message description.
    public fileprivate(set) var msg: String
    
    
    // MARK: Initializers
    
    /// Initializer
    ///
    override public init() {
        self.responseId = ""
        self.status = 0
        self.msg = ""
        super.init()
    }
    
    /// Convenience Initializer
    ///
    /// - parameter responseId: Unique response id.
    /// - parameter status: Status (200, 404...)
    /// - parameter msg: Message description.
    ///
    convenience init(_ responseId: String, status: Int, msg: String) {
        self.init()
        self.status = status
        self.msg = msg
        self.responseId = responseId
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHMeta {
    
    override public var description: String {
        return "GPHMeta(\(self.responseId) status: \(self.status) msg: \(self.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHMeta: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHMeta?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) throws -> GPHMeta {
        
        guard
            let responseId = jsonData["response_id"] as? String,
            let status = jsonData["status"] as? Int,
            let msg = jsonData["msg"] as? String
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHMeta for \(jsonData)")
        }
        
        let obj = GPHMeta(responseId, status: status, msg: msg)
        return obj
    }
    
}
