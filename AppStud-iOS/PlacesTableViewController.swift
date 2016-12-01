//
//  PlacesTableViewController.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

protocol PlacesViewPresentable: ViewControllerPresentable {
    func locations(presenter: PlacesViewPresenterProtocol, didUpdatePlaces places: [Place]?)
}

class PlacesTableViewController: UITableViewController {
    // MARK: Variables
    
    var dataSource: [Place]?
    
    fileprivate lazy var presenter: PlacesViewPresenterProtocol = {
        let presenter = PlacesViewPresenter(presentable: self)
        return presenter
    }()
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    fileprivate var scrolling = false
    
    // MARK: Init / Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadDataWithLastCoordinates()
    }
    
    // MARK: Actions
    
    @IBAction func refreshData(_ sender: Any) {
        reloadDataWithLastCoordinates()
    }
}

// MARK: - Presentable
extension PlacesTableViewController: PlacesViewPresentable {
    func locations(presenter: PlacesViewPresenterProtocol, didUpdatePlaces places: [Place]?) {
        dataSource = places
        
        tableView.reloadData()
    }
}

// MARK: - Reload
extension PlacesTableViewController {
    private enum Constants {
        static let radius = 2000.0
    }
    
    func reloadDataWithLastCoordinates() {
        guard let coordinates = Settings.userLocation else { return }
        
        presenter.fetchPlacemarks(nearCoordinate: coordinates, radius: Constants.radius)
        
        refreshControl?.endRefreshing()
    }
}


// MARK: - Table view
extension PlacesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacemarkTableViewCell.reuseIdentifier, for: indexPath) as! PlacemarkTableViewCell
        
        cell.clear()
        
        let place = dataSource?[indexPath.row]
        cell.titleLabel.text = place?.name
        
        guard let reference = place?.reference else { return cell }
        presenter.fetchPhoto(reference: reference, width: Int(UIScreen.main.bounds.width)) { image in
            cell.photoImageView.image = image
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.shouldRasterize = scrolling
    }
    
}

// MARK: - Scoll view
extension PlacesTableViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrolling = false
        visibleCellsShouldRasterize(should: scrolling)
    }

    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity == CGPoint.zero {
            scrolling = false
            visibleCellsShouldRasterize(should: scrolling)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolling = true
        visibleCellsShouldRasterize(should: scrolling)
    }
    
    func visibleCellsShouldRasterize(should: Bool){
        for cell in tableView.visibleCells as [UITableViewCell] {
            cell.layer.shouldRasterize = should
        }
    }
}

// MARK: - Location Manager
extension PlacesTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = Settings.userLocation,
            let firstLocation = locations.first,
            userLocation.equal(second: firstLocation.coordinate) {
            return
        }
        
        Settings.userLocation = locations.first?.coordinate
        
        reloadDataWithLastCoordinates()
    }
}
