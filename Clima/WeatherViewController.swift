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



class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, CitySelectorDelegate, ForParsedWeatherDelegate {

    
    
    @IBOutlet weak var faren: UISwitch!
    //Constants
                           // api.openweathermap.org/data/2.5/weather?q=London
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e6c49a8257af1f11fc21c0915ffeff43"
    
    let PRESSURE_IPA_TO_INHG = 0.029529983071445
    let METERS_TO_MILES = 0.00062137
    
    // complete URL for testing:  "api.openweathermap.org/data/2.5/forecast?id=524901&APPID=1111111111"
    // http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43
    //  THIS LINE PRINTS ALL TIMEZONE CODES USED IN SWIFT:
    //  print(TimeZone.abbreviationDictionary)
    

    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    var weatherDataModel = WeatherDataModel()
    var locationDataModel = LocationDataModel()
    var parseWeatherDataJSON = ParseWeatherDataJSON()
    var selectedCityName: String?
    var selectedCityLonLat: String?
    var isSelectedCity = false

 
    
    
    
    // IBOutlets
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
    @IBOutlet weak var citySelectedName: UILabel!
    @IBOutlet weak var longLatOfSelectedCity: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        // Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        citySelectedName.isHidden = true
        longLatOfSelectedCity.isHidden = true
    }
    

    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    var weatherJSON : JSON = []
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                self.weatherJSON = JSON(response.result.value!)
                
                self.parseWeatherDataJSON.updateWeatherData(json: self.weatherJSON, timeZone : self.locationDataModel.timeZone)

                self.updateUIWithWeatherData()
            //   print(weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
  
    //Write the updateWeatherData method here:
    
//    func updateWeatherData(json : JSON) {
//
//        if let tempResult = json["main"]["temp"].double {
//
//            if fahrOrCelsiusSwitch.isOn {
//                // Fahrenheit conversion - ° F = 9/5(K - 273) + 32
//                weatherDataModel.temperature = Int(((tempResult - 273.15) * (9 / 5)) + 32)
//                FahrenheitCelsiusSwitchLabel.text = "F"
//            } else {
//                // Celcius conversion
//                weatherDataModel.temperature = Int(tempResult - 273.15)
//                FahrenheitCelsiusSwitchLabel.text = "C"
//            }
//
//            weatherDataModel.tempMax = Int(json["main"]["temp_max"].doubleValue)
//            weatherDataModel.tempMin = Int(json["main"]["temp_min"].doubleValue)
//            weatherDataModel.pressure = json["main"]["pressure"].doubleValue
//            weatherDataModel.humidity = Int(json["main"]["humidity"].doubleValue)
//
//            // Visiblity is not well supported from OpenWeatherMap at this time. Not worth the trouble
//            // weatherDataModel.visibility = json["visibility"].doubleValue   // meters
//
//            weatherDataModel.windSpeed = json["wind"]["speed"].doubleValue   // meters/second
//            weatherDataModel.windDirection = Int(json["wind"]["deg"].doubleValue)
//            weatherDataModel.clouds = json["clouds"]["all"].stringValue
//        
//            weatherDataModel.city = json["name"].stringValue
//            weatherDataModel.country = json["sys"]["country"].stringValue
//            weatherDataModel.cityID = json["sys"]["id"].stringValue
//            weatherDataModel.longitude = json["coord"]["lon"].doubleValue
//            weatherDataModel.latitude = json["coord"]["lat"].doubleValue
//
//            weatherDataModel.condition = json["weather"][0]["id"].intValue
//            weatherDataModel.mainDescription = json["weather"][0]["main"].stringValue
//            weatherDataModel.subDescription = json["weather"][0]["description"].stringValue
//        
//            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
//
//            let formatter = DateFormatter()
//            let tempReadingTime = json["dt"].doubleValue
//            formatter.dateFormat = "EEEE,  MMM d, yyyy  h:mm a"
//            weatherDataModel.timeOfReading = formatter.string(from: Date(timeIntervalSince1970: tempReadingTime))
//
//            // Now change formatter to UTC time zone.
//            formatter.dateFormat = "h:mm a"
//            formatter.timeZone = TimeZone(identifier: String(describing: locationDataModel.timeZone))
//            let tempSunrise = json["sys"]["sunrise"].doubleValue
//            weatherDataModel.sunrise = formatter.string(from: Date(timeIntervalSince1970: tempSunrise))
//            let tempSunset = json["sys"]["sunset"].doubleValue
//            weatherDataModel.sunset = formatter.string(from: Date(timeIntervalSince1970: tempSunset))
////            print("sunset: \(tempSunset) TimeZone: \(locationDataModel.timeZone)")
//            updateUIWithWeatherData()
//
//        } else {
//            cityLabel.text = "Weather Unavailable"
//        }
//    }

//    //**********************************
//    // DATE formatter
//    func convertUTCToUTC(dateToConvert:String) -> String {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
//        formatter.timeZone = TimeZone(identifier: "UTC")
//
//        let convertedDate = formatter.date(from: dateToConvert)
//        formatter.timeZone = TimeZone(identifier: "UTC")
//        return formatter.string(from: convertedDate!)
//
//    }
    //MARK: - UI Updates
    /***************************************************************/
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        
        if fahrOrCelsiusSwitch.isOn {
            // Fahrenheit
            temperatureLabel.text = "\(weatherDataModel.temperatureFah)°"
            FahrenheitCelsiusSwitchLabel.text = "F"
        } else {
            // Celsius
            temperatureLabel.text = "\(weatherDataModel.temperatureCel)°"
            FahrenheitCelsiusSwitchLabel.text = "C"
        }

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
            
           // print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
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
    
    
    // Favorites: userEnteredANewCityName Delegate method here:
    
    func weatherUpdate(updateWeather: WeatherDataModel) {
        weatherDataModel = updateWeather
    }
    

    func userEnteredANewCityName(favCity: LocationDataModel) {
        
        citySelectedName.isHidden = true
        longLatOfSelectedCity.isHidden = true
        isSelectedCity = false
        
        let params : [String : String] = ["lat" : favCity.latitude, "lon" : favCity.longitude, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    // selected City delegate received
    
    func userSelectedNewCity(newCityData: LocationDataModel) {
        
        citySelectedName.isHidden = false
        longLatOfSelectedCity.isHidden = false
        isSelectedCity = true
        locationDataModel = newCityData
        

        citySelectedName.text = newCityData.cityName
        longLatOfSelectedCity.text = getLonLatString(longitude: newCityData.longitude, latitude: newCityData.latitude)

        let params : [String : String] = ["lat" : newCityData.latitude, "lon" : newCityData.longitude, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)

    }
    
    func getLonLatString(longitude: String, latitude: String) -> String {
        
        // format Longitude and Latitude to 3 decimal places
        let lon = String(format: "%.3f", Double(longitude)!)
        let lat = String(format: "%.3f", Double(latitude)!)
        return "Lon: \(lon)  Lat: \(lat)"
        
    }
    
    //Write the PrepareForSegue Method here
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            
        }
        if segue.identifier == "CitySelectorSegue" {
            let destinationVC = segue.destination as! CitySelectorController
            destinationVC.delegate = self
        }
        
        
    }
 
    @IBAction func fahrCelsiusSwitch(_ sender: UISwitch) {

        if fahrOrCelsiusSwitch.isOn {
            // Fahrenheit
            temperatureLabel.text = "\(weatherDataModel.temperatureFah)°"
            FahrenheitCelsiusSwitchLabel.text = "F"
        } else {
            // Celsius
            temperatureLabel.text = "\(weatherDataModel.temperatureCel)°"
            FahrenheitCelsiusSwitchLabel.text = "C"
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {

//        let currentCity = weatherDataModel.city + "," + weatherDataModel.country
//
//        userEnteredANewCityName(city: currentCity)
        
//        userSelectedNewCity(longitude: String, latitude: String)(latitude: "51.509", longitude: "-0.13")
    }
    
}











