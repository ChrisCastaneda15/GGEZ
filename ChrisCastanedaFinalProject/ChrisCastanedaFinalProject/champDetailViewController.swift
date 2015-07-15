//
//  champDetailViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/11/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class champDetailViewController: UIViewController,  NSURLConnectionDataDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var champSplash: UIImageView!
    
    @IBOutlet weak var champName: UILabel!
    
    @IBOutlet weak var champTitle: UILabel!
    
    @IBOutlet var abilities: [UIImageView]!
    
    @IBOutlet weak var abilityNameLabel: UILabel!
    
    @IBOutlet weak var abilityDescription: UITextView!
    
    @IBOutlet var champTags: [UILabel]!
    
    @IBOutlet weak var dataScrollView: UIScrollView!
    
    @IBOutlet weak var swipeToSeeLabel: UILabel!
    
    
    var champInfo = ChampionInformation();
    
    var champData = NSMutableData();
    
    var info = champDetailInformation(pass: PassiveAbility(name: "Passive", image: "Ashe_P.png", desc: ""), spells: [Int : Ability](), tags: [""], tips: [[""]], stats: ChampStatsClass(stats: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]), lore: "");

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlz = NSURL(string: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/\(champInfo.champID)?champData=all&api_key=eed17583-dc5c-4e17-a5c8-611e6a9d3b62")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: true);
        };
        
        champName.text = champInfo.champName
        champTitle.text = "\"\(champInfo.champTitle)\""
        champSplash.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(champInfo.champKey)_0.jpg")!)!);
        var colors = [ "VIEW", "TEXT"]
        var frame: CGRect = CGRectMake(0, 0, 0, 0)
        
        for index in 0..<colors.count {
            
            frame.origin.x = self.dataScrollView.frame.size.width * CGFloat(index)
            frame.size = self.dataScrollView.frame.size
            //self.dataScrollView.pagingEnabled = true
            
            if colors[index] == "TEXT" {
                var textView = UITextView(frame: frame);
                textView.backgroundColor = UIColor(red: CGFloat(222.0/255.0), green: CGFloat(222.0/255.0), blue: CGFloat(191.0/255.0), alpha: 1.0);
                self.dataScrollView.addSubview(textView)

            }
            else {
                var op = NSBundle.mainBundle().loadNibNamed("ChampStatsView", owner: self, options: nil)[0] as? ChampStatsView;
                op?.frame = frame
                self.dataScrollView.addSubview(op!);
            }
        }
        
        
        dataScrollView.contentSize = CGSizeMake(self.dataScrollView.frame.size.width * CGFloat(colors.count), self.dataScrollView.frame.size.height);
        // Do any additional setup after loading the view.
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
            
            abilities[0].image = info.passive.abilityImage;
            println(info.passive.abilityImage);
            for i in 1...4 {
                if let aimg = info.abilites[(i - 1)]?.abilityImage {
                    println(aimg);
                    abilities[i].image = aimg;
                }
                abilities[i].layer.borderColor = UIColor.yellowColor().CGColor;
            }
            
            abilities[0].layer.borderColor = UIColor.yellowColor().CGColor;
            abilities[0].layer.borderWidth = 2.0;
            
            abilityNameLabel.text = "Passive - \(info.passive.abilityName)";
            abilityDescription.text = info.passive.abilityDescription;
            abilityDescription.font = UIFont(name: "Helvetica", size: 15.0);
            
            champTags[0].text = info.tags[0];
            if info.tags.count > 1 {
                champTags[1].text = "Secondary: " + info.tags[1];
            }
            else {
                champTags[1].text = "";
            }
            
            for i in dataScrollView.subviews {
                if let view = i as? ChampStatsView {
                    view.healthLabel.text = info.stats.health.description;
                    view.healthRegenLabel.text = info.stats.healthRegen.description;
                    view.manaLabel.text = info.stats.mana.description;
                    view.manaRegenLabel.text = info.stats.manaRegen.description;
                    view.attackDamageLabel.text = info.stats.attackDamage.description;
                    view.attackSpeed.text = info.stats.attackSpeed.description;
                    view.armorLabel.text = info.stats.armor.description;
                    view.mrLabel.text = info.stats.magicResist.description;
                    view.moveSpeedLabel.text = info.stats.moveSpeed.description;
                }
                
                if let view = i as? UITextView {
                    var yuyuyu = info.lore.componentsSeparatedByString("<br><br>");
                    var newText = "";
                    var loreText = "";
                    
                    for i in yuyuyu {
                        newText += "\(i)\n\n";
                    }
                    for i in newText.componentsSeparatedByString("<br>") {
                        loreText += "\(i)\n"
                    }
                    view.text = loreText;
                    view.font = UIFont(name: "Helvetica", size: 15.0);
                    view.editable = false;
                    view.selectable = false;
                }
            }
        }
    }
    
    func getChampInfo () {
        let response = JSON(data: champData);
        var passiveInfo = [String]()
        var abilityDict = [Int: Ability]();
        var t = [String]()
        var h = [[String](), [String]()];
        var s = [Double]();
        var l = "";
        var count = 0;
        
        if let info = response.dictionary {
            if let lore = info["lore"]!.string {
                l = lore;
            }
            if let stats = info["stats"]!.dictionary {
                var statttssss = ["hp", "hpregen", "mp", "mpregen", "attackdamage", "attackspeedoffset", "armor", "spellblock", "movespeed"]
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
            if let spells = info["spells"]!.array {
                for i in spells {
                    var n = i["name"].string!
                    var imgz = ""
                    var d = i["sanitizedDescription"].string!
                    if let name = i["image"].dictionary {
                        if let img = name["full"]!.string {
                            imgz = img;
                        }
                        abilityDict.updateValue(Ability(name: n, image: imgz, desc: d), forKey: count);
                        ++count;
                    }
                }
            }
        }
        if passiveInfo.count != 0 && abilityDict.count != 0 {
            info = champDetailInformation(pass: PassiveAbility(name: passiveInfo[0], image: passiveInfo[1], desc: passiveInfo[2]), spells: abilityDict, tags: t, tips: h, stats: ChampStatsClass(stats: s), lore: l);

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
            var a = sender.tag - 1;
            abilityNameLabel.text = abilityButtons[sender.tag] + info.abilites[a]!.abilityName;
            abilityDescription.text = info.abilites[a]!.abilityDescription;
        }
        abilityDescription.font = UIFont(name: "Helvetica", size: 15.0)
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //swipeToSeeLabel.hidden = true;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
