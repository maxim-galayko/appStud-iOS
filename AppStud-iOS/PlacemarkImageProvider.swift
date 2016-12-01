//
//  PlacemarkImageProvider.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

class PlacemarkImageProvider: NSObject, ImageProvidable {
    private var cache = NSCache<NSString, UIImage>()
    
    func fetchPhoto(reference: String, width: Int, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: reference as NSString) {
            completion(image)
            return
        }
        
        let request = RequestRouter.places.photo(byReference: reference, width: width)
        let task = URLSession.shared.downloadTask(with: request) { url, response, error in
            guard let localUrl = url else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let image = try? UIImage(data: Data(contentsOf: localUrl))
            if let image = image {
                self.cache.setObject(image!, forKey: reference as NSString)
            }
            
            DispatchQueue.main.async {
                completion(image ?? nil)
            }
        }
        
        task.resume()
    }
}
