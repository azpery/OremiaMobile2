//
//  EtatCivilViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 22/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MobileCoreServices


class EtatCivilViewController: UIViewController, APIControllerProtocol, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    var api = APIController?()
    var patient = patients?()
    var cameraUI:UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        var tb : TabBarViewController = self.tabBarController as! TabBarViewController
        patient = tb.patient!
        profilePicture.contentMode = .ScaleAspectFit
        profilePicture.image = patient?.photo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func prendrePhoto(sender: AnyObject) {
        self.presentCamera()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            
        })
    }
    func handleError(results: Int) {
        if results == 1{
            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="embedTable"){
            var detailsViewController: EtatCivilTableViewController = segue.destinationViewController as! EtatCivilTableViewController
            var tb : TabBarViewController = self.tabBarController as! TabBarViewController
            patient = tb.patient!
            detailsViewController.p = patient!
        }
        if(segue.identifier=="selectImage"){
            var ImageCollection: ImageViewController = segue.destinationViewController as! ImageViewController
            var tb : TabBarViewController = self.tabBarController as! TabBarViewController
            patient = tb.patient!
            ImageCollection.patient = patient!
        }
    }
    func presentCamera()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = [kUTTypeImage]
        cameraUI.allowsEditing = true
        cameraUI.navigationItem.title = "kikou"
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    

    //pragma mark- Image
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        var mediaType:String = editingInfo[UIImagePickerControllerEditedImage] as! String
        var imageToSave:UIImage
        
        imageToSave = image
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.profilePicture.image = imageToSave
        self.patient?.photo = image
        api?.insertImage(image, idPatient: self.patient!.id)
    }
    
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int)
    {
        NSLog("Did dismiss button: %d", buttonIndex)
        //self.presentCamera()
    }

}
