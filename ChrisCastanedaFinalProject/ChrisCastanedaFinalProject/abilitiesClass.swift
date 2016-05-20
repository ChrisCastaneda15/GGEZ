//
//  abilitiesClass.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/11/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit


class Ability {
    var abilityName: String;
    var abilityImage: UIImage?;
    var abilityDescription: String;
    var videoLink = "";
    var apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    init(name: String, image: String, desc: String) {
        abilityName = name;
        if let apiVersion = apiVersion {
            abilityImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(apiVersion)/img/spell/\(image)")!)!)
        }
        
        abilityDescription = desc;
    }
}

class PassiveAbility {
    var abilityName: String;
    var abilityImage: UIImage?;
    var abilityDescription: String;
    var videoLink = "";
     var apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    init(name: String, image: String, desc: String) {
        abilityName = name;
        let i = image.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        if let apiVersion = apiVersion {
            abilityImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(apiVersion)/img/passive/\(i)")!)!)
        }
        
        abilityDescription = desc;
    }
}
