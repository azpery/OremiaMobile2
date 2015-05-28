//
//  RadioCollectionViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 15/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
var nb = 0
var idRadio:NSArray?
var api:APIController?
class RadioCollectionViewController: UICollectionViewController, UICollectionViewDelegate, APIControllerProtocol {
    var patient:patients?
    let scl = SCLAlertView()
    var selectedPhoto:UIImage?
    var imageCache = [String : UIImage]()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var quitButton: UIBarButtonItem!
    @IBOutlet var cv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        api=APIController(delegate: self)
        var tb : TabBarViewController = self.tabBarController as! TabBarViewController
        patient = tb.patient
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.sendRequest("select id from radios where idpatient=\(patient!.id)")
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        nb=0
        idRadio = nil
        self.collectionView?.reloadData()
//        quitButton.target = self
//        quitButton.action="quit:"

        // Do any additional setup after loading the view.
    }
    func quit(sender: UIBarButtonItem){
        self.performSegueWithIdentifier("unWind", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return nb
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RadioCollectionViewCell
        var idr:Int = idRadio?.objectAtIndex(indexPath.row).valueForKey("id") as! Int
       //var image = api!.getRadioFromUrl(idr)
        cell.backgroundColor = UIColor.blackColor()
        //cell.imageView.image = image
        // Configure the cell
        let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
        
//        cell.imageView?.image = UIImage(named: "photo")
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = NSURL(string: "http://\(preference.ipServer)/scripts/OremiaMobileHD/image.php?query=select+radio+as+image+from+radios+where+id=\(idr)&&db="+connexionString.db+"&&login="+connexionString.login+"&&pw="+connexionString.pw)
        
        cell.imageView?.sd_setImageWithURL(urlString, placeholderImage: nil, options: .CacheMemoryOnly, progress: {
            [weak self]
            (receivedSize, expectedSize) -> Void in
                cell.imageView.addSubview(progressIndicatorView)
                progressIndicatorView.frame = cell.imageView.bounds
                progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
            }) {
                [weak self]
                (image, error, _, _) -> Void in
                //progressIndicatorView.progress = 0.9
                //progressIndicatorView.frame = cell.imageView.bounds
                progressIndicatorView.reveal()
        }
//        // Check our image cache for the existing key. This is just a dictionary of UIImages
//        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
//        var image = self.imageCache[urlString]
//        
//        
//        if( image == nil ) {
//            // If the image does not exist, we need to download it
//            var imgURL: NSURL = NSURL(string: urlString)!
//            
//            // Download an NSData representation of the image at the URL
//            let request: NSURLRequest = NSURLRequest(URL: imgURL)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
//                if error == nil {
//                    image = UIImage(data: data)
//                    
//                    // Store the image in to our cache
//                    self.imageCache[urlString] = image
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? RadioCollectionViewCell {
//                            cellToUpdate.imageView?.image = image
//                        }
//                    })
//                }
//                else {
//                    println("Error: \(error.localizedDescription)")
//                }
//            })
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), {
//                if let cellToUpdate = self.cv.cellForItemAtIndexPath(indexPath) as? RadioCollectionViewCell{
//                    cellToUpdate.imageView?.image = image
//                }
//            })
//        }

        return cell
    }
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as! NSArray
        var type = 1
        for value in resultsArr{
            if value.objectForKey("id") !=  nil{
                type = 0
                idRadio=resultsArr
                nb = idRadio!.count
            }
            if value.objectForKey("error") !=  nil && value["error"] as? Int == 7{
                type = 2
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.collectionView?.reloadData()
//            self.scl.showInfo("patiet", subTitle: self.patient!.nom)
        })
    }
    func handleError(results: Int) {
        if results == 1{
            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    override func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath){
        var idr:Int = idRadio?.objectAtIndex(indexPath.row).valueForKey("id") as! Int
        selectedPhoto = api!.getRadioFromUrl(idr)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(FullScreenRadioViewController){
        var fullScreenView: FullScreenRadioViewController = segue.destinationViewController as! FullScreenRadioViewController
        var idr:Int = idRadio?.objectAtIndex(self.cv.indexPathsForSelectedItems()[0].row).valueForKey("id") as! Int
        selectedPhoto = api!.getRadioFromUrl(idr)
        fullScreenView.image = self.selectedPhoto!
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
