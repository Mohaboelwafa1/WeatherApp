//
//  WeatherController.swift
//  HowIsTheWeather
//
//  Created by mohamed hassan on 7/8/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit

class WeatherController: UIViewController {
    
    var weather : WeatherModel!
    //var cityName : String!
    
    // outlets
    
    
    //@IBOutlet weak var nameOfCity: UILabel!
    
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var temp_c: UILabel!
    @IBOutlet weak var temp_f: UILabel!
    @IBOutlet weak var wind_mph: UILabel!
    @IBOutlet weak var wind_kph: UILabel!
    @IBOutlet weak var wind_degree: UILabel!
    @IBOutlet weak var wind_dir: UILabel!
    @IBOutlet weak var pressure_mb: UILabel!
    @IBOutlet weak var pressure_in: UILabel!
    @IBOutlet weak var precip_mm: UILabel!
    @IBOutlet weak var humidty: UILabel!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var precip_in: UILabel!
    
    override func viewDidLoad() {

        localTime.text = weather.localtime
        temp_c.text = String(weather.temp_c)
        temp_f.text = String(weather.temp_f)
        wind_mph.text = String(weather.wind_mph)
        wind_kph.text = String(weather.wind_kph)
        wind_degree.text = String(weather.wind_degree)
        wind_dir.text = String(weather.wind_dir)
        pressure_mb.text = String(weather.pressure_mb)
        precip_mm.text = String(weather.precip_mm)
        humidty.text = String(weather.humidity)
        cloud.text = String(weather.cloud)
        
    }
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
