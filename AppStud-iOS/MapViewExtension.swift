//
//  MapViewExtension.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func centerUserLocation() {
        zoomToAllPins()
    }
    
    private func zoomToAllPins() {
        let edgeInset: CGFloat = 50
        
        var zoomRect = MKMapRectNull
        
        for annotation in annotations {
            zoomRect = MKMapRectUnion(zoomRect, mapRect(coordinate: annotation.coordinate))
        }
        zoomRect = mapRectThatFits(zoomRect)
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset), animated: true)
    }
    
    private func mapRect(coordinate: CLLocationCoordinate2D) -> MKMapRect {
        let delta: Double = 7500
        let mapPoint = MKMapPointForCoordinate(coordinate)
        return MKMapRectMake(mapPoint.x - delta, mapPoint.y - delta, delta * 2, delta * 2)
    }
}
