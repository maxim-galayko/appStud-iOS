//
//  ImageServiceLocator.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

class ImageServiceLocator: NSObject {
    static private var service: ImageProvidable = PlacemarkImageProvider()
    
    static func setService(newService: ImageProvidable) {
        service = newService
    }
    
    static func getService() -> ImageProvidable {
        return service
    }
    
    static func setDefaults() {
        service = PlacemarkImageProvider()
    }
}
