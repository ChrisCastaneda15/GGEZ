//
//  newsViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/15/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit
import Parse

class newsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let reuseIdentifier = "cellReuse"
    
    var array: [Article] = []
    var selectedArticle = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "newsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier);
        
        let query = PFQuery(className:"LoL_News")
        
        for i in query.findObjects()! {
            let title = i["Title"] as! String;
            let date = i["dateString"] as! String;
            let image = i["imgURL"] as! String;
            let url = i["URL"] as! String;
            let date1 = i["Posted"] as! NSDate;
            
            array.append(Article(title: title, date: date, image: image, url: url, date1: date1));
        }
        
        
        array.sortInPlace { (lhs: Article, rhs: Article) -> Bool in
            lhs.articleDate.compare(rhs.articleDate) == NSComparisonResult.OrderedDescending
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return array.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! newsTableViewCell
        
        // Configure the cell...
        cell.articleTitle.text = array[indexPath.row].articleTitle;
        cell.articleDate.text = array[indexPath.row].articleDate.description;
        cell.articleImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: array[indexPath.row].articleImage)!)!)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArticle = indexPath.row
        performSegueWithIdentifier("toArticle", sender: tableView);
    }
    
    var champs = [String]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let aVC = segue.destinationViewController as! articleViewController;
        
        aVC.url = NSURL(string: array[selectedArticle].articleURL);
        aVC.titlez = array[selectedArticle].articleTitle;
    }
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    
}
