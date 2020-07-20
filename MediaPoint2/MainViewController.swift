//  MainViewController.swift
//  MediaPoint2
//
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func getMedia() {
        print("upload button pressed...")
        showImagePickerController()
    }
    
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage]
        dismiss(animated: true)
        print(selectedImage!)
    }
    
}
