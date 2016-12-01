//
//  PlacemarkServiceLocator.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

class PlacemarkServiceLocator: NSObject {
    static private var service: PlacemarkProvidable = PlacemarksManager()
    
    static func setService(newService: PlacemarkProvidable) {
        service = newService
    }
    
    static func getService() -> PlacemarkProvidable {
        return service
    }
    
    static func setDefaults() {
        service = PlacemarksManager()
    }
}
