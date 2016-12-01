//
//  LocationsViewPresenter.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

protocol LocationsViewPresenterProtocol: ViewControllerPresenterProtocol {
    unowned var presentable: LocationsViewPresentable { get set }
    
    func fetchPlacemarks(nearCoordinate coordinate: CLLocationCoordinate2D, radius: Double)
    
    func fetchPhoto(reference: String, width: Int, completion: @escaping (UIImage?) -> Void)
}

class LocationsViewPresenter: NSObject, LocationsViewPresenterProtocol {
    unowned var presentable: LocationsViewPresentable
    
    private var placemarksManager: PlacemarkProvidable {
        return PlacemarkServiceLocator.getService()
    }
    
    private var imageManager: ImageProvidable {
        return ImageServiceLocator.getService()
    }
    
    init(presentable: LocationsViewPresentable) {
        self.presentable = presentable
        
        super.init()
    }
    
    func fetchPlacemarks(nearCoordinate coordinate: CLLocationCoordinate2D, radius: Double) {
        placemarksManager.fetchPlacemarks(nearCoordinate: coordinate, radius: radius) { places in
            self.presentable.locations(presenter: self, didUpdatePlaces: places)
        }
    }
    
    func fetchPhoto(reference: String, width: Int, completion: @escaping (UIImage?) -> Void) {
        imageManager.fetchPhoto(reference: reference, width: width, completion: completion)
    }
}
