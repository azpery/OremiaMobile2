
//  EtatCivilTableViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 29/05/2015.
//  Copyright (c) 2015 Zumatec. All rights reserved.
//

import UIKit

class EtatCivilTableViewController: UITableViewController, UIPickerViewDelegate, APIControllerProtocol {
    var p:patients?
    var api = APIController?()
    var hazards = ["", "Monsieur","Madame", "Mademoiselle", "Enfant"]
    var pickerView1: UIPickerView!
    @IBOutlet weak var c: UITextField!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var dn: UITextField!
    @IBOutlet weak var a1: UITextField!
    @IBOutlet weak var a2: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var ville: UITextField!
    @IBOutlet weak var telf: UITextField!
    @IBOutlet weak var telm: UITextField!
    @IBOutlet weak var sms: UITextField!
    @IBOutlet weak var em: UITextField!
    @IBOutlet weak var pr: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        api = APIController(delegate: self)
        pickerView1 = UIPickerView()
        pickerView1.delegate = self
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        var item = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Plain, target: self, action: "doneAction")
        item.title = "OK"
        toolbar.setItems([item], animated: true)
        c.text = hazards[p!.civilite]
        c.inputView = pickerView1
        c.inputAccessoryView = toolbar
        nom.text = p!.nom
        prenom.text = p!.prenom
        dn.text = p!.dateNaissance
        a1.text = p!.adresse
        cp.text = p!.codePostal
        ville.text = p!.ville
        telf.text = p!.telephone1
        telm.text = p!.telephone2
        sms.text = "\(p!.autoSMS)"
        pr.text = p!.profession
        em.text = p!.email
        self.tableView.scrollsToTop = true
        

    }
//    override func viewDidDisappear(animated: Bool){
//        api!.sendInsert("UPDATE patients SET nir=DEFAULT, genre=\(p!.civilite), nom=\(p!.nom), prenom=\(p!.prenom), adresse=?, codepostal=?, ville=?, telephone1=?, telephone2=?, email=?, naissance=?, creation=?,idpraticien=?, idphoto=?, info=?, autorise_sms=?, correspondant=?,ipp2=?, adresse2=?, patient_par=?, amc=?, amc_prefs=?, profession=?,correspondants=?, statut=?, famille=?, tel1_info=?, tel2_info=? WHERE id =\(p!.id);")
//    }
    
    func doneAction() {
        self.c.resignFirstResponder()
        println("done!")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showpicker(sender:UITextField!){
        performSegueWithIdentifier("showpicker", sender: self)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return hazards.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return hazards[row]
        if row == hazards.count {
            pickerView1.selectRow(p!.civilite, inComponent: 1, animated: true)
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        c.text = hazards[row]
    }
    func didReceiveAPIResults(results: NSDictionary) {
        
    }
    func handleError(results: Int) {
        if results == 1{
            SCLAlertView().showError("Serveur introuvable", subTitle: "Veuillez rentrer une adresse ip de serveur correct", closeButtonTitle:"Fermer")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
}
