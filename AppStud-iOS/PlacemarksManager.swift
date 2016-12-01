//
//  PlacemarksManager.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

class PlacemarksManager: NSObject, PlacemarkProvidable {
    // MARK: Nested
    
    fileprivate class CoordinatesContainer {
        var coordinate: CLLocationCoordinate2D!
        var radius: Double!
        
        init(coordinate: CLLocationCoordinate2D, radius: Double) {
            self.coordinate = coordinate
            self.radius = radius
        }
    }
    
    fileprivate class PlaceContainer {
        var places: [Place]!
        
        init(places: [Place]) {
            self.places = places
        }
    }
    
    // MARK: Constants
    
    private enum Keys {
        static let results = "results"
    }
    
    // MARK: Variables
    
    fileprivate var cache = NSCache<CoordinatesContainer, PlaceContainer>()
    
    // MARK: Methods
    
    func fetchPlacemarks(nearCoordinate coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping ([Place]?) -> Void) {
        let cacheKey = CoordinatesContainer(coordinate: coordinate, radius: radius)
        
        if let container = cache.object(forKey: cacheKey) {
            completion(container.places)
            return
        }
        
        let request = RequestRouter.places.nearbySearch(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: radius)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var places: [Place] = []
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject],
                let jsonPlaces = json?[Keys.results] as? [[String: AnyObject]] {
                
                for jsonPlace in jsonPlaces {
                    if let place = Place.instantiate(with: jsonPlace) {
                        places.append(place)
                    }
                }
            }
            
            if places.isEmpty == false {
                let container = PlaceContainer(places: places)
                self.cache.setObject(container, forKey: cacheKey)
            }
            
            DispatchQueue.main.async {
                completion(places)
            }
        }
        
        task.resume()
    }
}
