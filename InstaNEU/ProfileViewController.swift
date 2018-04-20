//
//  ProfileViewController.swift
//  InstaNEU
//
//  Created by Ashish on 4/17/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get user ID
        let uid = Auth.auth().currentUser?.uid
        // Storage Reference
        let storageRef = Storage.storage().reference()
        // Get reference to the Image
        let imgURL : String = "ProfileImage" + "/" + uid! + "/" + "profile.jpg"
        let imgRef = storageRef.child(imgURL)
        
        imgRef.getData(maxSize: 8000000, completion: {(data, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                if (data == nil) {
                    return
                }
                self.imageView.image = UIImage(data: data!)
            }
        })
        
        if (Auth.auth().currentUser?.displayName != nil) {
            txtUsername.text = Auth.auth().currentUser?.displayName
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancleProfile(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func UpdateProfile(_ sender: UIButton) {
        // Convert Image to Data
        var data = NSData()
        data = UIImageJPEGRepresentation(imageView.image!, 0.8)! as NSData
        // Get user ID
        let uid = Auth.auth().currentUser?.uid
        // Storage Reference
        let storageRef = Storage.storage().reference()
        // Get reference to the Image
        let imgURL : String = "ProfileImage" + "/" + uid! + "/" + "profile.jpg"
        let imgRef = storageRef.child(imgURL)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        if (imageView.image == nil) {
            let alert = UIAlertController(title: "Remind", message: "No image selected. Please select an image to post", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                // we can perform anything over here
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (txtUsername.text == "") {
            let alert = UIAlertController(title: "Remind", message: "User name should not be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                // we can perform anything over here
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        
        // update profile image
        
        imgRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                print("File is uploaded")
            }
        }
        // change user name
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = txtUsername.text
        changeRequest?.commitChanges { (error) in
            if (error == nil) {
                print("Uploaded successfully")
                
            } else {
                print("Fail to change name")
            }
        }
        
        // dismiss dialog
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SelectImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionsheetController: UIAlertController = UIAlertController(title: "Select Source of Image", message: "Please select source of image", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionsheetController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            // add code for camera
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else{
                print("Camera not available")
            }
        }))
        
        actionsheetController.addAction(UIAlertAction(title: "Photo gallery", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            // add code for Photo gallery
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionsheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            // add code for camera
        }))
        
        
        actionsheetController.popoverPresentationController?.sourceView = btnSelectImage
        present(actionsheetController, animated: true, completion: nil)
    }
    
    // When user Cancels an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // When user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
