//
//  PlacemarkProvidable.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

protocol PlacemarkProvidable: NSObjectProtocol {
    func fetchPlacemarks(nearCoordinate coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping ([Place]?) -> Void)
}
