//
//  ImageCache.swift
//  CNode
//
//  Created by Ivy on 16/5/16.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit
import Kingfisher

final class Cache {

    static let shareCache = Cache()
    
    let cache = NSCache()
    let cacheQueue = dispatch_queue_create("image_cache", DISPATCH_QUEUE_SERIAL)
    
    static func imageOfURL(urlString: String, completion: (url: NSURL, image: UIImage?, cacheType: CacheType) -> ()) {
        shareCache.imageOfURL(urlString, completion: completion)
    }
}

private extension Cache {
    func imageOfURL(urlString: String, completion: (url: NSURL, image: UIImage?, cacheType: CacheType) -> ()) {
        
        let url: NSURL = urlString.url
        
        let imageKey = "image-\(urlString)"
        
        let options: KingfisherOptionsInfo = [
            .CallbackDispatchQueue(cacheQueue),
            .BackgroundDecode,
            ]
        
        Kingfisher.ImageCache.defaultCache.retrieveImageForKey(imageKey, options: options) { (_image, _cacheType) in
            if let image = _image {
                completion(url: url, image: image, cacheType: _cacheType)
            }else {
                ImageDownloader.defaultDownloader.downloadImageWithURL(url, options: options, progressBlock: { (receivedSize, totalSize) in
                    
                    }, completionHandler: { (image, error, imageURL, originalData) in
                        if let image = image {
                            Kingfisher.ImageCache.defaultCache.storeImage(image, originalData: originalData, forKey: imageKey, toDisk: true, completionHandler: nil)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(url: url, image: image, cacheType: .None)
                            })
                        }else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(url: url, image: nil, cacheType: .None)
                            })
                        }
                })
            }
        }
    }
}
