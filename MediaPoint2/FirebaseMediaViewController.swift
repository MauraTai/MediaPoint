//  FirebaseMediaViewController.swift
//  MediaPoint
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.

import UIKit
import FirebaseStorage

class FirebaseMediaViewController: UIViewController{
   
    //var testImage: UIImage!
    let mainData = MainViewController()
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    
//    override func viewDidLoad() {
//
//        mainData.getAllPhotosData()
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 120, height: 120)
//        mediaCollectionView.collectionViewLayout = layout
//
//        mediaCollectionView.register(MediaCollectionViewCell.nib(), forCellWithReuseIdentifier: "MediaCollectionViewCell")
//
//        mediaCollectionView.delegate = self
//        mediaCollectionView.dataSource = self
//    }
//}
//
//
//extension FirebaseMediaViewController: UICollectionViewDelegate{
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        print("You clicked a cell...")
//
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//
//
//extension FirebaseMediaViewController: UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
////        let num = mainData.count
////        print("get num: \(num)")
//
//        return 6
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
//
//        //let img = mainData.downloadedImageData!
//        //let cellImage: UIImage = UIImage(data: img)!
//        //              OR
//        //let cellImage = UIImage(data: img)!
//
//        cell.configure(with: UIImage(named: "testImage")!)
//
////        let cellImage = mainData.getImage()
////        cell.configure(with: cellImage)
//
//        return cell
//    }
//}
//
//
//extension FirebaseMediaViewController: UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 120, height: 120)
//    }
}
