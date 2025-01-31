//
//  ManageBeaconsViewController.swift
//  InformME
//
//  Created by Amal Ibrahim on 2/5/16.
//  Copyright © 2016 King Saud University. All rights reserved.
//

import Foundation

import UIKit


class ManageBeaconsViewController: CenterViewController,UITableViewDataSource, UITableViewDelegate, BeaconCellDelegate  {
    
    
    var values:NSMutableArray = []
    var Labels : [String] = []
    var beaconsInfo:NSMutableArray=[]
    var UserID: Int = NSUserDefaults.standardUserDefaults().integerForKey("id");
    var UID : [String] = []
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(Reachability.isConnectedToNetwork()){
            get();}
        else {
            self.displayAlert("", message: "الرجاء الاتصال بالانترنت")
        }
        tableView.reloadData()
        self.navigationItem.title = "إدارة بيكون"
        //setup tint color for tha back button.
            }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "موافق", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }//end fun display alert
    
    
    

    func get(){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://bemyeyes.co/API/beacon/SelectBeacon.php")!)
        
        request.HTTPMethod = "POST"
        let postString = "uid=\(UserID)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let urlContent = data {
                
                do {
                    
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    for x in 0 ..< jsonResult.count {
                        let beacon: Beacon = Beacon()
                        let l : AnyObject = jsonResult[x]["Label"]as! String
                        let m : AnyObject = jsonResult[x]["Major"]as! String
                        let mi : AnyObject = jsonResult[x]["Minor"]as! String
                        let id : AnyObject = jsonResult[x]["UserID"]as! String
                        
                        beacon.Label=l as! String
                        beacon.Major=m as! String
                        beacon.Minor=mi as! String
                        self.values.addObject(beacon)
                        self.beaconsInfo.addObject(beacon)
                        self.Labels.append(l as! String)
                        self.UID.append(id as! String)
                        
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()}
                    
                } catch {
                    
                    print("JSON serialization failed")
                    
                }
            }
        }
        task.resume()
        tableView.reloadData()
    }
    
    func addBeacon(){
        performSegueWithIdentifier("addBeacon", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as! BeaconTableCellViewController
        var b: Beacon = Beacon()
        b = self.values[indexPath.row] as! Beacon
        
        cell.name.text = b.Label+" \n القيمة الأساسية:"+b.Major+" \n القيمة الثانوية: "+b.Minor as String
        tableView.rowHeight = 60
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count;
    }
    
    
    // Update Beacon
    func updateBeacon(){
        performSegueWithIdentifier("updateBeacon", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "updateBeacon") {
            let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)
            let cellIndexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
            print(cellIndexPath?.row)
            var b : Beacon = Beacon()
            b=beaconsInfo[(cellIndexPath?.row)!] as! Beacon
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! UpdateBeaconViewController;
            detailVC.llabel=b.Label
            detailVC.mmajor=b.Major
            detailVC.mminor=b.Minor
            detailVC.labels = Labels
            detailVC.UID = UID
            
        }
        
        if (segue.identifier == "addBeacon") {
            let detailVC = segue.destinationViewController as! AddBeaconViewController
            detailVC.labels = Labels
            detailVC.UID = UID

            
        }
        
    }
    
    func deleteBeacon(label: String) {
        let b: Beacon = Beacon()
        b.deleteBeacon(label)
        self.tableView.reloadData()
    }
    
    /*  func updateBeacon() {
     //   code
     }*/
    
}