//
//  File.swift
//  InformME
//
//  Created by Amal Ibrahim on 2/4/16.
//  Copyright © 2016 King Saud University. All rights reserved.
//

import Foundation
import UIKit
class Content {
    var Title: String = ""
    var Abstract: String = ""
    var Images: [UIImage] = []
    var Video: String = ""
    //var Pdf: NSData = NSData() //this will be changed depending on our chosen type.
    var Pdf : String = ""
    var likes: Like = Like()
    var dislikes:Dislike = Dislike()
    var comments: [Comment] = []
    var CID:Int?
    var shares: Int = 0
    var label: String = ""
    var contentId: Int = 0
    var like: Int = 0
    var dislike: Int = 0
    var save:Bool = false;
    var del:Bool = false
    var upd:Bool = false

    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "ContentImage.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    var f=false

    func createContent(title: String,abstract: String ,video: String,Pdf: String,BLabel: String,image: [UIImage], completionHandler: (flag:Bool) -> ()) {
          f = false
        let eid=133
        let l = BLabel
        let SC = 0
        
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/AddContent.php")
        
        let request = NSMutableURLRequest(URL:MYURL!)
        
        request.HTTPMethod = "POST";
        let postString = "Title="+title+"&Abstract="+abstract+"&ShareCounter=\(SC)&Label=\(l)&EventID=\(eid)&PDF=\(Pdf)&Video=\(video)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            
            print("response = \(response)")
            
        }
        
        task.resume()
        addImage(title,abstract: abstract,BLabel: BLabel,image: image)
        completionHandler(flag: f)
}
    
    func addImage(title: String,abstract: String ,BLabel: String,image: [UIImage]){
        save = false
        let eid=133
        let l = BLabel
        let SC = 0
        var temp : Int = 0
        print ("--------")
        print (image.count)
        for i in 0...image.count-1{
            let MYURL = NSURL(string:"http://bemyeyes.co/API/content/AddImage.php")
            
            let request = NSMutableURLRequest(URL:MYURL!)
            
            request.HTTPMethod = "POST";
            
            let param : [String: String] = [
                "Title"     : title,
                "Abstract"  :abstract,
                "EventID"  :String(eid),
                "ShareCounter" :String(SC),
                "Label" : l,
                "ImageNum" : String(i)
            ]
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let imageData = UIImageJPEGRepresentation(image[i], -1)
            if imageData==nil{
                print("it is nil")}
            
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }

                // You can print out response object
                print("response = \(response)")
            }
            task.resume()
            }
        self.f=true

        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func updateContent(title: String,abstract: String ,video: String,Pdf: String ,bLabel: String,image: [UIImage], TempV: String , TempP: String , cID:Int) {
        
        upd=false
        
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/EditContent.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        
        let postString = "Title=\(title)&Abstract=\(abstract)&PDF=\(Pdf)&Video=\(video)&CID=\(cID)&pPDF=\(TempP)&pVideo=\(TempV)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            
            
        }
        
        task.resume()
        updateImage(title,abstract: abstract,BLabel: bLabel,image: image )
        
    }
    
    func updateImage(title: String,abstract: String ,BLabel: String,image: [UIImage]){
        let eid=133
        let l = BLabel
        let SC = 0
        upd = false
        
        let MYURL1 = NSURL(string:"http://bemyeyes.co/API/content/deleteImage.php")
        let request1 = NSMutableURLRequest(URL:MYURL1!)
        request1.HTTPMethod = "POST";
        
        let postString1 = "Title=\(title)&Abstract=\(abstract)&EventID=\(eid)&Label=\(l)&ShareCounter=\(SC)"
        request1.HTTPBody = postString1.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            //completionHandler(flag: f)
            
            
            
            
        }
        
        task1.resume()
        
        for i in 0...image.count-1{
            print ("entrr lop")
            let MYURL = NSURL(string:"http://bemyeyes.co/API/content/updateImage.php")
            
            let request = NSMutableURLRequest(URL:MYURL!)
            
            request.HTTPMethod = "POST";
            
            let param : [String: String] = [
                "Title"     : title,
                "Abstract"  :abstract,
                "EventID"  :String(eid),
                "ShareCounter" :String(SC),
                "Label" : l,
                "ImageNum" : String(i)
            ]
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let imageData = UIImageJPEGRepresentation(image[i], -1)
            if imageData==nil{
                print("it is nil")}
            
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                // You can print out response object
                print("response = \(response)")
            }
            task.resume()
        }
        upd = true
    }
    
    
    func DeleteContent(id: Int ){
        
        var f=false
      del = true
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/DeleteContent.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        
        //Change UserID"
        
        let postString = "cid=\(id)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            f=true

            // You can print out response object
            print("response = \(response)")
            //completionHandler(flag: f)

            
            
            
        }
        
        task.resume()
        del = true 
        
    }
    func requestcontentlist(ID: Int,completionHandler: (contentInfo:[Content]) -> ()){
        
        
        var TitleA : [String] = []
        var contentInfo: [Content] = []
        let Eid=ID
        let cid=1
       
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://bemyeyes.co/API/content/SelectContent.php")!)
        
        request.HTTPMethod = "POST"
        let postString = "eid=\(Eid)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let urlContent = data {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    for var x=0; x<jsonResult.count;x++ {
                        let item = jsonResult[x]
                        let c : Content = Content()
                        c.contentId = Int(item["ContentID"] as! String)!
                        c.Title = item["Title"] as! String
                        c.Abstract = item["Abstract"] as! String
                        c.label = item["Label"] as! String
                        if item["PDFFiles"] is NSNull  {
                            c.Pdf = "No PDF"
                        }
                        else{
                            c.Pdf = item["PDFFiles"] as! String
                        }
                        if item["Videos"]  is NSNull  {
                            c.Video = "No Video"
                        }
                        else{
                            c.Video = item["Videos"] as! String
                        }
                        c.shares = Int(item["ShareCounter"] as! String)!
                        c.label = item["Label"] as! String
                        
                        var comments: [Comment] = []
                        let itemC = item["Comments"] as! NSArray
                        for var i=0; i<itemC.count;i++ {
                            let comment: Comment = Comment()
                            comment.comment = itemC[i]["CommentText"] as! String
                            comment.user.username = itemC[i]["UserName"] as! String
                            comments.append(comment)
                        }
                        c.comments = comments;
                        
                        var images: [UIImage] = []
                        let itemI = item["Images"] as! NSArray
                        for var i=0; i<itemI.count;i++ {
                            print ( "IN ==========")
                            let url:NSURL = NSURL(string : itemI[i] as! String)!
                            let data = NSData(contentsOfURL: url)
                            let image=UIImage(data: data!)
                            images.append(image!)
                        }
                        c.Images = images;
                        
                        if item["Like"] is NSNull  {
                            c.like = 0
                        }
                        else{
                            let lk = item["Like"] as! String
                            c.like = Int(lk)!}
                        
                        if item["dislike"] is NSNull {
                            c.dislike = 0
                        }
                        else {
                            let dislk = item["dislike"] as! String
                            c.dislike = Int(dislk)!}
                        
                        contentInfo.append(c)
                        print("DONE")
                    }
                    completionHandler(contentInfo: contentInfo)

                    
                } catch {
                    
                    print("JSON serialization failed")
                    
                }
                
                
            }
        }
        task.resume()
    }


    
    
    func shareContent(cid: Int, completionHandler: (done:Bool) -> ()) {
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/shareContent.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        //Change UserID"
        
        let postString = "cid=\(cid)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            
            completionHandler(done: true)
        }
        
        task.resume()
     
    
    }
    func saveContent(uid: Int , cid: Int) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "http://bemyeyes.co/API/content/SaveContent.php")!)
        request.HTTPMethod = "POST";
        let postString = "uid=\(uid)&cid=\(cid)";
        print("\(postString)")
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            
        }
        task.resume()

    
    
    
    }
    func deleteComment(comment: Comment) {}
    
    func updateEvaluation (cid: Int, uid:Int, likeNo:Int, dislikeNo:Int, completionHandler: (done:Bool) -> ()) {
        
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/updateEvaluation.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        //Change UserID"
        
        let postString = "cid=\(cid)&uid=\(uid)&like=\(likeNo)&dislike=\(dislikeNo)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            
            completionHandler(done: true)
        }
        
        task.resume()

        
    }
    
    func disLikeContent(cid: Int, uid: Int, completionHandler: (done:Bool) -> ()) {
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/evaluate.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        //Change UserID"
        let dislike = 1
        let like = 0
        let postString = "cid=\(cid)&uid=\(uid)&like=\(like)&dislike=\(dislike)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            
            completionHandler(done: true)
        }
        
        task.resume()
        

    }
    func likeContent(cid: Int, uid: Int, completionHandler: (done:Bool) -> ()){
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/evaluate.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        //Change UserID"
        let dislike = 0
        let like = 1
        let postString = "cid=\(cid)&uid=\(uid)&like=\(like)&dislike=\(dislike)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            
            completionHandler(done: true)
        }
        
        task.resume()
        

    
    
    
    
    }
    
    //MARK --Found No Need for the commented methods
    //func requestToAddComment() {}
    //func requestToDeleteComment() {}

    func saveComment(comment: Comment, completionHandler: (done:Bool) -> ()) {
        let com = comment.comment
        let user = comment.user.userID
        let cid = comment.contentID
        let MYURL = NSURL(string:"http://bemyeyes.co/API/content/addcomment.php")
        let request = NSMutableURLRequest(URL:MYURL!)
        request.HTTPMethod = "POST";
        
        //Change UserID"
        
        let postString = "cid=\(cid)&uid=\(user)&comment=\(com)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")

            
            completionHandler(done: true)
        }
        
        task.resume()
        
    }

    
    //MARK: --- THIS METHOD WAS MOVED FROM EVENTS CLASS ---
    func ViewContent(ContentID: Int, UserID:Int, completionHandler: (content:Content) -> ()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://bemyeyes.co/API/content/contentdetails.php")!)
        request.HTTPMethod = "POST"
        let postString = "cid=\(ContentID)&uid=\(UserID)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            print("\(response)")
            if let urlContent = data {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    for var x=0; x<jsonResult.count;x++ {
                        let item = jsonResult[x]
                        let c : Content = Content()
                        c.contentId = Int(item["ContentID"] as! String)!
                        c.Title = item["Title"] as! String
                        c.Abstract = item["Abstract"] as! String
                        if item["PDFFiles"] is NSNull  {
                            c.Pdf = "No PDF"
                        }
                        else{
                        c.Pdf = item["PDFFiles"] as! String
                        }
                        if item["Videos"]  is NSNull  {
                        c.Video = "No Video"
                        }
                        else{
                        c.Video = item["Videos"] as! String
                        }
                        c.shares = Int(item["ShareCounter"] as! String)!
                        c.label = item["Label"] as! String

                        var comments: [Comment] = []
                        let itemC = item["Comments"] as! NSArray
                        for var i=0; i<itemC.count;i++ {
                            let comment: Comment = Comment()
                            comment.comment = itemC[i]["CommentText"] as! String
                            comment.user.username = itemC[i]["UserName"] as! String
                            comments.append(comment)
                        }
                        c.comments = comments;
                        
                        var images: [UIImage] = []
                        let itemI = item["Images"] as! NSArray
                        for var i=0; i<itemI.count;i++ {
                            let url:NSURL = NSURL(string : itemI[i] as! String)!
                            let data = NSData(contentsOfURL: url)
                            let image=UIImage(data: data!)
                            images.append(image!)
                        }
                        c.Images = images;
                        
                        if item["Like"] is NSNull  {
                            c.like = 0
                        }
                        else{
                       let lk = item["Like"] as! String
                            c.like = Int(lk)!}
                       
                        if item["dislike"] is NSNull {
                            c.dislike = 0
                        }
                        else {
                        let dislk = item["dislike"] as! String
                            c.dislike = Int(dislk)!}
                        
                        completionHandler(content: c)

                        print("DONE")
                    }
                    
                    
                } catch {
                    
                    print("JSON serialization failed")
                    
                }
                
                
            }
        }
        task.resume()
    }
    
    init ()
    {   Title = ""
        Abstract = ""
        Images = [UIImage] ()
        Video  = ""
        //Pdf: NSData = NSData() //this will be changed depending on our chosen type.
        Pdf  = ""
        likes = Like()
        dislikes = Dislike()
        comments = [Comment]()
        shares = 0
        label = ""
        contentId = 0}
    
    init(json: [String: AnyObject]) {
        contentId = Int(json["ContentID"] as! String)!
        Title = json["Title"] as! String
    }
}
/*extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}*/