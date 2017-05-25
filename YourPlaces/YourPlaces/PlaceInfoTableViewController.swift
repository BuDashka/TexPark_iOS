//
//  PlaceInfoTableViewController.swift
//  YourPlaces
//
//  Created by Alex Belogurow on 25.05.17.
//
//

import UIKit
import SwiftyJSON
import SDWebImage

class PlaceInfoTableViewController: UITableViewController {

    var imageArray = [String] ()
    let KEY = "AIzaSyAI-JOPMs5Yr-NhfbEnf_pNO9jA2bcOCkc"
    var placeId = String()
    var placeKey = ["Address", "Phone", "Open_now", "Price", "Rating", "Website"]
    var placeValue = [String] ()
    
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadJSON()
        
        imageScrollView.isPagingEnabled = true
        imageScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(imageArray.count), height: 200)
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        
        imagePageControl.numberOfPages = imageArray.count
        
        
        print(imageArray.count)
        loadImages()
    }
    
    func loadImages() {
        for (index, image) in imageArray.enumerated() {
            if let imageView = Bundle.main.loadNibNamed("Image", owner: self, options: nil)?.first as? PlaceImageView {
                let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=" + image + "&key=" + self.KEY)
                
                imageView.placeImage.sd_setShowActivityIndicatorView(true)
                imageView.placeImage.sd_setIndicatorStyle(.gray)
                imageView.placeImage.sd_setImage(with: url)
                //imageView.placeImage.image = UIImage(named: image)

                imageScrollView.addSubview(imageView)
                imageView.frame.size.width = self.view.bounds.width
                imageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        imagePageControl.currentPage = Int(page)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeKey.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlaceInfoKeyValueCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? PlaceInfoTableViewCell else {
                fatalError("The dequeued cell is not an instance of PlaceInfoKeyValueCell")
        }
        
        let key = placeKey[indexPath.row]
        let value = placeValue[indexPath.row]
        
        cell.labelValue.text = value
        cell.labelKey.text = key


        return cell
    }
    
    func loadJSON() {
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.placeId + "&key=" + self.KEY + "&language=en") {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data)["result"]
                //print(json)
                let error = "Unknown"
                print(json)
                print(json["rating"])
                placeValue.append(json["formatted_address"].string ?? error)
                placeValue.append(json["formatted_phone_number"].string ?? error)
                placeValue.append(json["opening_hours"]["open_now"].stringValue)
                placeValue.append(json["price_level"].stringValue)
                placeValue.append(json["rating"].stringValue)
                placeValue.append(json["website"].string ?? error)
                print(placeValue)
                for item in json["photos"].arrayValue {
                    //print(item)
                    imageArray.append(item["photo_reference"].stringValue)
                }
            }
        }
        /*
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + query + "&key=" + KEY + "&language=en") {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data)
                for item in json["results"].arrayValue {
                    let place = Place(placeID: item["place_id"].stringValue,
                                      name: item["name"].stringValue,
                                      photo: item["photos"][0]["photo_reference"].stringValue,
                                      rating: item["rating"].stringValue)
                    print("\(String(describing: place?.name)) - name")
                    self.places.append(place!)
                }
                
            }
        }
        */
    }
   
}