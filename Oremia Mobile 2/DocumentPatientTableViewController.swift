//
//  DocumentPatientTableViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 21/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class DocumentPatientTableViewController: UITableViewController, APIControllerProtocol {
    var api=APIController?()
    var patient:patients?
    var lesDocuments = [Document]()
    @IBOutlet var documentTableView: UITableView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        api = APIController(delegate: self)
        var tb : TabBarViewController = self.tabBarController as! TabBarViewController
        patient = tb.patient!
        api!.sendRequest("SELECT id,nom,date FROM documents WHERE idpatient = \(patient!.id) AND type='PDF'")
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return lesDocuments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("documentCell", forIndexPath: indexPath) as! DocumentTableViewCell
        cell.dateLabel.text = lesDocuments[indexPath.row].date
        cell.nomLabel.text = lesDocuments[indexPath.row].nom

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(FullScreenDocumentViewController){
            var fullScreenView: FullScreenDocumentViewController = segue.destinationViewController as! FullScreenDocumentViewController
            var idr:Int = lesDocuments[documentTableView.indexPathForSelectedRow()!.row].id
            //var selectedDocument = api!.getRadioFromUrl(idr)
            fullScreenView.document = lesDocuments[documentTableView.indexPathForSelectedRow()!.row]
            fullScreenView.leDocument = api!.getUrlFromDocument(idr)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.lesDocuments = Document.documentWithJSON(resultsArr)
            self.documentTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    func handleError(results: Int) {
        if results == 1{
            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }

}
