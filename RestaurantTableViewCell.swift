//
//  RestaurantTableViewCell.swift
//  finalProject
//
//  Created by 陈泽 on 2018/10/14.
//  Copyright © 2018 ASU. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var ri: UIImageView!
    @IBOutlet weak var restaurantN: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
