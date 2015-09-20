//
//  GlanceController.swift
//  GG EZ WatchKit Extension
//
//  Created by Chris Castaneda on 5/18/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var summonerIcon: WKInterfaceImage!
    @IBOutlet weak var summonerName: WKInterfaceLabel!
    @IBOutlet weak var summonerLevel: WKInterfaceLabel!
    
    var defaults4Watch = NSUserDefaults(suiteName: "group.GG-EZ");

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        let summonersName = defaults4Watch!.stringForKey("summonerName4Watch");
        let summonersLevel = defaults4Watch!.stringForKey("summonerLevel4Watch");
        let summonersIcon = defaults4Watch!.stringForKey("summonerIcon4Watch");
        
        summonerName.setText(summonersName);
        summonerLevel.setText("LvL. \(summonersLevel!)");
        summonerIcon.setImageData(NSData(contentsOfURL: NSURL(string: summonersIcon!)!)!)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let summonersName = defaults4Watch!.stringForKey("summonerName4Watch");
        let summonersLevel = defaults4Watch!.stringForKey("summonerLevel4Watch");
        let summonersIcon = defaults4Watch!.stringForKey("summonerIcon4Watch");
        
        summonerName.setText(summonersName);
        summonerLevel.setText("LvL. \(summonersLevel!)");
        summonerIcon.setImageData(NSData(contentsOfURL: NSURL(string: summonersIcon!)!)!)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
