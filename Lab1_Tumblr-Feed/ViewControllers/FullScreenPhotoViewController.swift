//
//  FullScreenPhotoViewController.swift
//  Lab1_Tumblr-Feed
//
//  Created by Ching Ching Huang on 11/3/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photoImage.image = image
        scrollView.delegate = self
        scrollView.contentSize = photoImage.image!.size
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
