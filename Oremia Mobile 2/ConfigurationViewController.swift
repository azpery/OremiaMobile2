//
//  ConfigurationViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 13/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var validButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ipTextField.text=preference.ipServer
        validButton.addTarget(self, action: "editServerIp", forControlEvents: UIControlEvents.TouchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func editServerIp(){
        preference.ipServer=ipTextField.text
        self.performSegueWithIdentifier("goBackSegue", sender:self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var selectPratViewController = segue.destinationViewController.topViewController as! selectPratViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
