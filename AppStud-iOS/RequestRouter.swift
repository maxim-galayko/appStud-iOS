//
//  Route.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

class RequestRouter: NSObject {
}

extension RequestRouter {
    static let places: GooglePlacesRoutable = GooglePlacesRouter()
}

protocol GooglePlacesRoutable: NSObjectProtocol {
    var apiKey: String { get }
    
    func nearbySearch(latitude: Double, longitude: Double, radius: Double) -> URL
}

class GooglePlacesRouter: NSObject, GooglePlacesRoutable {
    var apiKey: String {
        return "AIzaSyBM9qt79KECCgKutAMQg3rstJa4ohgZ7sI"
    }
    
    func nearbySearch(latitude: Double, longitude: Double, radius: Double) -> URL {
        let requestString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&&types=bar&key=\(apiKey)"
        return URL(string: requestString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
    }
}
