//
//  selectPratViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 07/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class selectPratViewController: UIViewController, UIScrollViewDelegate, APIControllerProtocol{
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnConnexion: UIButton!
    @IBOutlet weak var password: UITextField!
    var pageViews: [UIButton?] = []
    var api = APIController?()
    var praticiens = [Praticien]()
    var mdp:String?
    var selectedPrat:Praticien?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.sendRequest("select id,nom,prenom from praticiens")
        btnConnexion.addTarget(self, action: "clicked", forControlEvents: UIControlEvents.TouchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        api!.sendRequest("select id,nom,prenom from praticiens")
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        return true
    }
    func clicked(){
        mdp="zuma"
        if(!password.text.isEmpty){
            mdp = password.text
        }
        selectedPrat=praticiens[pageControl.currentPage]
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        connexionString.login = "zm\(self.selectedPrat!.id)"
        connexionString.pw = self.mdp!
        api!.sendRequest("select COUNT(*) as correct from praticiens")
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        println("yolo")
        if(!UIApplication.sharedApplication().networkActivityIndicatorVisible){
            loadVisiblePages()
        }
    }
    func loadPage(page: Int) {
        if page < 0 || page >= self.praticiens.count {
            return
        }
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        let newPageView = UIButton(frame: CGRectMake(100, 100, 100, 50))
        newPageView.backgroundColor=UIColor.orangeColor()
        if (self.praticiens[0].id != 0) {
            newPageView.setTitle("Dr "+self.praticiens[page].prenom+" "+self.praticiens[page].nom, forState: UIControlState.Normal)
        } else {
            newPageView.setTitle(self.praticiens[page].nom, forState: UIControlState.Normal)
        }
        newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = frame
        scrollView.addSubview(newPageView)
        
        pageViews[page] = newPageView
    }
    func purgePage(page: Int) {
        if page < 0 || page >= self.praticiens.count{
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < self.praticiens.count; ++index {
            purgePage(index)
        }
    }
    func initScroll(){
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.praticiens.count
        for _ in 0..<self.praticiens.count {
            pageViews.append(nil)
        }
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.praticiens.count),
            height: pagesScrollViewSize.height)
    }
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as! NSArray
        var type = 1
        var nb:Int?
        for value in resultsArr{
            if value.objectForKey("correct") !=  nil{
                type = 0
                nb = value["correct"] as? Int
            }
            if value.objectForKey("error") !=  nil && value["error"] as? Int == 7{
                type = 2
            }
        }
        if type == 0{
            if nb > 0{
                dispatch_async(dispatch_get_main_queue(), {
                    preference.idUser = self.selectedPrat!.id
                    preference.nomUser = self.selectedPrat!.nom
                    preference.prenomUser = self.selectedPrat!.prenom
                    preference.password = self.mdp!
                    connexionString.login = "zm\(self.selectedPrat!.id)"
                    connexionString.pw=self.mdp!
                    self.performSegueWithIdentifier("connectionGranted", sender:self)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            }
        }else if type == 2{
            dispatch_async(dispatch_get_main_queue(), {
                let alert = SCLAlertView()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                alert.showError("Mot de passe incorrect", subTitle: "Mot de passe incorrect ou inexistant, veuillez resaisir vos identifiants", closeButtonTitle:"Fermer")
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.praticiens = Praticien.praticienWithJSON(resultsArr)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.initScroll()
                self.loadVisiblePages()
            })
        }
    }
    func handleError(results: Int) {
        dispatch_async(dispatch_get_main_queue(), {
            switch results {
            case 1 :
                    //            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer", duration: 800)
                    self.praticiens.removeAll(keepCapacity: false)
                    self.praticiens.append(Praticien(id: 0, nom:"Serveur introuvable", prenom: ""))
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.initScroll()
                    self.loadVisiblePages()
            case 2 :
                    self.praticiens.removeAll(keepCapacity: false)
                    self.praticiens.append(Praticien(id: 0, nom:"Fichier(s) manquant", prenom: ""))
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.initScroll()
                    self.loadVisiblePages()
                    self.scrollView.reloadInputViews()
            default :
                    println("exception non gérée")
                
            }
        })
    }
}
