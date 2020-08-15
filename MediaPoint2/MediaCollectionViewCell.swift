//
//  MediaCollectionViewCell.swift
//  MediaPoint
//
//  Created by Maura Tai on 8/14/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//
import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        //set cell's image here
    }

}
