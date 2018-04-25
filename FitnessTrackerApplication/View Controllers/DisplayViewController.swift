//
//  DisplayViewController.swift
//  FitnessTrackerApplication
//
//  Created by Saloni Panchal on 2018-04-23.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {
    
    @IBOutlet var ImageView : UIImageView!
    var image = UIImage()
    var mainDelegate:AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mainDelegate=UIApplication.shared.delegate as! AppDelegate
        print("md \(mainDelegate.path)")
        ImageView.image=UIImage(named : mainDelegate.path! as String)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
