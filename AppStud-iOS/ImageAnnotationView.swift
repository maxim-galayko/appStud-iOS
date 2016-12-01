//
//  ImageAnnotationView.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit
import MapKit

class ImageAnnotationView: MKAnnotationView {
    private enum Constants {
        static let width = 50
    }
    
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.width, height: Constants.width))
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addImageView()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func addImageView() {
        imageView.image = image
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
}
