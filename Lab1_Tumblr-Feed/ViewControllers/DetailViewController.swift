//
//  DetailViewController.swift
//  Lab1_Tumblr-Feed
//
//  Created by Ching Ching Huang on 9/13/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photoURL : String = ""
    var caption : String = ""
    
    @IBOutlet weak var label: UILabel!
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let url = URL(string: photoURL)
        //let captionCut = caption.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //detailedImage.af_setImage(withURL: url!)
        //captionLabel.text = captionCut
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
