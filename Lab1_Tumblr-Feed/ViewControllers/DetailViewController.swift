//
//  DetailViewController.swift
//  Lab1_Tumblr-Feed
//
//  Created by Ching Ching Huang on 9/13/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    var image: UIImage!
    
    var photoURL : String = ""
    var caption : String = ""
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImage.image = image
    }

    @IBAction func onZoom(_ sender: Any) {
        performSegue(withIdentifier: "zoomSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the index path from the cell that was tapped
        if segue.identifier == "zoomSegue" {
            let vc = segue.destination as! FullScreenPhotoViewController
            vc.image = photoImage.image
        }
    }
}
