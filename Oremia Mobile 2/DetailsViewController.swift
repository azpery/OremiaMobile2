//
//  DetailsViewController.swift
//  Oremia mobile
//
//  Created by Zumatec on 10/03/2015.
//  Copyright (c) 2015 Zumatec. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate,  UISearchDisplayDelegate {
    lazy var api : APIController = APIController(delegate: self)
    var praticien: Praticien?
    var tracks = [patients]()
    var filtredpatients = [patients]()
    var searchActive : Bool = false
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var logOut: UIBarButtonItem!
    @IBOutlet weak var appsTableView: UITableView!
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Bienvenue "+preference.nomUser+" "+preference.prenomUser
        api.sendRequest("select * from patients where idpraticien=\(preference.idUser)")
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.tracksTableView.reloadData()
//        logOut.target = self
//        logOut.action = "logOutPressed"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return self.filtredpatients.count
        } else {
            return tracks.count
        }
        

    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tracksTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtredpatients = self.tracks.filter({( patient: patients) -> Bool in
            //            let categoryMatch = (scope == "All")
            let stringMatch = patient.prenom.rangeOfString(searchText)
            let nomMatch = patient.nom.rangeOfString(searchText)
            return (stringMatch != nil) || (nomMatch != nil)
        })
        if(filtredpatients.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tracksTableView.reloadData()
    }
    func logOutPressed(){
        self.performSegueWithIdentifier("logOutSegue", sender:self)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tracksTableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        var track:patients
        if searchActive {
            track  = filtredpatients[indexPath.row]
        } else {
            track = tracks[indexPath.row]
            
        }
        cell.titleLabel.text = track.prenom+" "+track.nom
        cell.imageView?.image = track.photo
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !searchActive{
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        }
    }
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = patients.patientWithJSON(resultsArr)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="toPatientTabBar"){
        var detailsViewController: TabBarViewController = segue.destinationViewController as! TabBarViewController
            var albumIndex : Int
            var selectedAlbum:patients
            if (searchActive){
                albumIndex = searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!.row
                selectedAlbum = self.filtredpatients[albumIndex]
            }else{
                albumIndex = appsTableView!.indexPathForSelectedRow()!.row
                selectedAlbum = self.tracks[albumIndex]
            }
        detailsViewController.patient = selectedAlbum
        }
    }
    func handleError(results: Int) {
        if results == 1{
            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

    }

}