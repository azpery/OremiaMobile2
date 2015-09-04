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
    @IBOutlet weak var addButton: UIBarButtonItem!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Bienvenue "+preference.nomUser+" "+preference.prenomUser
        api.sendRequest("select * from patients where idpraticien=\(preference.idUser) LIMIT 50")
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.tracksTableView.reloadData()
        addButton.target = self
        addButton.action = "addNewPatient"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return self.filtredpatients.count
        } else {
            return tracks.count
        }
    }
    func addNewPatient(){
        api.sendRequest("INSERT INTO patients( id, nir, genre, nom, prenom, adresse, codepostal, ville, telephone1, telephone2, email, naissance, creation, idpraticien, idphoto, info, autorise_sms, correspondant, ipp2, adresse2, patient_par, amc, amc_prefs, profession, correspondants, statut, famille, tel1_info, tel2_info)VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);")
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
        let dcell = tracksTableView.dequeueReusableCellWithIdentifier("SearchCell") as! UITableViewCell
        var track:patients
        if searchActive {
            var cell = tracksTableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchTableViewCell
            track  = filtredpatients[indexPath.row]
            cell.label.text = "Prénom : "+track.prenom+" Nom : "+track.nom
            return cell
        } else {
            var cell = tracksTableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
            track = tracks[indexPath.row]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var ddate = dateFormatter.dateFromString(track.dateNaissance)
            //        dateFormatter.dateFormat = "yyyy"
            let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
            let date = NSDate()
            let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
            let year = components.year as Int
            let dyear =  NSCalendar.currentCalendar().components(flags, fromDate: ddate!).year as Int
            //        var a = dateFormatter.stringFromDate(NSDate())
            //        var auj = NSDate().dateFromString(a, format: "yyyy")
            let dage = year - dyear
            cell.age.text = "\(dage) ans"
            cell.Adresse.text = ""+renseigner(track.adresse)+" "+track.codePostal+""+track.ville
            cell.email.text = ""+renseigner(track.email)
            cell.tel.text = ""+renseigner(track.telephone1)
            cell.titleLabel.text = ""+track.prenom+" "+track.nom
            println(NSDate())
            cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2;
            cell.avatar.clipsToBounds = true
            cell.avatar.layer.borderWidth = 0.5
            cell.avatar.layer.borderColor = UIColor.whiteColor().CGColor
            cell.avatar.contentMode = .ScaleAspectFit
            let urlString = NSURL(string: "http://\(preference.ipServer)/scripts/OremiaMobileHD/image.php?query=select+image+from+images+where+id=\(track.idPhoto)&&db=zuma&&login=zm\(preference.idUser)&&pw=\(preference.password)")
            cell.avatar.sd_setImageWithURL(urlString, placeholderImage: nil, options: .CacheMemoryOnly, progress: {
                [weak self]
                (receivedSize, expectedSize) -> Void in
                cell.avatar.image = track.photo
                }) {
                    [weak self]
                    (image, error, _, _) -> Void in
                    cell.avatar.image = image
                    track.photo = image
            }
            //cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        return dcell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
    }
    func renseigner(text:String) -> String{
        var vretour = text
        if text == "" {
            vretour = "Non renseigné"
        }
        return vretour
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