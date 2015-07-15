//
//  itemClass.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/27/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class LoLItem {
    var name: String;
    var image: UIImage?;
    var description: String;
    var goldCost: Int;
    var apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    init(name: String, desc: String, gold: Int) {
        self.name = name;
        self.image = nil;
        self.description = desc;
        self.goldCost = gold;
    }
    
    func getDatImage(q: dispatch_queue_t, cV: UICollectionView, img: String){
        dispatch_async(q, {[weak self, weak cV] in
            if let strongSelf = self {
                strongSelf.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(strongSelf.apiVersion!)/img/item/\(img)")!)!)!;
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                cV?.reloadData();
            })
        })
    }

}


