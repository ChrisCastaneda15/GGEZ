//
//  ViewController.swift
//  ChrisCastanedaFinalProject
//
//  Created by Chris Castaneda on 5/4/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var version = "";
    
    let reuseIdentifier = "cellReuse"
    
    @IBOutlet var navBar: [UIView]!
    
    @IBOutlet weak var champListType: UISegmentedControl!
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var statsButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    let animationImages = [UIImage(named: "blueCard")!, UIImage(named: "redCard")!, UIImage(named: "yellowCard")!]
    
    @IBOutlet weak var champCollectionView: UICollectionView!
    
    var yoItsData = NSMutableData();
    
    var selectedChampionID = 0;
    
    var goTo = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in navBar {
            i.hidden = true;
        }
        toolbar.hidden = true;
        statsButton.hidden = true;
        champListType.hidden = true;
        logo.hidden = true;
        loadingImage.animationImages = animationImages;
        loadingImage.animationDuration = 1.0;
        loadingImage.startAnimating();
        
        champCollectionView.backgroundColor = UIColor.clearColor();
        champCollectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier);
        tableView.backgroundColor = UIColor.clearColor();
        // Do any additional setup after loading the view, typically from a nib.
        var urlz = NSURL(string: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?api_key=eed17583-dc5c-4e17-a5c8-611e6a9d3b62")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: true);
        };

    }

 
    var champs: [ChampionInformation] = [];
    var dict: [ Int: ChampionInformation ] = [:]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return champs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // Configure the cell
        if champs.count > 0 {
            cell.champLabel.text = champs[indexPath.row].champName
            cell.champImg.image = champs[indexPath.row].champImage
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        doLoading();
        selectedChampionID = champs[indexPath.row].champID
        goTo = "champDetail";
        performSegueWithIdentifier("toChampDetail", sender: collectionView);
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return champs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TableViewCell
        
        if champs.count > 0 {
            cell.champName.text = champs[indexPath.row].champName
            cell.champImage.image = champs[indexPath.row].champImage
            cell.champTitle.text = "\"\(champs[indexPath.row].champTitle)\""
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedChampionID = champs[indexPath.row].champID
        goTo = "champDetail"
        doLoading();
        performSegueWithIdentifier("toChampDetail", sender: tableView);
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if goTo == "champDetail" {
            let cVC = segue.destinationViewController as! champDetailViewController
            cVC.champInfo = dict[selectedChampionID]!
        }
        else if goTo == "Stats"{
            let sVC = segue.destinationViewController as! summonerStatsViewController
            sVC.dict = self.dict;
        }
        else {
            
        };
    }
    
    override func viewDidDisappear(animated: Bool) {
        doLoading();
        tableView.reloadData();
    }
    
    func doLoading() {
        if loadingView.hidden == true {
            //dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hidden = false;
                self.loadingImage.startAnimating();
            //})
            
        }
        else {
            loadingView.hidden = true;
            loadingImage.stopAnimating();
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if data.length != 0 {
            yoItsData.appendData(data);
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if yoItsData.length != 0 {
            getChamps();

            for (id, info) in dict {
                champs.append(info)
            }
            
            
            champs.sort{ $0.champName.lowercaseString < $1.champName.lowercaseString };
            
            champCollectionView.reloadData();
            tableView.reloadData();
            loadingImage.stopAnimating();
            loadingView.hidden = true;
            for i in navBar {
                i.hidden = false;
            }
            toolbar.hidden = false;
            statsButton.hidden = false;
            champListType.hidden = false;
            logo.hidden = false;
            
            var chizzamps = [String]();
            var kizzys = [String]();
            
            for i in champs {
                chizzamps.append(i.champName);
                kizzys.append(i.champTitle);
            }
            
            NSUserDefaults.standardUserDefaults().setObject(chizzamps, forKey: "champs4Watch");
            NSUserDefaults.standardUserDefaults().setObject(kizzys, forKey: "keys4Watch");
        }
    }
    
    private func getChamps() {
        let response = JSON(data: yoItsData);
        if let vers = response["version"].string {
            version = vers;
            NSUserDefaults.standardUserDefaults().setObject(vers, forKey: "Version");
        }
        if let champions = response["data"].dictionary {
            var n = ""
            var k = ""
            var t = ""
            var idd = 0;
            for i in champions {
                if let name = i.1["name"].string {
                    n = name;
                }
                if let key = i.1["key"].string {
                    k = key;
                }
                if let desc = i.1["title"].string {
                    t = desc;
                }
                if let id = i.1["id"].int {
                    idd = id
                }
                
                dict.updateValue(ChampionInformation(name: n, key: k, title: t, id: idd), forKey: idd);
            }
        }
        
    }

    
    @IBAction func champLayoutChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            tableView.hidden = true;
            champCollectionView.hidden = false;
        }
        else {
            tableView.hidden = false;
            champCollectionView.hidden = true;
        }
    }
    
    
    @IBAction func statsButtonPressed(sender: AnyObject) {
        println("Stats");
        goTo = "Stats";
        performSegueWithIdentifier("toStats", sender: sender);
    }
    
    @IBAction func itemsButtonPressed(sender: AnyObject) {
        println("Items");
        doLoading();
        performSegueWithIdentifier("toItems", sender: sender);
    }
    
    @IBAction func newsButtonPressed(sender: AnyObject) {
        println("News");
        goTo = "News";
        doLoading();
        performSegueWithIdentifier("toNews", sender: sender);
        
    }
    
  
}

