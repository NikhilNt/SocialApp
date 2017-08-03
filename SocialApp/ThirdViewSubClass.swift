//
//  ThirdViewSubClass.swift
//  SocialApp
//
//  Created by Nikhil Tanappagol on 7/31/17.
//  Copyright © 2017 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class ThirdViewSubClass: UITableViewCell {

    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var cellLabelView: UILabel!
    
    var userID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
