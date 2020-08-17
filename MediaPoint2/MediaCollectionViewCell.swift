//
//  MediaCollectionViewCell.swift
//  MediaPoint
//
//  Created by Maura Tai on 8/14/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//
import UIKit

class MediaCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet var imageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "MediaCollectionViewCell", bundle: nil)
    }
}
