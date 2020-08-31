//  MainViewController.swift
//  MediaPoint
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.

import UIKit
import Contacts
import ContactsUI
import Messages
import MessageUI
import MobileCoreServices
import FirebaseStorage

class MainViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    
    let storage = Storage.storage().reference()
    let imagesFolder = Storage.storage().reference(withPath: "images/")
    let videosFolder = Storage.storage().reference(withPath: "videos/")
    public var allImageData = [Data]()
    public var allVideoData = [Data]()
    let fileID = UUID().uuidString
    
    override func viewDidLoad() {
        getAllData()
    }
    
    
    @IBAction func getMedia() {
        //print("Upload button pressed...")
        showMedia()
    }
    
    @IBAction func getContacts() {
        //print("Send button pressed...")
        getAllData()
        showContacts()
    }
    
    
//    @IBAction func deleteMedia() {
//        print("Delete button pressed...")
//        showCurrentMediaView()
//    }
    
    
//    func showCurrentMediaView(){
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let currentMediaView = storyboard.instantiateViewController(identifier: "mediaview")
//
//        currentMediaView.modalPresentationStyle = .fullScreen
//        currentMediaView.modalTransitionStyle = .coverVertical
//
//        present(currentMediaView, animated: true)
//    }
    
    
    public func getAllData(){
        allImageData.removeAll()
        allVideoData.removeAll()
        imagesFolder.listAll { (result, error) in
            if let error = error {
                print("LIST ALL IMGs ERR: \(error) ")
            }
            for prefix in result.prefixes {
                print("IMG PREFIX: \(prefix.name)")
            }
            for item in result.items {
                //print("PHOTO DATA: \(item.name)")
                item.getData(maxSize: 20000000) { data, error in
                    if let error = error {
                        print("IMG DATA ERR: \(error)")
                    } else {
                        self.allImageData.append(data!)
                    }
                }
            }
        }
        videosFolder.listAll { (result, error) in
            if let error = error {
                print("LIST ALL VIDs ERR: \(error) ")
            }
            for prefix in result.prefixes {
                print("VIDs PREFIX: \(prefix.name)")
            }
            for item in result.items {
                //print("VIDEO DATA: \(item.name)")
                item.getData(maxSize: 60000000) { data, error in
                    if let error = error {
                        print("VIDs DATA ERR: \(error)")
                    } else {
                        self.allVideoData.append(data!)
                    }
                }
            }
        }
    }
    
    
//    func getAllVideosData(){
//        allVideoData.removeAll()
//        videosFolder.listAll { (result, error) in
//            if let error = error {
//                print("LIST ALL VIDs ERR: \(error) ")
//            }
//            for prefix in result.prefixes {
//                print("VIDs PREFIX: \(prefix.name)")
//            }
//            for item in result.items {
//                //print("VIDEO DATA: \(item.name)")
//                item.getData(maxSize: 60000000) { data, error in
//                    if let error = error {
//                        print("VIDs DATA ERR: \(error)")
//                    } else {
//                        self.allVideoData.append(data!)
//                    }
//                }
//            }
//        }
//    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result) {

        case.cancelled:
            //print("Cancelled...")
            dismiss(animated: true)

        case.failed:
            //print("The Message Failed...")
            dismiss(animated: true)
            showMessageFailAlert()

        case.sent:
            //print("The Message was Successful...")
            dismiss(animated: true)
            showMessageSuccessAlert()

        default:
            break
        }
    }
}


extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showMedia(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeImage as String]
        present(imagePicker, animated: true)
    }
    
    
    func showUploadFailAlert(){
        let failAlert = UIAlertController(title: "The Upload Failed", message: "Please, wait a few moments and try again OR close the app and launch it again.", preferredStyle: .alert)
        
        failAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(failAlert, animated: true)
    }
    
    func showMessageFailAlert(){
        let failAlert = UIAlertController(title: "The Message Failed to Send", message: "Please, wait a few moments and try again OR close the app and launch it again.", preferredStyle: .alert)
        
        failAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(failAlert, animated: true)
    }
    
    
    func showUploadSuccessAlert(){
        let successAlert = UIAlertController(title: "The Upload was Successful", message: "Upload more media or send what you have already uploaded.", preferredStyle: .alert)
        
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(successAlert, animated: true)
    }
    
    func showMessageSuccessAlert(){
        let successAlert = UIAlertController(title: "The Message Sent Successfully", message: "Thank you for using MediaPoint! Feel free to upload and send more.", preferredStyle: .alert)
        
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(successAlert, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if info[UIImagePickerController.InfoKey.originalImage] != nil{

            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }

            let imageData = selectedImage.jpegData(compressionQuality: 0.5)

            let imgID = UUID().uuidString

            storage.child("images/\(imgID).jpeg").putData(imageData!, metadata: nil, completion: {_, error in guard error == nil else {
                self.dismiss(animated: true)
                //print("Upload Failed...")
                self.showUploadFailAlert()
                return
                }
                self.dismiss(animated: true)
                //print("Upload Successful!")
                self.showUploadSuccessAlert()
            })

        }else if info[UIImagePickerController.InfoKey.mediaURL] != nil{

            guard let selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
            }

            do {

                let videoData = try Data(contentsOf: selectedVideo)
                let vidID = UUID().uuidString

                storage.child("videos/\(vidID).mp4").putData(videoData, metadata: nil, completion: {_, error in guard error == nil else {
                    self.dismiss(animated: true)
                    //print("Upload Failed...")
                    self.showUploadFailAlert()
                    return
                    }
                    self.dismiss(animated: true)
                    //print("Upload Successful!")
                    self.showUploadSuccessAlert()
                })}catch {
                print("CRITICAL ERROR")
            }
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
}




extension MainViewController: CNContactPickerDelegate, CNContactViewControllerDelegate{
    
    func showContacts(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let message = MFMessageComposeViewController()
        message.messageComposeDelegate = self
        
        let validLabelTypes = [CNLabelPhoneNumberiPhone, CNLabelPhoneNumberMobile]
        
        var phoneNumbers = [""]
        phoneNumbers.removeAll()
        
        let allPhoneNumbers = contact.phoneNumbers
        
        for contactPhoneNumber in allPhoneNumbers{
            let label = contactPhoneNumber.label!
            if validLabelTypes.contains(label){
                phoneNumbers.append(contactPhoneNumber.value.stringValue)
            }
        }
        message.recipients = phoneNumbers
        message.body = ""
        for i in allImageData{
            message.addAttachmentData(i, typeIdentifier: "public.jpeg", filename: "\(fileID).jpeg")
        }
        for v in allVideoData{
            message.addAttachmentData(v, typeIdentifier: "public.mpeg-4", filename: "\(fileID).mp4")
        }

        dismiss(animated: true) { //dismisses contact picker
            self.present(message, animated: true) //presents message composer
        }
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        //print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
}
