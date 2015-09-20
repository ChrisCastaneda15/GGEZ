//
//  InterfaceController.swift
//  GG EZ WatchKit Extension
//
//  Created by Chris Castaneda on 5/18/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var logoImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        logoImage.setImageNamed("logo");
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func summonerButtonClicked() {
        print("goToSummoner");
        print(NSUserDefaults.standardUserDefaults().stringForKey("Version"));
    }
    
    
    
    @IBAction func championButtonClicked() {
        print("goToChampions");
    }
    
}
