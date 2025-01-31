//
//  ManageContentViewController.swift
//  InformME
//
//  Created by sara on 5/4/1437 AH.
//  Copyright © 1437 King Saud University. All rights reserved.
//

import Foundation
import UIKit

class ManageContentsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate ,ContentCellDelegate  {
    
    @IBOutlet var tableView: UITableView!
    
    var contentInfo: [Content] = []
    var content: Content = Content()
    var EID: Int?
    
    
    override func viewDidLoad() {

        content.requestcontentlist(EID!){
            (contentInfo:[Content]) in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentInfo = contentInfo
                self.tableView.reloadData()
            }
            
        }
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        //setup tint color for tha back button.
    }
    

    @IBAction func addcontent(sender: AnyObject) {
        self.performSegueWithIdentifier("addContentbutton", sender: self)
        print("Button PRESSED, segue")
    }
      
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath) as! ContentTableCellViewController
        //var maindata = values[indexPath.row].minor
        var c: Content = Content()
        c = self.contentInfo[indexPath.row] 
        
        cell.Title.text = c.Title
        
        return cell
        
    }
    
    
    func showContentDetails(){
        performSegueWithIdentifier("showContentDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showContentDetails") {
            let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)
            let cellIndexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
            print(cellIndexPath?.row)
            var c : Content = Content()
            c=contentInfo[(cellIndexPath?.row)!] 
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! ContentForOrganizerViewController
            
            detailVC.ttitle=c.Title
            detailVC.abstract=c.Abstract
            detailVC.pdf=c.Pdf
            detailVC.video=c.Video
            detailVC.contentid=c.contentId
            detailVC.images = c.Images
            detailVC.label=c.label
            detailVC.EID = self.EID
            detailVC.like = String(c.like)
            detailVC.dislike = String(c.dislike)
            detailVC.share = String(c.shares)
            detailVC.comment = String(c.comments.count)
            detailVC.content = c
        }
        else if (segue.identifier == "addContentbutton") {
            let addVC = segue.destinationViewController as! AddContentViewController
            addVC.EID =  self.EID!
            print("This is Hi -------------- \(addVC.EID)")
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: this number should be changed to the actual number of recieved events.
        return contentInfo.count;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}