//
//  ParseWeatherDataJSON.swift
//  Clima
//
//  Created by Don Gordon on 2/10/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ForParsedWeatherDelegate {
    func weatherUpdate(updateWeather : WeatherDataModel)
}


class ParseWeatherDataJSON {

    
    
    var weatherDataModel = WeatherDataModel()
    
    var weatherUpdateDelegate : ForParsedWeatherDelegate?
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json : JSON, timeZone : String) {
        
        if let tempResult = json["main"]["temp"].double {
            
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
            
            // Fahrenheit conversion - ° F = 9/5(K - 273) + 32
            weatherDataModel.temperatureFah = Int(((tempResult - 273.15) * (9 / 5)) + 32)
            // Celcius conversion
            weatherDataModel.temperatureCel = Int(tempResult - 273.15)
            
            let formatter = DateFormatter()
            let tempReadingTime = json["dt"].doubleValue
            formatter.dateFormat = "EEEE,  MMM d, yyyy  h:mm a"
            weatherDataModel.timeOfReading = formatter.string(from: Date(timeIntervalSince1970: tempReadingTime))
            
            // Now change formatter to UTC time zone.
            formatter.dateFormat = "h:mm a"
            formatter.timeZone = TimeZone(identifier: String(describing: timeZone))
            let tempSunrise = json["sys"]["sunrise"].doubleValue
            weatherDataModel.sunrise = formatter.string(from: Date(timeIntervalSince1970: tempSunrise))
            let tempSunset = json["sys"]["sunset"].doubleValue
            weatherDataModel.sunset = formatter.string(from: Date(timeIntervalSince1970: tempSunset))
//            print("sunset: \(tempSunset) TimeZone: \(locationDataModel.timeZone)")
            
        } else {
            weatherDataModel.city = "Weather Unavailable"
        }
        self.weatherUpdateDelegate?.weatherUpdate(updateWeather: weatherDataModel)
    }
    
}
