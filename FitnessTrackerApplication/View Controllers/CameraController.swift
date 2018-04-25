//
//  ViewController.swift
//  FitnessTrackerApplication
//
//  Created by Saloni Panchal on 2018-03-25.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import AVFoundation
import SQLite3


class CameraController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var mainDelegate : AppDelegate!
    var DA : DataAccess = .init()
    @IBAction func unwindToCameraController(sender:UIStoryboardSegue)
    {
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    @IBAction func openCameraButton(sender: Any) {
        print("in openCameraButton")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("in imagePickerController")
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func saveImage(imageName: String){
        print("in saveImage")
        
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        print(DA)
        DA.photos.add(imagePath)
        
        var image = imageView.image!
        var data = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        let successcode : Bool = DA.insert(intoImgDatabase: imageName)
        print(successcode)
        
    }
    
    @IBAction func saveImageButton (sender : Any)
    {
        print("in saveImageButton")
        let imageName = String(arc4random()).appending(".png")
        saveImage(imageName: imageName)
    }
    
    
    @IBAction func galleryButton(sender : Any)
    {
        print("in galleryButton")
        performSegue(withIdentifier: "gallerySegue", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mainDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

