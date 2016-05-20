//
//  matchClass.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/22/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class LoLMatch {
    var gameType: String;
    var gameId: Int;
    var date: Int;
    var championId: Int;
    var spells: [UIImage]?;
    var level: Int;
    var deaths: Int;
    var kills: Int;
    var assists: Int;
    var win: Bool;
    var items: [UIImage]?;
    var length: Int;
    var apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    
    init (gameType: String, gameId: Int, date: Int, champID: Int, level: Int, deaths: Int, kills: Int, assists: Int, win: Bool, length: Int) {
        self.gameType = gameType.stringByReplacingOccurrencesOfString("_SOLO_", withString: " ");
        self.gameId = gameId;
        self.date = date;
        self.championId = champID;
        self.spells = nil;
        self.level = level;
        self.deaths = deaths;
        self.kills = kills;
        self.assists = assists;
        self.win = win;
        self.items = nil;
        self.length = length;
    }
    
    func getThoseImages (q: dispatch_queue_t, tV: UITableView, items: [Int], spells: [Int]) {
        // Spells
        dispatch_async(q, {[weak self, weak tV] in
            var myDict: NSDictionary?
            if let path = NSBundle.mainBundle().pathForResource("stuff", ofType: "plist") {
                myDict = NSDictionary(contentsOfFile: path)
            }
            var s = [UIImage]();
            if let dict = myDict, let strongSelf = self {
                for i in spells {
                    let img: AnyObject = dict["SummonerSpells"]!
                    let c: AnyObject? = img["\(i)"]!
                    s.append(UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(strongSelf.apiVersion!)/img/spell/\(c!).png")!)!)!)
                }
                strongSelf.spells = s;
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                tV?.reloadData();
            })
           

        })
        // Items
        dispatch_async(q, {[weak self, weak tV] in
            var u = [UIImage]();
            if let strongSelf = self {
                for i in items {
                    if i == -1  {
                        u.append(UIImage(named: "noItem")!)
                    }
                    else {
                        let year: Double = 1421853964000;
                        let time: Double = Double(strongSelf.date);
                        if time > year {
                            u.append(UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(strongSelf.apiVersion!)/img/item/\(i).png")!)!)!)
                        }
                        else {
                            u.append(UIImage(named: "noItem")!)
                        }
                    }
                }
                 strongSelf.items = u;
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                tV?.reloadData();
            })
        })
    }
    
}



