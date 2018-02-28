//
//  CrypCurrTableViewCell.swift
//  CrypCurr Monitor
//
//  Created by kozlojak-home on 19.02.2018.
//  Copyright © 2018 Kozlojak-dev. All rights reserved.
//

import UIKit

class CrypCurrTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var change24hLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
