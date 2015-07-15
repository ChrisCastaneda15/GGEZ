//
//  itemsViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/26/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class itemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDataDelegate {

    @IBOutlet weak var itemsCLView: UICollectionView!
    
    var itemData = NSMutableData();
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCost: UILabel!
    
    @IBOutlet weak var itemDesc: UITextView!
    
    var conQAwwShit = dispatch_queue_create("com.castaneda.itemShit", DISPATCH_QUEUE_CONCURRENT);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCLView.backgroundColor = UIColor.clearColor();
        itemsCLView.registerNib(UINib(nibName: "itemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellReuse");
        // Do any additional setup after loading the view.
        itemDesc.text = "";
        itemName.text = "Select an Item";
        itemCost.text = "";
        
        var urlz = NSURL(string: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/item?itemListData=gold,image,maps&api_key=eed17583-dc5c-4e17-a5c8-611e6a9d3b62")
        
        if let url2 = urlz {
            let request = NSURLRequest(URL: url2);
            
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: true);
        };
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var itemDict: [String : LoLItem] = [:];
    var itemArray = [LoLItem]();
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellReuse", forIndexPath: indexPath) as! itemCollectionViewCell
        
        // Configure the cell
        if itemArray.count > 0 {
            cell.itemName.text = itemArray[indexPath.row].name;
            cell.itemImage.image = itemArray[indexPath.row].image;
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        itemDesc.text = itemArray[indexPath.row].description;
        itemDesc.textColor = UIColor.whiteColor();
        itemName.text = itemArray[indexPath.row].name;
        itemCost.text = "\(itemArray[indexPath.row].goldCost) gold";
        itemImage.image = itemArray[indexPath.row].image;
        println(indexPath.row);
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if data != 0 {
            itemData.appendData(data);
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if itemData != 0 {
            getItems();
            
            for i in itemDict {
                itemArray.append(i.1);
            }
            
            itemArray.sort({ (less: LoLItem, more: LoLItem) -> Bool in
                less.goldCost < more.goldCost;
            })
            
            
            
            itemsCLView.reloadData();
        }
    }
    
    func getItems() {
        let response = JSON(data: itemData);
        var name = "";
        var desc = ""
        var img = "";
        var gold = 0;
        
        if let data = response["data"].dictionary {
            for item in data {
                
                if let maps = item.1["maps"].dictionary, let yeh = maps["1"]?.bool {
                    
                    continue;
                }
                name = item.1["name"].string!;
                if let d = item.1["plaintext"].string {
                    desc = d;
                }
                else {
                    desc = "";
                }
                
                if let cost = item.1["gold"].dictionary {
                    gold = cost["total"]!.int!;
                }
                if let image = item.1["image"].dictionary {
                    img = image["full"]!.string!;
                }
                
                var item = LoLItem(name: name, desc: desc, gold: gold)
                item.getDatImage(conQAwwShit, cV: itemsCLView, img: img);
                itemDict.updateValue(item, forKey: name);
                
            }
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
