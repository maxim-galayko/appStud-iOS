//
//  LocationExtension.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

extension CLLocationCoordinate2D {
    func equal(second: CLLocationCoordinate2D) -> Bool {
        return latitude == second.latitude && longitude == second.longitude
    }
}

