//
//  CollectionViewCell.swift
//  ChrisCastanedaFinalProject
//
//  Created by Chris Castaneda on 5/8/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var freeChamp: UIImageView!
    
    @IBOutlet weak var champImg: UIImageView!
    
    @IBOutlet weak var champLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
