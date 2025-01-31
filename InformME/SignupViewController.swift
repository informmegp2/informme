//
//  SignupViewController.swift
//  InformME
//
//  Created by Amal Ibrahim on 2/2/16.
//  Copyright © 2016 King Saud University. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    /*Hello : ) */
    
    
    @IBOutlet  var regType: UISegmentedControl!
    @IBOutlet  var regUsername: UITextField!
    @IBOutlet  var regEmail: UITextField!
    
    @IBOutlet var regPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regUsername.delegate = self
        regEmail.delegate = self
        regPassword.delegate = self

        //setup tint color for tha back button.
       
    }// end fun viewDidLoad
    
    
    
    
    @IBAction func register(sender: AnyObject) {
        
        let username = regUsername.text!
        let email = regEmail.text!
        let password = regPassword.text!
        var type: Int
        type = -1;
        var count: Int
        count = password.characters.count
        
        if (regType.selectedSegmentIndex == 0 ){
            type = 0; }
            
        else if ( regType.selectedSegmentIndex == 1  ){    type = 1; }
        
         if (username.isEmpty || email.isEmpty || password.isEmpty || type == -1 ) {
            
          displayAlert("", message: "يرجى إدخال كافة الحقول")

         }// end if chack
            
         else if ( count < 8)
         {
            displayAlert("", message: "يرجى إدخال كلمة مرور لا تقل عن ثمانية أحرف")

            
         }//end else if
         else if (isValidEmail(email) == false) {
            
            displayAlert("", message: "  يرجى إدخال صيغة بريد الكتروني صحيحة")
            
         }
            
            
         else {
            
            var flag: Bool
            flag = false
            
            if (type == 0){
                let current1: Attendee = Attendee();
                
                if(Reachability.isConnectedToNetwork()){
                current1.createAccount (username, email: email,  password: password){
                    (login:Bool) in
                    //we should perform all segues in the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        flag = login
                        if (flag == true){
                            
                            print(flag)
                            
                            print("i am in true")
                            
                            self.displayAlert("", message: "لقد تم تسجيلك")
                            self.f = flag
                            
                        }//end if
                        else if (flag == false){
                            print(flag)
                            
                            self.displayAlert("", message: "البريد الإلكتروني مسجل لدينا سابقاً")
                        }//end else
                        
                        
                    }// end  dipatch
                    
                    
                    
                }//end call
                }
                else {
                    self.displayAlert("", message: "الرجاء الاتصال بالانترنت")
                }
                
                
            }//end if type 0
            
            else if (type == 1)
            {
                let current2: EventOrganizer = EventOrganizer();
                
                if(Reachability.isConnectedToNetwork()){
                current2.createAccount (username, email: email,  password: password){
                    (login:Bool) in
                    //we should perform all segues in the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        flag = login
                        if (flag == true){
                            
                            print(flag)
                            
                            print("i am in true")
                            
                            self.displayAlert("", message: "لقد تم تسجيلك")
                            self.f = flag
                            
                        }//end if
                        else if (flag == false){
                            print(flag)
                            
                            self.displayAlert("", message: "البريد الإلكتروني مسجل لدينا سابقاً")
                        }//end else
                        
                        
                    }// end  dipatch
                    
               
                
            }//end call
                }
                else {
                    self.displayAlert("", message: "الرجاء الاتصال بالانترنت")
                }
        
        } //end else type 1
        
        } // end big else 
        
    }// end fun register
    
    var f: Bool = false
    
    func performSegue(flag: Bool) {
        
        
        print("Is it in performSegue")
        if ( flag ) {
          
        
            self.performSegueWithIdentifier("loginpage", sender: self)
       
            
        } }//end fun performSegue
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //for alert massge
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "موافق", style: .Default, handler: { (action) -> Void in
            
            if( message == "لقد تم تسجيلك") {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegue(self.f)}

            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }//end fun display alert

    
    
    
    func isValidEmail(testStr:String) -> Bool {
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    
    
    
    
    
    
    
    
    // *** for keyboard
    @IBOutlet var scrollView: UIScrollView!
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset((CGPointMake(0, 150)), animated: true)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset((CGPointMake(0, 0)), animated: true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    // *** for keyboard
    
    

    
}//end class