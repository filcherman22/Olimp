//
//  CustomTableViewCell.swift
//  Olimp
//
//  Created by Филипп on 24.07.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit


class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
