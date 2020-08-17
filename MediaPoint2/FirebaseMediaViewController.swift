//
//  FirebaseMediaViewController.swift
//  MediaPoint
//
//  Created by Maura Tai on 8/14/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//
import UIKit
import FirebaseStorage

class FirebaseMediaViewController: UIViewController{
   
    //var testImage: UIImage!
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        mediaCollectionView.collectionViewLayout = layout
        
        mediaCollectionView.register(MediaCollectionViewCell.nib(), forCellWithReuseIdentifier: "MediaCollectionViewCell")
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
}


extension FirebaseMediaViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("You clicked a cell...")
        
        self.dismiss(animated: true, completion: nil)
    }
}


extension FirebaseMediaViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        MainViewController().getAllPhotosData()
//        let num = MainViewController().allImageData.count
//        print("num:\(num)")
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
        
        //let img = MainViewController().downloadedImageData
        //let cellImage: UIImage = UIImage(data: img)!
        //              OR
        //let cellImage = UIImage(data: img)!
        
        cell.configure(with: UIImage(named: "test")!)
        
        return cell
    }
}


extension FirebaseMediaViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
