//
//  ListOfPlacesTableViewController.swift
//  YourPlaces
//
//  Created by Alex Belogurow on 21.05.17.
//
//

import UIKit
import SwiftyJSON
import SDWebImage
import RealmSwift
import Foundation
import SystemConfiguration

class ListOfPlacesTableViewController: UITableViewController {
    
    let KEY = "AIzaSyAI-JOPMs5Yr-NhfbEnf_pNO9jA2bcOCkc"
    
    var query = String()
    var places = [Place] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(query)
        loadJSON()
        
        self.navigationItem.title = "Pick a Place"
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background_3"))
        self.tableView.backgroundView?.contentMode = UIViewContentMode.scaleAspectFill
        
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 198
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
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlaceSearchInfoCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? ListOfPlacesTableViewCell else {
                fatalError("The dequeued cell is not an instance of ListOfPlacesTableViewCell")
        }
        
        let curPlace = places[indexPath.row]
        cell.labelPlaceName.text = curPlace.name
        cell.labelRating.text = curPlace.rating
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=" + curPlace.photo! + "&key=" + self.KEY)
        cell.imageViewPlacePhoto.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "missingImage"))
        
        
        return cell
    }
    
    func loadJSON() {
        if (isInternetAvailable()) {
            let url0 = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + query + "&key=" + KEY + "&language=en"
            // ENCODE URL
            if let url = URL(string: url0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                if let data = try? Data(contentsOf: url) {
                    let json = JSON(data)
                    //print(json)
                        for item in json["results"].arrayValue {
                            let place = Place(placeID: item["place_id"].stringValue,
                                      name: item["name"].stringValue,
                                      photo: item["photos"][0]["photo_reference"].stringValue,
                                      rating: item["rating"].stringValue)
                            //print("\(String(describing: place?.name)) - name")
                            self.places.append(place!)
                }

            }
        }} else {
            let alert = UIAlertController(title: "Warning", message: "Check our Internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendPlaceIDSearch" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let dest = segue.destination as? PlaceInfoTableViewController
                let value = places[indexPath.row].placeID
                //print("value : \(String(describing: value))")
                dest?.receivedPlaceId = value!
            }
        }

    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}


