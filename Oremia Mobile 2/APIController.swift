//
//  APIController.swift
//  Oremia mobile
//
//  Created by Zumatec on 07/03/2015.
//  Copyright (c) 2015 Zumatec. All rights reserved.
//

import Foundation
class APIController {
    var delegate: APIControllerProtocol
    var context: AnyObject?
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    func sendRequest(searchString: String) {
        let itunesSearchTerm = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://\(preference.ipServer)/scripts/OremiaMobileHD/index.php?query="+itunesSearchTerm+"&&db="+connexionString.db+"&&login="+connexionString.login+"&&pw="+connexionString.pw
            if pingUrl(urlPath){
            get(urlPath)
            }else{
                self.delegate.handleError(1)
            }
        }
    }
    func lookupAlbum(collectionId: Int) {
        sendRequest("select * from patients")    }
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as!NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
            
        })
        task.resume()
    }
    func pingUrl(path:String)->Bool{
        var vretour = false
//        let url = NSURL(fileURLWithPath: path, isDirectory: false)
//        if url!.{
//            vretour=true
//        }
//        var reachability = Reachability(hostname: preference.ipServer)
//        if reachability.startNotifier(){
//            
//        }
        let url = NSURL(string: path)
        var request: NSURLRequest = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        if response == nil{
            println("mauvaise url négro")
        }
        if let httpResponse = response as? NSHTTPURLResponse {
            println("error \(httpResponse.statusCode)")
            vretour=true
        }
        return  vretour
    }
    func getRadioFromUrl(idRadio:Int) -> UIImage {
        var vretour = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://\(preference.ipServer)/scripts/OremiaMobileHD/image.php?query=select+radio+as+image+from+radios+where+id=\(idRadio)&&db="+connexionString.db+"&&login="+connexionString.login+"&&pw="+connexionString.pw)!)!)
        return vretour!
    }
    func getUrlFromDocument(idDocument:Int) -> NSURL {
        let vretour:NSURL? = NSURL(string : "http://\(preference.ipServer)/scripts/OremiaMobileHD/document.php?query=select+document+as+image+from+documents+where+id=\(idDocument)&&db="+connexionString.db+"&&login="+connexionString.login+"&&pw="+connexionString.pw)
        return vretour!
    }
}
protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
    func handleError(results: Int)
}