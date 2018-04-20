//
//  LoggedInViewController.swift
//  InstaNEU
//
//  Created by Ashish on 4/15/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import FirebaseAuth
import KeychainSwift
import FirebaseDatabase


class LoggedInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    var list = ["Val 1", "Val 1","Val 1","Val 1"]
    
    
    
    var ref: DatabaseReference!
    var postData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser?.uid
        let postRef = ref.child("Post").child(uid!)
        
        _ = postRef.observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            KeychainSwift().delete("uid")
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    

}
