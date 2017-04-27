//
//  CountryTableViewController.swift
//  YourPlaces
//
//  Created by Alex Belogurow on 10.04.17.
//
//

import UIKit

class CountryTableViewController: UITableViewController {
    
    var countries = [Country] ()

    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background_3"))
        self.tableView.backgroundView?.contentMode = UIViewContentMode.scaleAspectFill
        
        loadSampleCountries()
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

}
