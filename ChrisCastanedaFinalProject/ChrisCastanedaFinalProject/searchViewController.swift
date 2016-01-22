//
//  searchViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/27/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit
import Parse

class searchViewController: UIViewController, NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var query = PFQuery(className:"apiKey");
    var key = "";
    
    @IBOutlet weak var summonerNameLabel: UILabel!
    @IBOutlet weak var summonerImageLabel: UIImageView!
    @IBOutlet weak var summonerLevelLabel: UILabel!
    
    @IBOutlet weak var summonerField: UITextField!
    
    @IBOutlet weak var leagueIcon: UIImageView!
    
    @IBOutlet weak var leagueLabel: UILabel!
    
    @IBOutlet weak var lpLabel: UILabel!
    
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var theIdIs = 0;
    var sumIs = "";
    
    var conQAwwShit = dispatch_queue_create("com.castaneda.imageShit", DISPATCH_QUEUE_CONCURRENT);
    
    let apiVersion = NSUserDefaults.standardUserDefaults().stringForKey("Version");
    
    var dict: [ Int: ChampionInformation ] = [:]
    
    var theIDis = 0;
    
    var summonerData = NSMutableData();
    
    var recentData = NSMutableData();
    
    var leagueData = NSMutableData();
    
    var recentCon = NSURLConnection();
    
    var leagueCon = NSURLConnection();
    
    var recentMatches = [LoLMatch]();
    
    var summoner: summonerBaseInfo? = nil;
    var summLevel = 0;
    var lP: Int? = nil;
    var div: String? = nil;
    var tier: String? = nil;
    var qName: String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var a = [PFObject]();
        do{
            try a = query.findObjects()
            for i in a {
                key = i["key"] as! String;
            }
        }
        catch{
            print(error);
        }
        tableView.registerNib(UINib(nibName: "recentTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReuse");
        // Do any additional setup after loading the view.
        tableView.backgroundView?.backgroundColor = UIColor.clearColor();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchThatName(sender: AnyObject) {
        summonerField.enabled = false;
        let entered = summonerField.text!.lowercaseString;
        var actual = "";
        summonerField.text = "";
        for i in entered.componentsSeparatedByString(" "){
            actual += i;
        };

        sumIs = actual;
        
        print(actual);
        
        let urlz = NSURL(string: "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(actual)?api_key=\(key)")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: false)!;
            connection.start();
        };
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if data != 0 {
            if connection == recentCon {
                recentData.appendData(data);
            }
            else if connection == leagueCon {
                leagueData.appendData(data);
            }
            else {
                summonerData.appendData(data);
            }
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if summonerData.length != 0 {
            getSummoner();
            summonerNameLabel.text = summoner?.name
            summonerLevelLabel.text = "Level: \(summLevel)"
            summonerLevelLabel.hidden = false;
            let conQ = dispatch_queue_create("com.castaneda.GG-EZ", DISPATCH_QUEUE_CONCURRENT);
            
            dispatch_async(conQ, {
                var iconURL = UIImage()
                if let url = self.summoner?.icon, let nUrl = NSURL(string: url), let nData = NSData(contentsOfURL: nUrl), let icon = UIImage(data: nData) {
                    iconURL = icon;
                }
                else {
                    iconURL = UIImage(named: "noIcon")!
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.summonerImageLabel.image = iconURL;
                    self.summonerImageLabel.hidden = false;
                })
            })
            
            startLeague();
            startRecent();
            
            summonerData = NSMutableData();
        }
        else if recentData.length != 0 {
            getRecentMatches();
            tableView.hidden = false;
            tableView.reloadData();
            recentData = NSMutableData();
        }
        else if leagueData.length != 0 {
            getLeague();
            if let tier = tier, let div = div, let qName = qName, let lP = lP {
                leagueLabel.text = tier.capitalizedString + " " + div;
                leagueName.text = "\"\(qName)\"";
                lpLabel.text = "\(lP) LP"
                dispatch_async(conQAwwShit, {
                    var num = 5;
                    switch div {
                    case "I":
                        num = 1;
                    case "II":
                        num = 2;
                    case "III":
                        num = 3;
                    case "IV":
                        num = 4;
                    default:
                        num = 5;
                    }
                    let lImg = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://sk2.op.gg/images/medals/\(tier)_\(num).png")!)!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.leagueIcon.hidden = false;
                        self.leagueIcon.image = lImg;
                    })
                })
            }
            else {
                lP = nil;
                div = nil;
                tier = nil;
                qName = nil;
                leagueLabel.text = ""
                leagueName.text = ""
                lpLabel.text = ""
                leagueIcon.hidden = true;
            }
            
            leagueData = NSMutableData();
        }

    }
    
    func getSummoner() {
        let response = JSON(data: summonerData);
        
        var sName = "";
        var sId = 0;
        var sIcon = 0;
        
        if let info = response.dictionary {
            if let sumIn = info["\(sumIs)"] {
                if let name = sumIn["name"].string {
                    //println(name);
                    sName = name;
                }
                if let id = sumIn["id"].int {
                    theIDis = id;
                    sId = id;
                }
                if let icon = sumIn["profileIconId"].int {
                    //println(icon);
                    sIcon = icon;
                }
                if let level = sumIn["summonerLevel"].int {
                    summLevel = level;
                }
            }
            if sName != "" {
                summoner = summonerBaseInfo(name: sName, id: sId, icon: sIcon);
            }
        }
    }
    
    func getLeague() {
        let response = JSON(data: leagueData);
        if let me = response["\(theIDis)"].array {
            if let entries = me[0].dictionary {
                tier = entries["tier"]!.string!.lowercaseString;
                print(tier);
                qName = entries["name"]!.string!;
                if let mahEnt = entries["entries"]!.array {
                    for i in mahEnt {
                        if Int(i["playerOrTeamId"].string!) == theIDis {
                            div = i["division"].string!;
                            lP = i["leaguePoints"].int!;
                        }
                    }
                }
            }
        }
        else {
            lP = nil;
            div = nil;
            tier = nil;
            qName = nil;
        }
        
    }
    
    func getRecentMatches() {
        let response = JSON(data: recentData);
        
        if let games = response["games"].array {
            var gameType = "";
            var gameId = 0;
            var date = 0;
            var championId = 0;
            var spells = [Int]();
            var level = 0;
            var deaths = 0;
            var kills = 0;
            var assists = 0;
            var win = true;
            var items = [Int]();
            var length = 0;
            
            for info in games {
                gameType = info["gameMode"].string! + "(" + info["subType"].string! + ")";
                gameId = info["gameId"].int!;
                date = info["createDate"].int!;
                championId = info["championId"].int!;
                spells = [info["spell1"].int!, info["spell2"].int!];
                if let stats = info["stats"].dictionary {
                    level = stats["level"]!.int!;
                    
                    if let d = stats["numDeaths"]?.int {
                        deaths = d;
                    }
                    else {
                        deaths = 0;
                    }
                    if let k = stats["championsKilled"]?.int {
                        kills = k;
                    }
                    else {
                        kills = 0;
                    }
                    if let a = stats["assists"]?.int {
                        assists = a;
                    }
                    else {
                        assists = 0;
                    }
                    win = stats["win"]!.bool!
                    
                    for num in 0...6 {
                        if let item = stats["item\(num)"]?.int {
                            items.append(item);
                        }
                        else {
                            items.append(-1);
                        }
                    }
                    length = info["stats"]["timePlayed"].int!
                }
                
                let daMatch = LoLMatch(gameType: gameType, gameId: gameId, date: date, champID: championId,level: level, deaths: deaths, kills: kills, assists: assists, win: win, length: length);
                daMatch.getThoseImages(conQAwwShit, tV: tableView, items: items, spells: spells)
                recentMatches.append(daMatch);
                items = [Int]();
                spells = [Int]()
            }
        }
    }

    func startRecent () {
        let urlz = NSURL(string: "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/\(theIDis)/recent?api_key=\(key)")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            recentCon = NSURLConnection(request: request, delegate: self, startImmediately: false)!;
            recentCon.start();
        };
        
    }
    
    func startLeague () {
        let urlz = NSURL(string: "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/\(theIDis)?api_key=\(key)")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            leagueCon = NSURLConnection(request: request, delegate: self, startImmediately: false)!;
            leagueCon.start();
        };
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMatches.count
    }
    
    func formatSeconds (seconds : Int) -> (hours: Int, minutes: String, secs: String) {
        var m = ((seconds % 3600) / 60).description;
        if Int(m) < 10 {
            m = "0\((seconds % 3600) / 60)";
        }
        var s = ((seconds % 3600) % 60).description;
        if Int(s) < 10 {
            s = "0\((seconds % 3600) % 60)";
        }
        
        return (seconds / 3600, m, s)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellReuse", forIndexPath: indexPath) as! recentTableViewCell;
        
        if recentMatches.count > 0 {
            let theStuff = dict[recentMatches[indexPath.row].championId]!
            
            if recentMatches[indexPath.row].win == true {
                cell.bView.layer.backgroundColor = UIColor(red: 33.0/255.0, green: 125.0/255.0, blue: 56.0/255.0, alpha: 1.0).CGColor;
            }
            else {
                cell.bView.layer.backgroundColor = UIColor.redColor().CGColor;
            }
            
            cell.champName.text = theStuff.champName;
            cell.champLevel.text = recentMatches[indexPath.row].level.description;
            cell.gameType.text = recentMatches[indexPath.row].gameType
            cell.score.text = "\(recentMatches[indexPath.row].kills)/\(recentMatches[indexPath.row].deaths)/\(recentMatches[indexPath.row].assists)";
            if recentMatches[indexPath.row].deaths == 0 {
                cell.kda.text = "(Perfect KDA)"
            }
            else {
                let ka = Double(recentMatches[indexPath.row].kills + recentMatches[indexPath.row].assists)
                let d = Double(recentMatches[indexPath.row].deaths)
                cell.kda.text = "(\(Double(round(100*(ka/d))/100)) : 1 KDA)";
            }
            
            let time = formatSeconds(recentMatches[indexPath.row].length);
            if time.hours == 0 {
                cell.timePlayedLabel.text = "\(time.minutes):\(time.secs)";
            }
            else {
                cell.timePlayedLabel.text = "\(time.hours):\(time.minutes):\(time.secs)";
            }
            
            cell.champImage.image = theStuff.champImage;
            
            let date = NSDate(timeIntervalSince1970: NSTimeInterval((recentMatches[indexPath.row].date)) / 1000);
            let dateForm = NSDateFormatter()
            dateForm.dateStyle = NSDateFormatterStyle.ShortStyle;
            
            cell.dateLabel.text = dateForm.stringFromDate(date);
            
            for i in 0...6 {
                cell.items[i].image = recentMatches[indexPath.row].items?[i]
            }
            
            for i in 0...1 {
                cell.spells[i].image = recentMatches[indexPath.row].spells?[i];
            }
            
        }
        return cell
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    

}


