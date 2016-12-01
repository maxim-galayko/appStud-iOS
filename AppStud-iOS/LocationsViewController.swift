//
//  LocationsViewController.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

protocol LocationsViewPresentable: NSObjectProtocol {
    func locations(presenter: LocationsViewPresenterProtocol, didUpdatePlaces places: [Place]?)
}

class LocationsViewController: UIViewController {
    // MARK: Constants
    
    fileprivate enum Constants {
        static let radius = 2000.0
    }
    
    // MARK: Variables
    
    fileprivate lazy var presenter: LocationsViewPresenterProtocol = {
        let presenter = LocationsViewPresenter(presentable: self)
        return presenter
    }()
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    
    // MARK: Init / Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPlacemarks()
    }
    
    // MARK: Actions
    
    @IBAction func centerUserLocation(_ sender: Any) {
        mapView.centerUserLocation()
    }
}

// MARK: - DataSource 
fileprivate extension LocationsViewController {
    func add(places: [Place]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for place in places {
            mapView.addAnnotation(place)
        }
    }
    
    func fetchPlacemarks() {
        if let location = Settings.userLocation {
            presenter.fetchPlacemarks(nearCoordinate: location, radius: Constants.radius)
        }
    }
}

// MARK: - Presentable
extension LocationsViewController: LocationsViewPresentable {
    func locations(presenter: LocationsViewPresenterProtocol, didUpdatePlaces places: [Place]?) {
        guard let places = places else { return }
        
        add(places: places)
        mapView.centerUserLocation()
    }
}


// MARK: - MapView
extension LocationsViewController: MKMapViewDelegate {
    private enum MapConstants {
        static let pinViewReuseIdentifier = "LocationsPinAnnotationViewReuseIdentifier"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var pinView: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: MapConstants.pinViewReuseIdentifier) as? ImageAnnotationView
        if pinView == nil {
            pinView = ImageAnnotationView(annotation: annotation, reuseIdentifier: MapConstants.pinViewReuseIdentifier)
        }
        
        fill(pinView: pinView!, forAnnotation: annotation)
        return pinView
    }
    
    private func fill(pinView: ImageAnnotationView, forAnnotation annotation: MKAnnotation) {
        pinView.canShowCallout = true
        pinView.annotation = annotation
        
        if let placeAnnotation = annotation as? Place, let reference = placeAnnotation.reference {
            presenter.fetchPhoto(reference: reference, width: Int(UIScreen.main.bounds.width)) { image in
                pinView.imageView.image = image
            }
        }
    }
}

// MARK: - Location Manager
extension LocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = Settings.userLocation,
            let firstLocation = locations.first,
            userLocation.equal(second: firstLocation.coordinate) {
            return
        }
        
        Settings.userLocation = locations.first?.coordinate
        
        fetchPlacemarks()
    }
}
