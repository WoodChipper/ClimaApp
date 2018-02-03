//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    @IBOutlet weak var faren: UISwitch!
    //Constants
                           // api.openweathermap.org/data/2.5/weather?q=London
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e6c49a8257af1f11fc21c0915ffeff43"
    
    let PRESSURE_IPA_TO_INHG = 0.029529983071445
    let METERS_TO_MILES = 0.00062137
    
    // complete URL for testing:  "api.openweathermap.org/data/2.5/forecast?id=524901&APPID=1111111111"
    // http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43
    
    

    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
 
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet var dateAndTimeLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var mainDescriptionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var cloudCoveringLabel: UILabel!
    @IBOutlet var FahrenheitCelsiusSwitchLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var longitudeLatitudeLabel: UILabel!
    @IBOutlet var fahrOrCelsiusSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
       
    
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    var weatherJSON : JSON = []
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
                
                self.weatherJSON = JSON(response.result.value!)
                self.updateWeatherData(json: self.weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
  
    //Write the updateWeatherData method here:
    
    
    func updateWeatherData(json : JSON) {
    
        if let tempResult = json["main"]["temp"].double {
            
            if fahrOrCelsiusSwitch.isOn {
                // Fahrenheit conversion - ° F = 9/5(K - 273) + 32
                weatherDataModel.temperature = Int(((tempResult - 273.15) * (9 / 5)) + 32)
                FahrenheitCelsiusSwitchLabel.text = "Fahrenheit"
            } else {
                // Celcius conversion
                weatherDataModel.temperature = Int(tempResult - 273.15)
                FahrenheitCelsiusSwitchLabel.text = "Celsius"
            }
    
            weatherDataModel.tempMax = Int(json["main"]["temp_max"].doubleValue)
            weatherDataModel.tempMin = Int(json["main"]["temp_min"].doubleValue)
            weatherDataModel.pressure = json["main"]["pressure"].doubleValue
            weatherDataModel.humidity = Int(json["main"]["humidity"].doubleValue)
        
            // Visiblity is not well supported from OpenWeatherMap at this time. Not worth the trouble
            // weatherDataModel.visibility = json["visibility"].doubleValue   // meters

            weatherDataModel.windSpeed = json["wind"]["speed"].doubleValue   // meters/second
            weatherDataModel.windDirection = Int(json["wind"]["deg"].doubleValue)
            weatherDataModel.clouds = json["clouds"]["all"].stringValue
        
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.country = json["sys"]["country"].stringValue
            weatherDataModel.cityID = json["sys"]["id"].stringValue
            weatherDataModel.longitude = json["coord"]["lon"].doubleValue
            weatherDataModel.latitude = json["coord"]["lat"].doubleValue
    
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.mainDescription = json["weather"][0]["main"].stringValue
            weatherDataModel.subDescription = json["weather"][0]["description"].stringValue
        
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let tempSunrise = json["sys"]["sunrise"].doubleValue
            weatherDataModel.sunrise = formatter.string(from: Date(timeIntervalSince1970: tempSunrise))
            let tempSunset = json["sys"]["sunset"].doubleValue
            weatherDataModel.sunset = formatter.string(from: Date(timeIntervalSince1970: tempSunset))
            let tempReadingTime = json["dt"].doubleValue
            formatter.dateFormat = "EEEE,  MMM d, yyyy  h:mm a"
            weatherDataModel.timeOfReading = formatter.string(from: Date(timeIntervalSince1970: tempReadingTime))
    
            updateUIWithWeatherData()
    
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        sunriseLabel.text = weatherDataModel.sunrise
        sunsetLabel.text = weatherDataModel.sunset
        dateAndTimeLabel.text = weatherDataModel.timeOfReading
        windSpeedLabel.text = "\(Int(weatherDataModel.windSpeed * (25 / 11)))"
        windDirectionLabel.text = weatherDataModel.windDirection(degrees: weatherDataModel.windDirection)

        humidityLabel.text = "\(weatherDataModel.humidity)%"
        mainDescriptionLabel.text = "\(weatherDataModel.mainDescription): (\(weatherDataModel.subDescription))"
        cloudCoveringLabel.text = "\(weatherDataModel.clouds)%"
        countryLabel.text = weatherDataModel.getCountryName(code: weatherDataModel.country)
        
        // format Longitude and Latitude to 2 decimal places
        let lon = String(format: "%.3f", weatherDataModel.longitude)
        let lat = String(format: "%.3f", weatherDataModel.latitude)
        longitudeLatitudeLabel.text = "Lon: \(lon)  Lat: \(lat)"
        
        // convert pressure from pHa to inHG
        let inHG = (weatherDataModel.pressure * PRESSURE_IPA_TO_INHG)
        let pressureString = String(format: "%.2f", inHG) + " inHG"
        let attributedPressureString = NSMutableAttributedString(string: pressureString)
        attributedPressureString.addAttribute(NSAttributedStringKey
            .font, value: UIFont(name: "Helvetica", size: 10) as Any, range: NSRange(
            location:6,
            length:4))
        pressureLabel.attributedText = attributedPressureString
        
        // Visiblity is not well supported from OpenWeatherMap at this time. Not worth the trouble
        // visibilityLabel.text = "\(Int(weatherDataModel.visibility * METERS_TO_MILES))  miles"
        
        
        
        
        
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/

    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    
    //Write the PrepareForSegue Method here
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            
            destinationVC.delegate = self
            
        }
        
    }
 
    @IBAction func fahrCelsiusSwitch(_ sender: UISwitch) {
 
        updateWeatherData(json: weatherJSON)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
               userEnteredANewCityName(city: cityLabel.text!)
    }
    
}











