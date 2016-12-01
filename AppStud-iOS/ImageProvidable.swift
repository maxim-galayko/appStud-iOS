//
//  ImageProvidable.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

protocol ImageProvidable: NSObjectProtocol {
    func fetchPhoto(reference: String, width: Int, completion:  @escaping (UIImage?) -> Void)
}
