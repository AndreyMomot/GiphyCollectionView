//
//  GPHImage.swift
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

/// Represents a Giphy Image (GIF/Sticker)
///
@objc public class GPHImage: NSObject, NSCoding {
    // MARK: Properties

    /// ID of the Represented GPHMedia Object.
    public fileprivate(set) var mediaId: String = ""

    /// ID of the Represented Object.
    public fileprivate(set) var rendition: GPHRenditionType = .original
    
    /// URL of the Gif file.
    public fileprivate(set) var gifUrl: String?

    /// URL of the Still Gif file.
    public fileprivate(set) var stillGifUrl: String?
    
    /// Width.
    public fileprivate(set) var width: Int?
    
    /// Height.
    public fileprivate(set) var height: Int?

    /// # of Frames.
    public fileprivate(set) var frames: Int?
    
    /// Gif file size in bytes.
    public fileprivate(set) var gifSize: Int?
    
    /// URL of the WebP file.
    public fileprivate(set) var webPUrl: String?

    /// Gif file size in bytes.
    public fileprivate(set) var webPSize: Int?
    
    /// URL of the mp4 file.
    public fileprivate(set) var mp4Url: String?
    
    /// Gif file size in bytes.
    public fileprivate(set) var mp4Size: Int?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter mediaId: Media Objects ID.
    /// - parameter rendition: Rendition Type of the Image.
    ///
    convenience public init(_ mediaId: String,
                     rendition: GPHRenditionType) {
        self.init()
        self.mediaId = mediaId
        self.rendition = rendition
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let mediaId = aDecoder.decodeObject(forKey: "mediaId") as? String,
            let rendition = GPHRenditionType(rawValue: aDecoder.decodeObject(forKey: "rendition") as! String)
        else {
            return nil
        }
        
        self.init(mediaId, rendition: rendition)
                  
        self.gifUrl = aDecoder.decodeObject(forKey: "gifUrl") as? String
        self.stillGifUrl = aDecoder.decodeObject(forKey: "stillGifUrl") as? String
        self.gifSize = aDecoder.decodeObject(forKey: "gifSize") as? Int
        self.width = aDecoder.decodeObject(forKey: "width") as? Int
        self.height = aDecoder.decodeObject(forKey: "height") as? Int
        self.frames = aDecoder.decodeObject(forKey: "frames") as? Int
        self.webPUrl = aDecoder.decodeObject(forKey: "webPUrl") as? String
        self.webPSize = aDecoder.decodeObject(forKey: "webPSize") as? Int
        self.mp4Url = aDecoder.decodeObject(forKey: "mp4Url") as? String
        self.mp4Size = aDecoder.decodeObject(forKey: "mp4Size") as? Int
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mediaId, forKey: "mediaId")
        aCoder.encode(self.rendition.rawValue, forKey: "rendition")
        aCoder.encode(self.gifUrl, forKey: "gifUrl")
        aCoder.encode(self.stillGifUrl, forKey: "stillGifUrl")
        aCoder.encode(self.gifSize, forKey: "gifSize")
        aCoder.encode(self.width, forKey: "width")
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.frames, forKey: "frames")
        aCoder.encode(self.webPUrl, forKey: "webPUrl")
        aCoder.encode(self.webPSize, forKey: "webPSize")
        aCoder.encode(self.mp4Url, forKey: "mp4Url")
        aCoder.encode(self.mp4Size, forKey: "mp4Size")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
    }
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHImage === self {
            return true
        }
        if let other = object as? GPHImage, self.mediaId == other.mediaId, self.rendition.rawValue == other.rendition.rawValue {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_image_\(self.mediaId)_\(self.rendition.rawValue)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHImage {
    
    override public var description: String {
        return "GPHImage(for: \(self.mediaId)) rendition: \(self.rendition.rawValue)"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHImage: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHMedia?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) throws -> GPHImage {
        
        guard let mediaId = root?.id else {
            throw GPHJSONMappingError(description: "Root object can not be nil, expected a GPHMedia")
        }
        
        let obj = GPHImage(mediaId, rendition: renditionType)
        
        obj.gifUrl = jsonData["url"] as? String
        obj.stillGifUrl = jsonData["still_url"]  as? String
        obj.gifSize = parseInt(jsonData["size"] as? String)
        obj.width = parseInt(jsonData["width"] as? String)
        obj.height = parseInt(jsonData["height"] as? String)
        obj.frames = parseInt(jsonData["frames"] as? String)
        obj.webPUrl = jsonData["webp_url"] as? String
        obj.webPSize = parseInt(jsonData["webp_size"] as? String)
        obj.mp4Url = jsonData["mp4_url"] as? String
        obj.mp4Size = parseInt(jsonData["mp4_size"] as? String)
        obj.jsonRepresentation = jsonData
        
        return obj
    }
    
}
