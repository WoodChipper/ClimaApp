//
//  GetWeatherData.swift
//  Clima
//
//  Created by Don Gordon on 4/7/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

//Write the protocol declaration here:
protocol GetWeatherDelegate {
    func getJSON(weatherData: WeatherDataModel)
//    func testDelegate(testString: String)
}


class GetWeatherData {
    
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
    var delegate : GetWeatherDelegate?
    
    let locationManager = CLLocationManager()
    var weatherDataModel = WeatherDataModel()
    var locationDataModel = LocationDataModel()
    var parseWeatherDataJSON = ParseWeatherDataJSON()
    
    var weatherJSON : JSON = []
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                self.weatherJSON = JSON(response.result.value!)
                
 //               self.updateWeatherData(json: self.weatherJSON)
                
                
                self.parseJSONWeatherData(weatherJSON: self.weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
//                self.cityLabel.text = "Connection Issues"
            }
        }

    }
    
    func parseJSONWeatherData(weatherJSON : JSON) {
//        print("\(weatherJSON)  *****NOW!")
        
        weatherDataModel.city = weatherJSON["city"]["name"].stringValue
        weatherDataModel.country = weatherJSON["city"]["country"].stringValue
        weatherDataModel.cityID = weatherJSON["city"]["id"].stringValue
        weatherDataModel.longitude = weatherJSON["city"]["coord"]["lon"].doubleValue
        weatherDataModel.latitude = weatherJSON["city"]["coord"]["lat"].doubleValue
        
        print(weatherDataModel.city)
                print(weatherDataModel.country)
                print(weatherDataModel.cityID)
                print(weatherDataModel.longitude)
                print(weatherDataModel.latitude)
        
    }
    
}
