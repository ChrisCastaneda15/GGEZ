//
//  champClasses.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/11/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class ChampionInformation {
    var champName: String;
    var champTitle: String;
    var champImage: UIImage?;
    var champID: Int;
    var champKey: String;
    var apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    init(name: String, key: String, title: String, id: Int) {
        champName = name;
        champKey = key;
        champTitle = title;
        champID = id;
        if let apiVersion = apiVersion {
             champImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(apiVersion)/img/champion/\(key).png")!)!)
        }
    }
    
    init() {
        champName = "";
        champKey = "";
        champTitle = "";
        champID = 0;
        if let apiVersion = apiVersion {
            champImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(apiVersion)/img/champion/Ashe.png")!)!)
        }
    }
}

class champDetailInformation {
    var passive: PassiveAbility;
    var abilites: [Int : Ability];
    var tags: [String];
    var tips: [[String]];
    var stats: ChampStatsClass;
    var lore: String;
    var basicStats: [Int]
    
    init(pass: PassiveAbility, spells: [Int: Ability], tags: [String], tips: [[String]], stats: ChampStatsClass, lore: String, baseStats: [Int]) {
        passive = pass;
        abilites = spells;
        self.tags = tags;
        self.tips = tips;
        self.stats = stats;
        self.lore = lore;
        basicStats = baseStats;
    }
    
}



