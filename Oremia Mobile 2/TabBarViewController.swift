//
//  TabBarViewController.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 18/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var patient:patients?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var radioCollectionViewController: RadioCollectionViewController = segue.destinationViewController as! RadioCollectionViewController
        radioCollectionViewController.patient = patient!
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
