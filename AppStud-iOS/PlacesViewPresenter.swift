//
//  PlacesViewPresenter.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

protocol PlacesViewPresenterProtocol: ViewControllerPresenterProtocol {
    unowned var presentable: PlacesViewPresentable { get set }
    
    func fetchPlacemarks(nearCoordinate coordinate: CLLocationCoordinate2D, radius: Double)
    
    func fetchPhoto(reference: String, width: Int, completion: @escaping (UIImage?) -> Void)
}

class PlacesViewPresenter: NSObject, PlacesViewPresenterProtocol {
    unowned var presentable: PlacesViewPresentable
    
    private var placemarksManager: PlacemarkProvidable {
        return PlacemarkServiceLocator.getService()
    }
    
    private var imageManager: ImageProvidable {
        return ImageServiceLocator.getService()
    }
    
    init(presentable: PlacesViewPresentable) {
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
