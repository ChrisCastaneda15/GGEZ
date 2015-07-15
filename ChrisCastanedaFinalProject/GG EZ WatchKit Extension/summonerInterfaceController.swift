//
//  summonerInterfaceController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/18/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import WatchKit
import Foundation

class matchRow: NSObject {
    @IBOutlet weak var champLabel: WKInterfaceLabel!
    @IBOutlet weak var kdaLabel: WKInterfaceLabel!
}

class summonerInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var summonerIcon: WKInterfaceImage!
    
    @IBOutlet weak var summonerName: WKInterfaceLabel!
    
    @IBOutlet weak var summonerLevel: WKInterfaceLabel!
    
    @IBOutlet weak var recentTable: WKInterfaceTable!
    
    var defaults4Watch = NSUserDefaults(suiteName: "group.GG-EZ");
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var summonersName = defaults4Watch!.stringForKey("summonerName4Watch");
        var summonersLevel = defaults4Watch!.stringForKey("summonerLevel4Watch");
        var summonersIcon = defaults4Watch!.stringForKey("summonerIcon4Watch");
        
        
        // Configure interface objects here.
        summonerName.setText(summonersName);
        summonerLevel.setText(summonersLevel);
        summonerIcon.setImageData(NSData(contentsOfURL: NSURL(string: summonersIcon!)!)!)
        reloadTable();
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        var summonersName = defaults4Watch!.stringForKey("summonerName4Watch");
        var summonersLevel = defaults4Watch!.stringForKey("summonerLevel4Watch");
        var summonersIcon = defaults4Watch!.stringForKey("summonerIcon4Watch");
        summonerName.setText(summonersName);
        summonerLevel.setText("LvL: \(summonersLevel!)");
        summonerIcon.setImageData(NSData(contentsOfURL: NSURL(string: summonersIcon!)!)!)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func reloadTable() {
        // 1
//        var matches = [String]();
        var champs = defaults4Watch?.stringArrayForKey("rmChampArray4Watch") as! [String];
        var kills = defaults4Watch?.stringArrayForKey("rmKillArray4Watch") as! [String];
        var deaths = defaults4Watch?.stringArrayForKey("rmDeathArray4Watch") as! [String];
        var assists = defaults4Watch?.stringArrayForKey("rmAssistArray4Watch") as! [String];
        
        
        recentTable.setNumberOfRows(champs.count, withRowType: "GameRow")
        for i in 0..<recentTable.numberOfRows {
            if let row = recentTable.rowControllerAtIndex(i) as? matchRow {
                // 3
                row.champLabel.setText(champs[i]);
                row.kdaLabel.setText("\(kills[i])/\(deaths[i])/\(assists[i])");
            }
        }
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println(rowIndex);
    }
    
}
