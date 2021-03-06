//
//  CountryTableViewController.swift
//  YourPlaces
//
//  Created by Alex Belogurow on 10.04.17.
//
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Foundation
import SystemConfiguration

class CountryTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarPlace: UISearchBar!
    @IBOutlet weak var buttonPickPlace: UIButton!
    var countries = [Country] ()
    let placeAPI = "AIzaSyBghNprhKqJGgY-cOZGWTpj059mgTtUxCY"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background_3"))
        self.tableView.backgroundView?.contentMode = UIViewContentMode.scaleAspectFill
        
        buttonPickPlace.layer.borderWidth = 0.6
        buttonPickPlace.layer.cornerRadius = 4
        buttonPickPlace.layer.borderColor = UIColor.black.cgColor
        
        self.searchBarPlace.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadSampleCountries()
        GMSPlacesClient.provideAPIKey(placeAPI)
        GMSServices.provideAPIKey(placeAPI)
    }

    @IBAction func openMap(_ sender: Any) {
        let center = CLLocationCoordinate2DMake(55.765905, 37.685390)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            let location = CLLocationManager()
            location.requestWhenInUseAuthorization()
            location.startUpdatingLocation()
            
            if (!self.isInternetAvailable()) {
                let alert = UIAlertController(title: "Warning", message: "Check our Internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if let place = place {
                print("\nPlace name - \(place.name)")
                print("Place id - \(place.placeID)")
                print("Place address - \(String(describing: place.formattedAddress))")
                print("Place site - \(String(describing: place.website))")
                print("Place open - \(place.openNowStatus.rawValue)")
                print("Place types - \(place.types)")
                print("Place price level - \(place.priceLevel.hashValue)")
                // TODO placeID
                self.performSegue(withIdentifier: "SendPlaceIDMap", sender: place.placeID)
                
            } else {
                print("No place selected")
            }
        })

    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarPlace.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBarPlace.resignFirstResponder()
        searchBarPlace.endEditing(true)
        //searchBar.resignFirstResponder()
        let query = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        self.performSegue(withIdentifier: "SendQuery", sender: query)
        //print(searchBar.text)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CountryCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? CountryTableViewCell else {
                fatalError("The dequeued cell is not an instance of CountryTableViewCell")
        }
        
        let country = countries[indexPath.row]
        
        cell.countryName.text = country.name
        cell.countryImage.image = country.photo
    
        return cell
    }
    
    private func loadSampleCountries() {
        guard let countryRussia = Country(name: "RUSSIA", photo: UIImage(named: "Russia")) else {
            fatalError("Unable to instantiate country1")
        }
        
        guard let countryUK = Country(name: "THE UNITED KINDOM", photo: UIImage(named: "England")) else {
            fatalError("Unable to instantiate country2")
        }
        
        guard let countryFrance = Country(name: "FRANCE", photo: UIImage(named: "France")) else {
            fatalError("Unable to instantiate country3")
        }
        
        guard let countryUSA = Country(name: "THE USA", photo: UIImage(named: "USA")) else {
            fatalError("Unable to instantiate country4")
        }
        
        guard let countryChina = Country(name: "CHINA", photo: UIImage(named: "China")) else {
            fatalError("Unable to instantiate country5")
        }
        
        guard let countryMalaysia = Country(name: "MALAYSIA", photo: UIImage(named: "Malaysia")) else {
            fatalError("Unable to instantiate country6")
        }
        
        guard let countryGermany = Country(name: "GERMANY", photo: UIImage(named: "Germany")) else {
            fatalError("Unable to instantiate country7")
        }
        
        guard let countryTurkey = Country(name: "TURKEY", photo: UIImage(named: "Turkey")) else {
            fatalError("Unable to instantiate country8")
        }
        
        guard let countryItaly = Country(name: "ITALY", photo: UIImage(named: "Italy")) else {
            fatalError("Unable to instantiate country9")
        }
        
        guard let countrySpain = Country(name: "SPAIN", photo: UIImage(named: "Spain")) else {
            fatalError("Unable to instantiate country10")
        }

        
        countries += [countryMalaysia, countryRussia, countryUK, countryGermany, countryTurkey, countryItaly, countrySpain, countryChina, countryUSA, countryFrance]
    }
    
    // передаем название страны
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendCountry" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let dest = segue.destination as? PlaceCategoryCollectionViewController
                let value = countries[indexPath.row].name.replacingOccurrences(of: " ", with: "+")
                dest?.countryName = value
            }
        } else if segue.identifier == "SendQuery" {
            let dest = segue.destination as? ListOfPlacesTableViewController
            dest?.query = sender as! String
        } else if segue.identifier == "SendPlaceIDMap" {
            let dest = segue.destination as? PlaceInfoTableViewController
            dest?.receivedPlaceId = sender as! String
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
