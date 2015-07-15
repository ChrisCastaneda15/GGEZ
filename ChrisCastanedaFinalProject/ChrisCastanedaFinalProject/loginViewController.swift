//
//  loginViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/20/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var summonerInput: UITextField!
    
    @IBOutlet weak var enterName: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var summonerData = NSMutableData();
    
    var recentData = NSMutableData();
    
    var summoner: summonerBaseInfo? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true;
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var theAct = "";
    
    @IBAction func login(sender: AnyObject) {
        activityIndicator.hidden = false;
        summonerInput.userInteractionEnabled = false;
        var actual = summonerInput.text.lowercaseString;
        
        for i in actual.componentsSeparatedByString(" "){
            theAct += i;
        };
        println(theAct);
        
        var urlz = NSURL(string: "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(theAct)?api_key=eed17583-dc5c-4e17-a5c8-611e6a9d3b62")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: false);
            connection?.start();
        };
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if data.length != 0 {
            println("yo");
            summonerData.appendData(data);
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if summonerData != 0 {
            summonerInfo();
            if summoner != nil {
                NSUserDefaults.standardUserDefaults().setObject(summoner!.id.description, forKey: "loggedSummonerId");
                performSegueWithIdentifier("backToSumm", sender: self);
            }
            summonerInput.enabled = true;
        }
    }
    
    func summonerInfo () {
       let response = JSON(data: summonerData);
        
        var sName = "";
        var sId = 0;
        var sIcon = 0;
        
        if let info = response.dictionary {
            if let sumIn = info["\(theAct)"] {
                if let name = sumIn["name"].string {
                    sName = name;
                }
                if let id = sumIn["id"].int {
                    sId = id;
                }
                if let icon = sumIn["profileIconId"].int {
                    sIcon = icon;
                }
            }
        }
        
        if sName != "" {
            summoner = summonerBaseInfo(name: sName, id: sId, icon: sIcon);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                self.enterName.textColor = UIColor.redColor();
                self.enterName.text = "Please enter a valid name...";
                self.summonerInput.enabled = true;
            })
            
        }
    }
    
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    

}
