//
//  ManageEventsViewController.swift
//  InformME
//
//  Created by Amal Ibrahim on 2/5/16.
//  Copyright © 2016 King Saud University. All rights reserved.
//

import Foundation

import UIKit

class ManageEventsViewController: CenterViewController , UITableViewDataSource, UITableViewDelegate, EventCellDelegate {
    /*Hello : ) */
    
    @IBOutlet var tableView: UITableView!
  
    @IBOutlet weak var menuButton: UIBarButtonItem!
     var eventsInfo: [Event] = []
    var event:Event = Event()
    var UserID: Int = NSUserDefaults.standardUserDefaults().integerForKey("id");
    override func viewDidLoad() {
        print(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        if (Reachability.isConnectedToNetwork()){
        event.requesteventlist(UserID){
            (eventsInfo:[Event]) in
            dispatch_async(dispatch_get_main_queue()) {
                self.eventsInfo = eventsInfo
                self.tableView.reloadData()
            }
            
        }
    }
    else {
    self.displayAlert("", message: "الرجاء الاتصال بالانترنت")
    
    }
        print("I am Back")
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData();
        
        //setup tint color for tha back button.
    }
    
   
  
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "موافق", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }//end fun display alert
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    // TODO: Check the dynamic table tutorial in Google Drive it will help a lot.
    // MARK: --- Table Functions ---
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableCellViewController
        var e : Event = Event()
        e=eventsInfo[(indexPath.row)]
        print(e.name)
       
        cell.name.text = e.name
        
        return cell


    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: this number should be changed to the actual number of recieved events.
          return eventsInfo.count;
    }
    
    
   
    // MARK: --- Go Event Page ---
    func showEventDetails() {
        performSegueWithIdentifier("showEventDetails", sender: self)
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "showEventDetails") {
        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
     
        var e : Event = Event()
        e=eventsInfo[(cellIndexPath?.row)!]

            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! EventDetailsViewController;
           detailVC.evid = e.id
           detailVC.evname=e.name
           detailVC.evwebsite=e.website
           detailVC.evdate=e.date
           detailVC.event = e
           detailVC.evlogo=e.logo
        }
}
    
    }