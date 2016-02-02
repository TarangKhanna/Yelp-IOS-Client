//
//  BusinessCell.swift
//  Yelp
//
//  Created by Tarang khanna on 2/2/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet { // whenever business changes
            nameLabel.text = business.name
            thumbImageView.setImageWithURL(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        // Initialization code
        
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width // causes truncation of namelabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width // causes truncation of namelabel
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
