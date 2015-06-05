//
//  RadioCollectionViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 15/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"


var api:APIController?
class RadioCollectionViewController: UICollectionViewController, UICollectionViewDelegate, APIControllerProtocol {
    var nb = 0
    var idRadio:NSArray?
    var dateCrea:NSArray?
    var patient:patients?
    let scl = SCLAlertView()
    var selectedPhoto:UIImage?
    var imageCache = [UIImage]()
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
    }
    func quit(sender: UIBarButtonItem){
        self.performSegueWithIdentifier("unWind", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nb
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RadioCollectionViewCell
        var idr:Int = idRadio?.objectAtIndex(indexPath.row).valueForKey("id") as! Int
        cell.backgroundColor = UIColor.whiteColor()
        var datec = " Date de création :"
        datec += dateCrea!.objectAtIndex(indexPath.row).valueForKey("date") as! String
        cell.label.text = datec
        cell.imageView.contentMode = .ScaleAspectFit
        // Configure the cell
        let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
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
                progressIndicatorView.reveal()
                self!.imageCache.append(image)
        }
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
            if value.objectForKey("date") !=  nil{
                type = 0
                dateCrea=resultsArr
            }
            if value.objectForKey("error") !=  nil && value["error"] as? Int == 7{
                type = 2
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if(self.dateCrea?.count ?? 0 != self.nb){
                api!.sendRequest("select date from radios where idpatient=\(self.patient!.id)")
            } else {
                self.collectionView?.reloadData()
            }
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
        if segue.destinationViewController.isKindOfClass(ImageScrollViewController){
        var fullScreenView: ImageScrollViewController = segue.destinationViewController as! ImageScrollViewController
        fullScreenView.imageScrollLargeImageName = self.imageCache[self.cv.indexPathsForSelectedItems()[0].row]
        }
    }

}
