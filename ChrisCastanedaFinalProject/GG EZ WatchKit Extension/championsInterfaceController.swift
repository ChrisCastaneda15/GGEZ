//
//  championsInterfaceController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/18/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import WatchKit
import Foundation

class ChampRow: NSObject {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
}


class championsInterfaceController: WKInterfaceController {
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    
    @IBOutlet weak var champTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        reloadTable();
        // Configure interface objects here.
    }
    
    func reloadTable() {
        // 1
        champTable.setNumberOfRows(letters.count, withRowType: "ChampRow")
        for i in 0..<champTable.numberOfRows {
            if let row = champTable.rowControllerAtIndex(i) as? ChampRow {
                // 3
                row.nameLabel.setText("\(letters[i])");
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print(rowIndex);
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
