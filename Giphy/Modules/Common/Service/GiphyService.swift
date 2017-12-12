//
//  GiphyService.swift
//  Giphy
//
//  Created by Andrei Momot on 12/12/17.
//  Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit
import GiphyCoreSDK

class GiphyService: NSObject {
    
    var giphyApi: GPHClient {
        get {
            return GPHClient(apiKey: AppApiServices.GiphyApiKey)
        }
    }
    
    func search(withTag tag: String, limit: Int, success: @escaping (_ result: [String]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        var ar: [String] = []
        
        self.giphyApi.search(tag, media: .gif, offset: 0, limit: limit, rating: .ratedG, lang: .english) { (response, error) in

            if let error = error {
                failure(error)
            } else {
                if let result = response?.data {
                    for img in result {
                        if let url = img.images?.fixedHeightSmall?.gifUrl {
                            ar.append(url)
                        }
                    }
                }
                success(ar)
            }
        }
    }
}
