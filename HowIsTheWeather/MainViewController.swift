//
//  ViewController.swift
//  HowIsTheWeather
//
//  Created by mohamed hassan on 7/7/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//


// import kits

import UIKit
import GooglePlaces
import GoogleMaps
import GoogleMapsCore
import Alamofire


class MainViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  , UITextFieldDelegate{
    
    // location manager variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var wholeAdd : String!
    var currentCordinates : CLLocationCoordinate2D!
    
    
    
    // outlets
    
    @IBOutlet weak var outletOfAddButton: UIButton!
    @IBOutlet weak var outletOfTopMiddleLabel: UILabel!
    @IBOutlet weak var outletOfTableView: UITableView!
    
    
    // data source - list of countries
    var countriesArray : [String] = ["London"] // London is a default value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // location manager and places API configuration
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        
        // get current address
        self.getCurrentAddress()
        
    }
    
    
    // return one section for all cities
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // return number of rows in the table depends on the countries number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesArray.count
    }
    
    
    // assign data to the row - City name
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        
        // asign the data to the labels
        cell.textLabel?.text = self.countriesArray[indexPath.row]                 // City name
        cell.accessoryType = .disclosureIndicator                                 // -> the arrow in the cell
        
        return cell
        
        
    }
    
    
    
    // enable swipe to delete city from the list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
           
            self.countriesArray.remove(at: indexPath.row)
            
            // Reload table data after deleting
            tableView.reloadData()
        }
}
    
    
    // Choose a city to view its weather
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("user selected : \(self.countriesArray[indexPath.row])")
        
        
        let url = "http://api.apixu.com/v1/current.json?key=82d15c19703a4f9ab26211938170707&q=\(self.countriesArray[indexPath.row])"
        
        
        Alamofire.request(url , method : .get).responseJSON { response in
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                var weather : WeatherModel = WeatherModel()
                
                let data = json as! NSDictionary
                
                let location = data["location"] as! NSDictionary
                let localtime = location["localtime"] as! String // local time
                
                weather.localtime = localtime
    
                let current = data["current"] as! NSDictionary
                
                let temp_c = current["temp_c"] as! Int
                let temp_f = current["temp_f"] as! Int
                let wind_mph = current["wind_mph"] as! Int
                let wind_kph = current["wind_kph"] as! Int
                let wind_degree = current["wind_degree"] as! Int
                let wind_dir = current["wind_dir"] as! String
                let pressure_mb = current["pressure_mb"] as! Int
                let precip_mm = current["precip_mm"] as! Int
                let precip_in = current["precip_in"] as! Int
                let humidity = current["humidity"] as! Int
                let cloud = current["cloud"] as! Int
                
                weather.temp_c      = temp_c
                weather.temp_f      = temp_f
                weather.wind_mph    = wind_mph
                weather.wind_kph    = wind_kph
                weather.wind_degree = wind_degree
                weather.wind_dir    = wind_dir
                weather.pressure_mb = pressure_mb
                weather.precip_mm   = precip_mm
                weather.precip_in   = precip_in
                weather.humidity    = humidity
                weather.cloud       = cloud
                
                
                // navigate to the image viewer page
                let WeatherView:WeatherController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherController") as! WeatherController
                
                WeatherView.weather = weather
                //WeatherView.cityName = self.countriesArray[indexPath.row]
                
                
                self.present(WeatherView, animated: false, completion: nil)
                
            }
        }
        
        
    }
    
    
    
    
    // Adding a city to the list
    @IBAction func actionOfAddButton(_ sender: Any) {
        
        
        // if number of cities is == 5
        if (countriesArray.count == 5) {
            
            let alert = UIAlertController(title: "Alert", message: "You ca not add more than 5 cities", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        // // if number of cities is less than 5
        let alert = UIAlertController(title: "Add city", message: "Please enter a correct city name", preferredStyle: .alert)
        
        
        alert.addTextField { (textField) in
            
            textField.delegate = self
            
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            alert?.textFields?[0].delegate = self
            let textField = alert?.textFields?[0]
            let theCityWillInserted = (textField?.text)!
            print("Text field: \(theCityWillInserted)")
            self.countriesArray.append(theCityWillInserted)
            
            // reload table view after adding new city
            self.outletOfTableView.reloadData()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Get current address by google places api
    func getCurrentAddress () {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print(place.addressComponents?[(place.addressComponents?.count)! - 2])
                    print("===GGGGGG=====\(place.addressComponents)")
                    self.wholeAdd = place.formattedAddress?.components(separatedBy: " ")
                        .joined(separator: " ")
                    print("=========\(self.wholeAdd)")
                    
                }
            }
        })
    }
    
    
    
    func getCurrentCity(location : CLLocation) {
    
        print("location location location location")
        print(location)
        
        
        let geocoder = GMSGeocoder()
   
        
        geocoder.reverseGeocodeCoordinate(location.coordinate) { response , error in
            if let address = response?.firstResult() {
                
                print("========")
                print(response)
                
                let lines = address.lines?[(address.lines?.count)! - 1]
                print(lines)
                
//                self.destinationAddress = (lines?.joined(separator: " "))!
//                self.destinationPlaceButton.setTitle(self.destinationAddress, for: .normal)
            }
        }
    }
    
    
}



extension MainViewController : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        self.currentLocation = location
        self.getCurrentCity(location: self.currentLocation!)
        
    }
    
    
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
           
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


