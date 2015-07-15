//
//  TableViewCell.swift
//  PARSEAPITEST
//
//  Created by Chris Castaneda on 5/6/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class newsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleTitle: UILabel!
    
    @IBOutlet weak var articleDate: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
