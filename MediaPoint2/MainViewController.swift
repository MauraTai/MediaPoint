//  MainViewController.swift
//  MediaPoint
//
//  Created by Maura Tai on 7/17/20.
//  Copyright © 2020 Maura Tai. All rights reserved.
//
import UIKit
import Contacts
import ContactsUI
import Messages
import MessageUI
import MobileCoreServices
import Photos
import FirebaseStorage

class MainViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    
    let storage = Storage.storage().reference()
    let imagesFolder = Storage.storage().reference(withPath: "images/")
    let videosFolder = Storage.storage().reference(withPath: "videos/")
    public var allImageData = [Data]()
    public var downloadedImageData: Data!
    public var downloadedVideoData: Data!
    public var allVideoData = [Data]()
    let fileID = UUID().uuidString
    //@IBOutlet var mediaCollectionView: UICollectionView!
    
    
    @IBAction func getMedia() {
        print("Upload button pressed...")
//        getAllPhotosData()
//        getAllVideosData()
        showMedia()
    }
    
    @IBAction func getContacts() {
        print("Send button pressed...")
        getAllPhotosData() //update array
        getAllVideosData() //update array
        
        showContacts() //pick someone(s) and send it
    }
    
    
    @IBAction func deleteMedia() {
        print("Delete button pressed...")
        showCurrentMediaView() //show users what they have uploaded and allow them to delete
    }
    
    
    func showCurrentMediaView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentMediaView = storyboard.instantiateViewController(identifier: "mediaview")
        
        //mediaCollectionView.register(MediaCollectionViewCell.nib(), forCellWithReuseIdentifier: "MediaCollectionViewCell")
        
        currentMediaView.modalPresentationStyle = .fullScreen
        currentMediaView.modalTransitionStyle = .coverVertical
        
        present(currentMediaView, animated: true)
    }
    
    
//    public func getImage() -> UIImage{
//        var testImage = UIImage(named: "test")
//
//        for img in allImageData{
//            testImage = UIImage(data: img)!
//        }
//        return testImage!
//    }
    
    
    public func getAllPhotosData(){
        allImageData.removeAll()
        imagesFolder.listAll { (result, error) in
            if let error = error {
                print("LIST ALL IMGs ERR: \(error) ")
            }
            for prefix in result.prefixes {
                print("PREFIX: \(prefix.name)")
            }
            for item in result.items {
                print("PHOTO ITEM: \(item.name)")
                item.getData(maxSize: 30000000) { data, error in
                    if let error = error {
                        print("DATA ERR: \(error)")
                    } else {
                        self.downloadedImageData = data!
                        self.allImageData.append(data!)
                    }
                }
            }
        }
    }
    
    
    func getAllVideosData(){
        allVideoData.removeAll()
        videosFolder.listAll { (result, error) in
            if let error = error {
                print("LIST ALL VIDS ERR: \(error) ")
            }
            for prefix in result.prefixes {
                print("PREFIX: \(prefix.name)")
            }
            for item in result.items {
                print("VIDEO ITEM: \(item.name)")
                item.getData(maxSize: 30000000) { data, error in
                    if let error = error {
                        print("DATA ERR: \(error)")
                    } else {
                        self.downloadedVideoData = data!
                        self.allVideoData.append(data!)
                    }
                }
            }
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result) {

        case.cancelled:
            print("Cancelled...")
            dismiss(animated: true)

        case.failed:
            print("The Message Failed...")
            dismiss(animated: true)
            showMessageFailAlert()

        case.sent:
            print("The Message was Successful...")
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
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeImage as String, kUTTypeGIF as String]
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

            let imageData = selectedImage.jpegData(compressionQuality: 1)

            let imgID = UUID().uuidString

            storage.child("images/\(imgID).jpeg").putData(imageData!, metadata: nil, completion: {_, error in guard error == nil else {
                self.dismiss(animated: true)
                print("Upload Failed...")
                self.showUploadFailAlert()
                return
                }
                self.dismiss(animated: true)
                print("Upload Successful!")
                self.showUploadSuccessAlert()
                //self.imageFileName = self.storage.child("images/\(imgID).jpeg").name
            })

            //print(selectedImage)


        }else if info[UIImagePickerController.InfoKey.mediaURL] != nil{

            guard let selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
            }

            do {

                let videoData = try Data(contentsOf: selectedVideo)
                let vidID = UUID().uuidString

                storage.child("videos/\(vidID).mp4").putData(videoData, metadata: nil, completion: {_, error in guard error == nil else {
                    self.dismiss(animated: true)
                    print("Upload Failed...")
                    self.showUploadFailAlert()
                    return
                    }
                    self.dismiss(animated: true)
                    print("Upload Successful!")
                    self.showUploadSuccessAlert()
                    //self.videoFileName = self.storage.child("videos/\(vidID).mp4").name
                })

                //print(selectedVideo)

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
        message.body = "...brought to you by MediaPoint :)"
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
        print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }
}




//extension MainViewController: UICollectionViewDelegate{
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        print("You clicked a cell...")
//    }
//}
//
//
//
//
//extension MainViewController: UICollectionViewDataSource{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
//        
//        let testImage: UIImage = UIImage(data: downloadedImageData)!
//        
//        cell.configure(with: testImage)
//        
//        return cell
//    }
//}
//
//
//
//
//extension MainViewController: UICollectionViewDelegateFlowLayout{
//    
//}
