//
//  ViewController.swift
//  InstaNEU
//
//  Created by Ashish on 4/15/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblWelcome: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        let keychain = KeychainService().KeyChain
        if(keychain.get("uid") != nil){
            self.performSegue(withIdentifier: "SegueLogin", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AddKeyChain(id: String){
        KeychainService().KeyChain.set(id, forKey: "uid")
    }
    
    
    @IBAction func Login(_ sender: UIButton) {
        
        let email = txtEmail.text
        let password = txtPassword.text
        
        if( email == "" || password == ""){
            lblWelcome.text = "Email or password is empty"
            return
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            
            if(error == nil){
                
                self.AddKeyChain(id: user!.uid)
                // Perform Segue
                self.performSegue(withIdentifier: "SegueLogin", sender: self)
                
            }else{
                self.lblWelcome.text = "Unable to login"
            }
        }
        
        
    }
    

}

