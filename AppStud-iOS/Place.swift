//
//  Place.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject {
    var coordinate: CLLocationCoordinate2D!
    
    var name: String?
    
    var reference: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}

extension Place {
    private enum Key {
        static let description = "description"
        static let name = "name"
        static let photos = "photos"
        static let reference = "photo_reference"
        static let geometry = "geometry"
        static let location = "location"
        static let latitude = "lat"
        static let longitude = "lng"
        static let predictions = "predictions"
    }
    
    static func instantiate(with json: [String: AnyObject]) -> Place? {
        guard
            let geometry = json[Key.geometry] as? [String: AnyObject],
            let location = geometry[Key.location] as? [String: AnyObject],
            let latitude = location[Key.latitude] as? Double,
            let longitude = location[Key.longitude] as? Double
        else {
            return nil
        }
        
        let place = Place(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        place.name = json[Key.name] as? String
        
        if let photos = json[Key.photos] as? [[String: AnyObject]],
            let photo = photos.first,
            let reference = photo[Key.reference] as? String {
                place.reference = reference
        }
        return place
    }
}
