//
//  articleViewController.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/15/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit
import Social

class articleViewController: UIViewController, UIWebViewDelegate, UIActionSheetDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingAnimation: UIImageView!
    let animationImages = [UIImage(named: "blueCard")!, UIImage(named: "redCard")!, UIImage(named: "yellowCard")!]
    
    var url = NSURL(string: "");
    var titlez = "";
    var textForSocial = "";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadingAnimation.animationImages = animationImages;
        loadingAnimation.animationDuration = 1.0;
        loadingAnimation.startAnimating();
        
        textForSocial = "Check out this link!"
        navigationItem.title = titlez;
        // Go to safari
        //UIApplication.sharedApplication().openURL(url!);
        
        webView.loadRequest(NSURLRequest(URL: url!))
        //webView.scrollView.pagingEnabled = true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingAnimation.stopAnimating();
        loadingView.hidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject) {
        println("SHARE");
        var actionSheet = UIAlertController(title: "Share", message: nil, preferredStyle: .ActionSheet);
        actionSheet.addAction(UIAlertAction(title: "Open in Safari", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            UIApplication.sharedApplication().openURL(url!);
        }));
        actionSheet.addAction(UIAlertAction(title: "Share on Facebook", style: .Default, handler: { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                var facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook);
                println(facebook.setInitialText(self.textForSocial));
                println(self.textForSocial);
                facebook.addURL(self.url);
                self.presentViewController(facebook, animated: true, completion: nil);
            }
            else {
                println("error")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Share on Twitter", style: .Default, handler: { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                var twitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter);
                twitter.setInitialText(self.textForSocial);
                twitter.addURL(self.url);
                self.presentViewController(twitter, animated: true, completion: nil);
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Copy Link to Clipboard", style: .Default, handler: { (action) -> Void in
            println(self.url?.description);
            UIPasteboard.generalPasteboard().string = self.url!.description;
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil);
    }
    
    

}
