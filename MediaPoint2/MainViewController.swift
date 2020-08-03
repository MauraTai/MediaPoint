//  MainViewController.swift
//  MediaPoint2
//
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MobileCoreServices
import Photos
import FirebaseStorage

class MainViewController: UIViewController {
    
    let storage = Storage.storage().reference()

    @IBAction func getMedia() {
        print("Upload button pressed...")
        showMedia()
    }
    
    @IBAction func getContacts() {
        print("Send button pressed...")
        showContacts()
    }
    
    
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showMedia(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeImage as String, kUTTypeGIF as String]
        present(imagePicker, animated: true)
    }
    
    
    func showFailAlert(){
        let failAlert = UIAlertController(title: "The Upload Failed.", message: "Please, wait a few moments and try again OR close the app and launch it again.", preferredStyle: .alert)
        
        failAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(failAlert, animated: true)
    }
    
    
    func showSuccessAlert(){
        let successAlert = UIAlertController(title: "The Upload was Successful.", message: "Upload more media or send what you have already uploaded.", preferredStyle: .alert)
        
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(successAlert, animated: true)
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
                self.dismiss(animated: true)
                print("Upload Failed...")
                self.showFailAlert()
                return
                }
                self.dismiss(animated: true)
                print("Upload Successful!")
                self.showSuccessAlert()
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
                    self.dismiss(animated: true)
                    print("Upload Failed...")
                    self.showFailAlert()
                    return
                    }
                    self.dismiss(animated: true)
                    print("Upload Successful!")
                    self.showSuccessAlert()
                })

                print(selectedVideo)

            }catch {
                print("IT GOOFED")
            }
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
}




extension MainViewController: CNContactPickerDelegate, CNContactViewControllerDelegate{
    
    func showContacts(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        let fName = contactProperty.contact.givenName
//        let lName = contactProperty.contact.familyName
//        let phoneNum = contactProperty.contact.phoneNumbers.first
//
//        print(fName)
//        print(lName)
//        print(phoneNum)
//    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fName = contact.givenName
        let lName = contact.familyName
        let phoneNum = contact.phoneNumbers.first
        let email = contact.emailAddresses.first

        print(fName)
        print(lName)
        print(phoneNum as Any)
        print(email as Any)
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
}
