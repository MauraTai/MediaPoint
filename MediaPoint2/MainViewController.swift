//  MainViewController.swift
//  MediaPoint2
//
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//

import UIKit
import MobileCoreServices
//import OpalImagePicker
import Photos
import FirebaseStorage

class MainViewController: UIViewController {
    
    let storage = Storage.storage().reference()

    @IBAction func getMedia() {
        print("Upload button pressed...")
        //showImages()
        showMedia()
    }
    
//    @IBAction func getVideos() {
//       print("upload VIDEOS button pressed...")
//        showVideos()
//
//    }
    
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//OpalImagePickerControllerDelegate
    
//    func showImages(){
//        //let imagePicker = OpalImagePickerController()
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        //imagePicker.imagePickerDelegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeGIF as String]
//        present(imagePicker, animated: true)
//    }
//
//    func showVideos(){
//        let videoPicker = UIImagePickerController()
//        videoPicker.delegate = self
//        videoPicker.sourceType = .photoLibrary
//        videoPicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
//        present(videoPicker, animated: true)
//    }
    
    func showMedia(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeImage as String, kUTTypeGIF as String]
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[UIImagePickerController.InfoKey.originalImage] != nil{
            
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            
            guard let imageData = selectedImage.jpegData(compressionQuality: 1) else {
                return
            }
            
            let imgID = UUID().uuidString
            
            storage.child("images/\(imgID).jpeg").putData(imageData, metadata: nil, completion: {_, error in guard error == nil else {
                print("Upload Failed...")
                self.dismiss(animated: true)
                return
                }
                print("Upload Successful!") //SHOW IN APP
                self.dismiss(animated: true)
            })
            
            print(selectedImage)
            
            
        }else if info[UIImagePickerController.InfoKey.mediaURL] != nil{
            
            guard let selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
            }
            
            do {
                
                let videoData = try Data(contentsOf: selectedVideo)
                let vidID = UUID().uuidString
                
                storage.child("videos/\(vidID).mov").putData(videoData, metadata: nil, completion: {_, error in guard error == nil else {
                    print("Upload Failed...")
                    self.dismiss(animated: true)
                    return
                    }
                    print("Upload Successful!") //SHOW IN APP
                    self.dismiss(animated: true)
                })
                
                print(selectedVideo)
                
            }catch {
                print("IT GOOFED")
            }
            
        }
        
        
        
        
        
        
        
        //dismiss(animated: true)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
//    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
//        print("Cancelled...")
//    }
    
    
//    private func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages allImages: [UIImage]) {
//
//        var imageNum = 0
//
//        for image in allImages {
//
//            imageNum += 1
//
//            guard let imageData = image.pngData() else {
//                return
//            }
//
//            print(imageData)
//
//            storage.child("images/image\(imageNum).png").putData(imageData, metadata: nil, completion: {_, error in
//                guard error == nil else {
//                    print("Upload Failed...")
//                    return
//                }
//
//            })
//        }
//        print("Done...")
//        dismiss(animated: true)
//    }
    
    
}
