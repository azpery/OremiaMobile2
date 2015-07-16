
//  EtatCivilTableViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 29/05/2015.
//  Copyright (c) 2015 Zumatec. All rights reserved.
//

import UIKit

class EtatCivilTableViewController: UITableViewController, UIPickerViewDelegate {
    var p:patients?
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
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        c.text = hazards[row]
    }
}
