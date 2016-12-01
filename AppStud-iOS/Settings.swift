//
//  Settings.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

class Settings: NSObject {
    static var userLocation: CLLocationCoordinate2D? {
        get {
            return lastUserLocation ?? mockLocation
        }
        set {
            lastUserLocation = newValue
        }
    }
    
    static let mockLocation = CLLocationCoordinate2DMake(49.8419522, 24.0009654)
    
    private static var lastUserLocation: CLLocationCoordinate2D?
}
