//
//  GalleryController.swift
//  FitnessTrackerApplication
//
//  Created by Saloni Panchal on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class GalleryCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var DA = DataAccess.init()
    
    var imagePath : String = " "
    var fileManager = FileManager.default
    var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as! NSString
    var mainDelegate:AppDelegate!
    
    @IBAction func unwindToGalleryCollectionController(sender:UIStoryboardSegue)
    {
        
    }
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        print(DA.photos.count)
        return DA.photos.count
        
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell
    {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        imagePath=documentPath.appendingPathComponent(DA.photos.object(at: indexPath.row) as! String)
        print("")
        if fileManager.fileExists(atPath:imagePath)
        {
            
           myCell.imageView.image=UIImage(named:imagePath)
            print("exists")
            print(DA.photos.object(at: indexPath.row))
            print(imagePath)
        }
        else
        {
            print("Panic! No Image")
        }
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in did select")
        self.performSegue(withIdentifier: "DisplayViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayViewController" {
            if let destinationViewController = segue.destination as? DisplayViewController  {
                print(" in des")
                if let cell = sender as? UICollectionViewCell {
                    print("in cell")
                    if let indexPath = collectionView.indexPath(for: cell) {
                        print("in indexPath")
                        imagePath = documentPath.appendingPathComponent(DA.photos.object(at: indexPath.row) as! String)
                        mainDelegate.path=(imagePath as! String)
                    }
                }
            }
        }
    }
    
    func cellLayout()
    {
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
       /* super.viewDidLoad()
        self.mainDelegate = UIApplication.shared.delegate as! AppDelegate
        DA.readDataFromImgDatabase()
        cellLayout()*/
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mainDelegate = UIApplication.shared.delegate as! AppDelegate
        DA.readDataFromImgDatabase()
        print(DA.photos.count)
        print(DA.photos[0])
        cellLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

