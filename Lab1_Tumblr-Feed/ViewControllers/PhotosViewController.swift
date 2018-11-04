//
//  PhotosViewController.swift
//  Lab1_Tumblr-Feed
//
//  Created by Ching Ching Huang on 9/13/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var phototableview: UITableView!
    var posts: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        phototableview.insertSubview(refreshControl, at: 0)
        
        phototableview.delegate = self
        phototableview.dataSource = self
        phototableview.rowHeight = 200
        fetchPhotos()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPhotos()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            isMoreDataLoading = true
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = phototableview.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - phototableview.bounds.size.height
            // ... Code to load more results ...
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && phototableview.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate:nil,
                                 delegateQueue:OperationQueue.main)
        let task : URLSessionDataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Update flag
            self.isMoreDataLoading = false
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.phototableview.reloadData()
        })
        task.resume()
    }
    
    func fetchPhotos(){
        //Network request
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.provideAlert(title: "Network Error", message: "Please check your network")
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.phototableview.delegate = self
                self.phototableview.dataSource = self
                self.phototableview.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photocell", for: indexPath) as! TableViewCell
        let post = posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0] //Get the first photo in the photos array
            let originalSize = photo["original_size"] as! [String: Any] //Get the original size dictionary from the photo
            let urlString = originalSize["url"] as! String //Get the url string from the original size dictionary
            let url = URL(string: urlString) //Create a URL using the urlString
            cell.photoImageView.af_setImage(withURL: url!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 400, height: 20))
        let onePost = self.posts[section]
        let date = onePost["date"]
        if let date2 = date {
            label.text = "\(date2)"
        }
        // Use the section number to get the right URL
        // let label = ...
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the index path from the cell that was tapped
        //let indexPath = phototableview.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        //let index = indexPath?.row
        // Get in touch with the DetailViewController
        let vc = segue.destination as! DetailViewController
        let cell = sender as! TableViewCell
        vc.image = cell.photoImageView.image
        //let indexPath = phototableview.indexPath(for: cell)!
    }
    
    func provideAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        alertController.addAction(OKAction)
        //self.activityIndicator.stopAnimating()
        present(alertController, animated: true)
    }
}
