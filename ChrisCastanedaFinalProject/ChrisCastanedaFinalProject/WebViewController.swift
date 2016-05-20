//
//  WebViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/16/16.
//  Copyright © 2016 Chris Castaneda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var championImage: UIImageView!
    
    @IBOutlet weak var VicOrDefeatLabel: UILabel!
    
    @IBOutlet weak var gameTypeLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    //RECIEVERS
    var vic: Bool = false;
    
    var gameType: String = "N/A";
    
    var gameId: Int = 0;
    
    var champUsed: ChampionInformation?;

    override func viewDidLoad() {
        super.viewDidLoad()

        if vic {
            VicOrDefeatLabel.text = "Victory"
        }
        else {
            VicOrDefeatLabel.text = "Defeat"
        }
        
        gameTypeLabel.text = gameType;
        championImage.image = champUsed?.champImage;
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://matchhistory.na.leagueoflegends.com/en/#match-details/NA1/\(gameId)/1?tab=overview")!))
    }

    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    

}
