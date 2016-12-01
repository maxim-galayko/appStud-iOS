//
//  PlacemarkTableViewCell.swift
//  AppStud-iOS
//
//  Created by mgalayko on 12/1/16.
//  Copyright © 2016 mgalayko. All rights reserved.
//

import UIKit

class PlacemarkTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "PlacemarkTableViewCellReuseIdentifier"

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func clear() {
        photoImageView.image = nil
        
        titleLabel.text = nil
    }
}
