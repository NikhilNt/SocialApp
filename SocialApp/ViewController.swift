//
//  ViewController.swift
//  SocialApp
//
//  Created by Nikhil Tanappagol on 7/31/17.
//  Copyright © 2017 Nikhil Tanappagol. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        let username = userNameTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: username!, password: password!, completion: { (user , error) in
            
            if error != nil {
                // entered wrong password or email
                let alert = UIAlertController(title: "Error", message: "error.localizedDescription", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler : nil ))
                self.present(alert, animated: true, completion: nil)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVc")
                self.present(vc, animated: true, completion: nil)
                
                
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

