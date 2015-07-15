//
//  recentTableViewCell.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/22/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class recentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var theView: UIView!
    
    @IBOutlet weak var bView: UIView!
    
    @IBOutlet weak var champImage: UIImageView!
    
    @IBOutlet weak var champLevel: UILabel!
    
    @IBOutlet var spells: [UIImageView]!
    
    @IBOutlet weak var champName: UILabel!
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var kda: UILabel!
    
    @IBOutlet weak var gameType: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timePlayedLabel: UILabel!
    
    @IBOutlet var items: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        theView.layer.cornerRadius = 15.0;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
