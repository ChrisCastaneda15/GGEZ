//
//  TableViewCell.swift
//  ChrisCastanedaFinalProject
//
//  Created by Chris Castaneda on 5/10/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var champImage: UIImageView!
    
    @IBOutlet weak var champName: UILabel!
    
    @IBOutlet weak var champTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
