//
//  ComposeViewController.swift
//  InstaNEU
//
//  Created by Ashish on 4/17/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref: DatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // go back to prev view
    @IBAction func CancelPost(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // add a new post
    @IBAction func AddPost(_ sender: UIBarButtonItem) {
        if (imageView.image == nil) {
            let alert = UIAlertController(title: "Remind", message: "No image selected. Please select an image to post", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                // we can perform anything over here
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        // Convert Image to Data
        var data = NSData()
        data = UIImageJPEGRepresentation(imageView.image!, 0.8)! as NSData
        // Get user ID
        let uid = Auth.auth().currentUser?.uid
        // Storage Reference
        let storageRef = Storage.storage().reference()
        // Get reference to the Image
        let imgURL : String = "Images" + "/" + uid! + "/" + GetImageName()
        let imgRef = storageRef.child(imgURL)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        // Add data to storage
        imgRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                print("File is uploaded")
            }
        }
        
        // Now add the Post in the database
        
        let post = [
            "postText" : txtPost.text,
            "imgURL" : imgURL,
            "dateTime" : GetDateTime(),
            "likedBy": ""
        
        ] as  [String : Any]
        
        ref.child("Posts").child(uid!).childByAutoId().setValue(post)
        
        
        ref.child("Post").child(uid!).childByAutoId().setValue(txtPost.text)
        
        
        
        
        // dismiss dialog
        dismiss(animated: true, completion: nil)

        
        
    }
    
    // current data in string
    func GetDateTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let strDate = String(components.month!) + "/"
            + String(components.day!) + "/"
            + String(components.year!) + "/ "
            + String(components.hour!) + ":"
            + String(components.minute!) + ":"
            + String(components.second!)
        return strDate;
    }
    
    
    // image name in url
    func GetImageName() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let strImage = "IMG_" + String(components.year!) + "_"
                              + String(components.month!) + "_"
            + String(components.day!) + "_"
            + String(components.hour!) + "_"
            + String(components.minute!) + "_"
            + String(components.second!) + ".jpg"
        return strImage;
    }
    
    
    // select image from camera or gallery
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
