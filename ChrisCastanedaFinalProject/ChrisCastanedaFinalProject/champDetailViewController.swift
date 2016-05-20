//
//  champDetailViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/11/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit
import Parse
import AVKit
import MediaPlayer

class champDetailViewController: UIViewController,  NSURLConnectionDataDelegate, UIScrollViewDelegate {
    
    var query = PFQuery(className:"apiKey");
    var key = "";
    
    @IBOutlet weak var navBar: UIView!
    
    @IBOutlet weak var champImage: UIImageView!
    
    @IBOutlet weak var champSplash: UIImageView!
    
    @IBOutlet weak var champName: UILabel!
    
    @IBOutlet weak var champTitle: UILabel!
    
    @IBOutlet var abilities: [UIImageView]!
    
    var selectedAbility = 1;
    
    @IBOutlet weak var abilityNameLabel: UILabel!
    
    @IBOutlet weak var abilityDescription: UITextView!
    
    @IBOutlet var champTags: [UILabel]!
    
    @IBOutlet weak var vidView: UIView!
    
    var moviePlayer: AVPlayerViewController!
    
    @IBOutlet weak var detVidSegment: UISegmentedControl!
    
    @IBOutlet weak var loreTextView: UITextView!
    
    @IBOutlet weak var statsView: UIView!
    
    //ATTACK VIEWS
    @IBOutlet var attackViews: [UIView]!
    
    @IBOutlet weak var attackLabel: UILabel!
    
    //DEF VIEWS
    @IBOutlet var defenseViews: [UIView]!
    
    @IBOutlet weak var defenseLabel: UILabel!
    
    //ABILITY VIEWS
    @IBOutlet var abilityViews: [UIView]!
    
    @IBOutlet weak var abilityLabel: UILabel!
    
    //DIFFICULTY VIEWS
    @IBOutlet var diffViews: [UIView]!
    
    @IBOutlet weak var diffLabel: UILabel!
    
    var champInfo = ChampionInformation();
    
    var champData = NSMutableData();
    
    var info = champDetailInformation(pass: PassiveAbility(name: "Passive", image: "Ashe_P.png", desc: ""), spells: [Int : Ability](), tags: [""], tips: [[""]], stats: ChampStatsClass(stats: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]), lore: "", baseStats:[0]);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let urlz = NSURL(string: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/\(champInfo.champID)?champData=all&api_key=\(key)")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            _ = NSURLConnection(request: request, delegate: self, startImmediately: true);
        };
        
        
        navBar.layer.shadowColor = UIColor.blackColor().CGColor
        navBar.layer.shadowOpacity = 0.85;
        navBar.layer.shadowRadius = 10;
        champName.text = champInfo.champName
        champTitle.text = "\"\(champInfo.champTitle)\""
        champImage.image = champInfo.champImage;
        champSplash.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(champInfo.champKey)_0.jpg")!)!);
        
        let url = NSURL(string: "https://lolstatic-a.akamaihd.net/champion-abilities/videos/mp4/0119_01.mp4");
        let player = AVPlayer(URL: url!)
        moviePlayer = AVPlayerViewController()
        moviePlayer.player = player
        moviePlayer.showsPlaybackControls = false;
        
        moviePlayer.view.frame = vidView.frame;
        moviePlayer.view.bounds = vidView.frame;
        vidView.addSubview(moviePlayer.view)
        vidView.hidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if data != 0 {
            champData.appendData(data)
        }
        
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if champData != 0 {
            getChampInfo();
            
            var loreString = info.lore;
            loreString = loreString.stringByReplacingOccurrencesOfString("<br>", withString: "\n");
            loreTextView.text = loreString;
            loreTextView.textColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0);
            loreTextView.font = UIFont(name: "Friz Quadrata TT", size: 14)
            loreTextView.textAlignment = .Justified;
            
            abilities[0].image = info.passive.abilityImage;
            print(info.passive.abilityImage);
            for i in 1...4 {
                if let aimg = info.abilites[(i - 1)]?.abilityImage {
                    print(aimg);
                    abilities[i].image = aimg;
                }
                abilities[i].layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0).CGColor;
            }
            
            abilities[0].layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0).CGColor;
            abilities[0].layer.borderWidth = 2.0;
            
            abilityNameLabel.text = "Passive - \(info.passive.abilityName)";
            abilityDescription.text = info.passive.abilityDescription;
            abilityDescription.textColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0);
            abilityDescription.font = UIFont(name: "Friz Quadrata TT", size: 12)
            abilityDescription.textAlignment = .Justified;
    
            champTags[0].text = info.tags[0];
            if info.tags.count > 1 {
                champTags[1].text = "Secondary: " + info.tags[1];
            }
            else {
                champTags[1].text = "";
            }
            
            for aView in 0...(info.basicStats[0] - 1) {
                //RED
                attackViews[aView].backgroundColor = UIColor(red: 211.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0);
            }
            
            attackLabel.text = "Attack Power - " + info.basicStats[0].description;
            
            for dView in 0...(info.basicStats[1] - 1) {
                //GREEN
                defenseViews[dView].backgroundColor = UIColor(red: 56.0/255.0, green: 142.0/255.0, blue: 60.0/255.0, alpha: 1.0);
            }
            
            defenseLabel.text = "Defense Power - " + info.basicStats[1].description;
            
            for mView in 0...(info.basicStats[2] - 1) {
                //BLUE
                abilityViews[mView].backgroundColor = UIColor(red: 25.0/255.0, green: 118.0/255.0, blue: 210.0/255.0, alpha: 1.0);
            }
            
            abilityLabel.text = "Ability Power - " + info.basicStats[2].description;
            
            for difView in 0...(info.basicStats[3] - 1) {
                //PURPLE
                diffViews[difView].backgroundColor = UIColor(red: 81.0/255.0, green: 45.0/255.0, blue: 168.0/255.0, alpha: 1.0);
            }
            
            diffLabel.text = "Difficulty - " + info.basicStats[3].description;
        }
    }
    
    func getChampInfo () {
        let response = JSON(data: champData);
        var passiveInfo = [String]()
        var abilityDict = [Int: Ability]();
        var t = [String]()
        let h = [[String](), [String]()];
        var s = [Double]();
        var b = [Int]();
        var l = "";
        var count = 0;
        
        if let info = response.dictionary {
            if let lore = info["lore"]!.string {
                l = lore;
            }
            if let stats = info["stats"]!.dictionary {
                let statttssss = ["hp", "hpregen", "mp", "mpregen", "attackdamage", "attackspeedoffset", "armor", "spellblock", "movespeed"]
                for i in statttssss {
                    s.append(stats[i]!.double!);
                }
            }
            if let tags = info["tags"]!.array {
                for i in tags {
                    t.append(i.string!);
                }
            }
            if let passive = info["passive"]?.dictionary {
                passiveInfo.append(passive["name"]!.string!);
                if let passiveName = passive["image"]!.dictionary {
                    passiveInfo.append(passiveName["full"]!.string!);
                }
                passiveInfo.append(passive["sanitizedDescription"]!.string!)
            }
            if let base = info["info"]?.dictionary {
                b.append(base["attack"]!.int!);
                b.append(base["defense"]!.int!);
                b.append(base["magic"]!.int!);
                b.append(base["difficulty"]!.int!);
            }
            if let spells = info["spells"]!.array {
                for i in spells {
                    let n = i["name"].string!
                    var imgz = ""
                    let d = i["sanitizedDescription"].string!
                    if let name = i["image"].dictionary {
                        if let img = name["full"]!.string {
                            imgz = img;
                        }
                        abilityDict.updateValue(Ability(name: n, image: imgz, desc: d), forKey: count);
                        count += 1;
                    }
                }
            }
        }
        if passiveInfo.count != 0 && abilityDict.count != 0 {
            info = champDetailInformation(pass: PassiveAbility(name: passiveInfo[0], image: passiveInfo[1], desc: passiveInfo[2]), spells: abilityDict, tags: t, tips: h, stats: ChampStatsClass(stats: s), lore: l, baseStats: b);
            
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func changeDesc(sender: AnyObject) {
        let abilityButtons = ["Passive - ", "Q - ", "W - ", "E - ", "R - "]
        for i in abilities {
            i.layer.borderWidth = 0.0;
        }
        
        abilities[sender.tag].layer.borderWidth = 2.0
        if sender.tag == 0 {
            abilityNameLabel.text = abilityButtons[sender.tag] + info.passive.abilityName;
            abilityDescription.text = info.passive.abilityDescription;
        }
        else {
            let a = sender.tag - 1;
            abilityNameLabel.text = abilityButtons[sender.tag] + info.abilites[a]!.abilityName;
            abilityDescription.text = info.abilites[a]!.abilityDescription;
        }
        abilityDescription.textColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0);
        abilityDescription.font = UIFont(name: "Friz Quadrata TT", size: 12);
        abilityDescription.textAlignment = .Justified;
        selectedAbility = sender.tag + 1;
        detVidSegment.selectedSegmentIndex = 0;
        vidView.hidden = true;
        moviePlayer.player?.pause();
        abilityDescription.hidden = false;
    }
    
    @IBAction func detailVideoSegmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            vidView.hidden = true;
            moviePlayer.player?.pause();
            abilityDescription.hidden = false;
            
        }
        else {
            vidView.hidden = false;
            abilityDescription.hidden = true;
            var vidString = champInfo.champID.description;
            switch vidString.characters.count {
            case 1:
                vidString = "000" + vidString;
                break;
            case 2:
                vidString = "00" + vidString;
            case 3:
                vidString = "0" + vidString;
            default:
                vidString = champInfo.champID.description;
            }
            let url = NSURL(string: "https://lolstatic-a.akamaihd.net/champion-abilities/videos/mp4/\(vidString)_0\(selectedAbility).mp4");
            let player = AVPlayer(URL: url!)
            moviePlayer.player = player
            player.play()
        }
    }
    
    @IBAction func statsLoreSegmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            statsView.hidden = false;
            loreTextView.hidden = true;
        }
        else {
            statsView.hidden = true;
            loreTextView.hidden = false;
        }
    }
    
    
  
    
}
