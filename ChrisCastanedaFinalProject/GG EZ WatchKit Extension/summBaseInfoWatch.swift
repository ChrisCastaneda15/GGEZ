//
//  summBaseInfoWatch.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/20/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class summonerBaseInfo: NSCoding {
    var name: String;
    var id: Int;
    var icon: String;
    let version = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject("", forKey: "name");
        aCoder.encodeInt(0, forKey: "id");
        aCoder.encodeObject("", forKey: "icon");
    }
    @objc required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as? String ?? "";
        self.id = Int(aDecoder.decodeIntForKey("id"));
        self.icon = aDecoder.decodeObjectForKey("icon") as? String ?? "http://ddragon.leagueoflegends.com/cdn/5.9.1/img/profileicon/759.png";
    }
    
    init (name: String, id: Int, icon: Int) {
        self.name = name;
        self.id = id;
        self.icon = "http://ddragon.leagueoflegends.com/cdn/\(version!)/img/profileicon/\(icon).png"
    }
}
