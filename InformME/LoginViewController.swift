//
//  ViewController.swift
//  InformME
//
//  Created by Amal Ibrahim on 1/28/16.
//  Copyright © 2016 King Saud University. All rights reserved.
//

import UIKit
import Foundation


class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
/*Hello : ) */
    
    
    
    
    @IBOutlet var emailfiled: UITextField!
    @IBOutlet var passwordfiled: UITextField!
    
    
    @IBOutlet  var typefiled: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailfiled.delegate = self
        passwordfiled.delegate = self
        // Do any additional setup after loading the view.
        
    }// end fun viewDidLoad
    
    
    @IBAction func login(sender: AnyObject) {
        
        var email = emailfiled.text!
        var password = passwordfiled.text!
        var type: Int
        type = -1;
        
        if (typefiled.selectedSegmentIndex == 0 ){
            type = 0; }
            
        else if ( typefiled.selectedSegmentIndex == 1  ){    type = 1; }
        
        
        
        if (email.isEmpty || password.isEmpty || type == -1 ) {
              displayAlert("", message: "يرجى إدخال كافة الحقول")
        }
            
        else {
            
            var flag: Bool
            flag = false
            var current: Authentication = Authentication();
            
            //Wher use a completion handler here in order to make sure we got the latest value of flag.
            current.login( email, Passoword: password, Type: type) {
                (login:Bool) in
                //we should perform all segues in the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    flag = login
                    self.performSegue(flag,type: type)}
                print("I am happy",login,flag)
                        }
                print("I am Here")
        
        }

    }// end fun login
    
  
    func performSegue(flag: Bool, type: Int) {
        print("Is it")
        if ( flag  && type == 1) {
            print("here1")

            self.performSegueWithIdentifier("homepage", sender: self)
            
        }
            
        else if ( flag && type == 0) {
            print("here2")
            self.performSegueWithIdentifier("homepage2", sender: self)
            
        }
            
        else if ( !flag ) {
            print("here3")

            self.displayAlert("", message: " البريد الإلكتروني أو كلمة المرور غير صحيحة")
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   
    }//end fun didReciveMemory warining

    
    
    //for alert massge

    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "موافق", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }//end fun display alert
    
    
    
    
    
    
// *** for keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
}
// *** for keyboard
    
}//end class
