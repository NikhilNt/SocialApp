//
//  SecondViewController.swift
//  SocialApp
//
//  Created by Nikhil Tanappagol on 7/31/17.
//  Copyright © 2017 Nikhil Tanappagol. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SecondViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confrimPassword: UITextField!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var imageview: UIImageView!
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let storage = Storage.storage().reference(forURL: "gs://uiinsat.appspot.com")
        ref = Database.database().reference()
        userStorage = storage.child("data")
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectTheImage(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageview.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        guard fullNameTextField.text != " ", userNameField.text != " ",passwordField.text != "", confrimPassword.text != " " else {return }
        if passwordField.text == confrimPassword.text {
            Auth.auth().createUser(withEmail: userNameField.text!, password: passwordField.text!, completion: {(user , error) in
                if error != nil {
                    // entered wrong password or email
                    let alert = UIAlertController(title: "Error", message: "Not Vaild User Name and password ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler : nil ))
                    self.present(alert, animated: true, completion: nil)
                }
                if let user = user {
                    
                    let changerequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changerequest.displayName = self.fullNameTextField.text!
                    changerequest.commitChanges(completion : nil)
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.imageview.image!, 0.5)
                    //upload task
                    let uploadTask = imageRef.putData(data!, metadata: nil , completion: {( metadata , errr) in
                        if errr != nil {
                            
                        }
                        imageRef.downloadURL(completion: { ( url , er)in
                            if er != nil {
                                // er!.localized error
                            }
                            
                            if let url = url {
                                let userInfo: [ String : Any] = [ "uid" : user.uid,
                                       "full name": self.fullNameTextField.text!,
                                       "urlToImage": url.absoluteString]
                                
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVc")
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        })
                        })
                    uploadTask.resume()
                    
                }
        })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
