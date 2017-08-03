//
//  ThirdViewController.swift
//  SocialApp
//
//  Created by Nikhil Tanappagol on 7/31/17.
//  Copyright © 2017 Nikhil Tanappagol. All rights reserved.
//

import UIKit
import Firebase

class ThirdViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var  user = [Users]()

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         retrievUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrievUsers() {
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let UserS = snapshot.value as! [String : AnyObject]
            for (_,value) in UserS {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser!.uid{
                        let userToShow = Users ()
                        if let fullName = value["full name"] as? String , let imagePath = value["urlToImage"] as? String {
                            userToShow.fullName = fullName
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.user.append(userToShow)
                        }
                    }
                }
                
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! ThirdViewSubClass
        cell.cellLabelView.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.cellImageView.downLoadImage(form: self.user[indexPath.row].imagePath)
        
        return cell
    }
}

    
extension UIImageView {
        func downLoadImage(form imgURL : String){
            let url = URLRequest(url: URL(string : imgURL)!)
            let task = URLSession.shared.dataTask(with: url) {
                (data , response , error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data : data!)
                print("imagedownloaded")
                }
            }
            task.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


