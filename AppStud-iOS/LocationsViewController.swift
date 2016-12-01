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
        static let minLocationDifference = 100.0
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
    
    fileprivate var userLocation: CLLocation?
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func centerUserLocation(_ sender: Any) {
        mapView.centerUserLocation()
    }
    
    // MAKR: Methods
}

// MARK: - DataSource 
fileprivate extension LocationsViewController {
    func add(places: [Place]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for place in places {
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.coordinate
            annotation.title = "test"
            mapView.addAnnotation(annotation)
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
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MapConstants.pinViewReuseIdentifier)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapConstants.pinViewReuseIdentifier)
        }
        
        fill(pinView: pinView!, forAnnotation: annotation)
        return pinView
    }
    
    private func fill(pinView: MKAnnotationView, forAnnotation annotation: MKAnnotation) {
        pinView.canShowCallout = true
        pinView.annotation = annotation
    }
}

// MARK: - Location Manager
extension LocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = userLocation,
            let firstLocation = locations.first,
            userLocation.distance(from: firstLocation) < Constants.minLocationDifference {
            return
        }
        
        userLocation = locations.first
        
        if let location = userLocation {
            presenter.fetchPlacemarks(nearCoordinate: location.coordinate, radius: Constants.radius)
        }
    }
}
