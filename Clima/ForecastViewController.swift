//
//  ForecastViewController.swift
//  Clima
//
//  Created by Don Gordon on 4/6/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//
//  This is following the tutorial: https://www.quickbytes.io/tutorials/custom-keys-in-codable

import UIKit
import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class ForecastViewController: UIViewController {

    
    //Constants
    // api.openweathermap.org/data/2.5/weather?q=London
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?"
    let APP_ID = "e6c49a8257af1f11fc21c0915ffeff43"
    
    let PRESSURE_IPA_TO_INHG = 0.029529983071445
    let METERS_TO_MILES = 0.00062137
    
    // LONDON Forecast:  "http://api.openweathermap.org/data/2.5/forecast?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43"
    // LONDON Weather:  "http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43"
    // PineBush Forec:  "http://api.openweathermap.org/data/2.5/forecast?lat=41.6081492&lon=-74.2990401&APPID=e6c49a8257af1f11fc21c0915ffeff43"

    // http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43
    //  THIS LINE PRINTS ALL TIMEZONE CODES USED IN SWIFT:
    //  print(TimeZone.abbreviationDictionary)
    
    let apiService = WeatherAPIService()
    var weatherDataModel = WeatherDataModel()
    var dateFormatters = Formatters()
    var location : [String : String?] = [:]
    var weatherJSON : JSON = []
    
    var forecast: Forecast?
    let decoder = ForecastDecoder.init()
    
    //MARK: Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var daySegment: UISegmentedControl!

    @IBOutlet weak var cloudCoveringLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    
    @IBOutlet weak var temp0: UILabel!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var temp4: UILabel!
    @IBOutlet weak var temp5: UILabel!
    @IBOutlet weak var temp6: UILabel!
    @IBOutlet weak var temp7: UILabel!
    
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var time0: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time4: UILabel!
    @IBOutlet weak var time5: UILabel!
    @IBOutlet weak var time6: UILabel!
    @IBOutlet weak var time7: UILabel!
    
    @IBOutlet weak var icon0: UIImageView!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var icon6: UIImageView!
    @IBOutlet weak var icon7: UIImageView!
    
    @IBOutlet weak var clouds0: UILabel!
    @IBOutlet weak var clouds1: UILabel!
    @IBOutlet weak var clouds2: UILabel!
    @IBOutlet weak var clouds3: UILabel!
    @IBOutlet weak var clouds4: UILabel!
    @IBOutlet weak var clouds5: UILabel!
    @IBOutlet weak var clouds6: UILabel!
    @IBOutlet weak var clouds7: UILabel!
    
    @IBOutlet weak var cond0: UILabel!
    @IBOutlet weak var cond1: UILabel!
    @IBOutlet weak var cond2: UILabel!
    @IBOutlet weak var cond3: UILabel!
    @IBOutlet weak var cond4: UILabel!
    @IBOutlet weak var cond5: UILabel!
    @IBOutlet weak var cond6: UILabel!
    @IBOutlet weak var cond7: UILabel!
    
    @IBOutlet weak var humidity0: UILabel!
    @IBOutlet weak var humidity1: UILabel!
    @IBOutlet weak var humidity2: UILabel!
    @IBOutlet weak var humidity3: UILabel!
    @IBOutlet weak var humidity4: UILabel!
    @IBOutlet weak var humidity5: UILabel!
    @IBOutlet weak var humidity6: UILabel!
    @IBOutlet weak var humidity7: UILabel!
    
    @IBOutlet weak var wind0: UILabel!
    @IBOutlet weak var wind1: UILabel!
    @IBOutlet weak var wind2: UILabel!
    @IBOutlet weak var wind3: UILabel!
    @IBOutlet weak var wind4: UILabel!
    @IBOutlet weak var wind5: UILabel!
    @IBOutlet weak var wind6: UILabel!
    @IBOutlet weak var wind7: UILabel!
    
    @IBOutlet weak var presMB0: UILabel!
    @IBOutlet weak var presMB1: UILabel!
    @IBOutlet weak var presMB3: UILabel!
    @IBOutlet weak var presMB2: UILabel!
    @IBOutlet weak var presMB4: UILabel!
    @IBOutlet weak var presMB5: UILabel!
    @IBOutlet weak var presMB6: UILabel!
    @IBOutlet weak var presMB7: UILabel!
    
    @IBOutlet weak var press0: UILabel!
    @IBOutlet weak var press1: UILabel!
    @IBOutlet weak var press2: UILabel!
    @IBOutlet weak var press3: UILabel!
    @IBOutlet weak var press4: UILabel!
    @IBOutlet weak var press5: UILabel!
    @IBOutlet weak var press6: UILabel!
    @IBOutlet weak var press7: UILabel!
    
    @IBOutlet weak var rain0: UILabel!
    @IBOutlet weak var rain1: UILabel!
    @IBOutlet weak var rain2: UILabel!
    @IBOutlet weak var rain3: UILabel!
    @IBOutlet weak var rain4: UILabel!
    @IBOutlet weak var rain5: UILabel!
    @IBOutlet weak var rain6: UILabel!
    @IBOutlet weak var rain7: UILabel!
    
    @IBOutlet weak var snow0: UILabel!
    @IBOutlet weak var snow1: UILabel!
    @IBOutlet weak var snow2: UILabel!
    @IBOutlet weak var snow3: UILabel!
    @IBOutlet weak var snow4: UILabel!
    @IBOutlet weak var snow5: UILabel!
    @IBOutlet weak var snow6: UILabel!
    @IBOutlet weak var snow7: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let latitude = String(weatherDataModel.latitude)
        let longitude = String(weatherDataModel.longitude)
        
        let urlString = WEATHER_URL + "lat=" + latitude + "&lon=" + longitude + "&units=imperial&APPID=" + APP_ID
        
        // For testing:
        
        // For imperial measurements: &units=imperial
        //  let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=41.6081492&lon=-74.2990401&APPID=e6c49a8257af1f11fc21c0915ffeff43")
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }
            
            let forecast = self.decoder.decodeFeed(from: data)
            DispatchQueue.main.async {
                self.forecast = forecast
            }
            
            DispatchQueue.main.async { // Correct
                self.updateVC(forecast: forecast)
            }
            
        }
        
        task.resume()
    }
    
    func updateVC(forecast: Forecast) {
        let forecastDay = daySegment.selectedSegmentIndex * 8
        let timeZone = weatherDataModel.timeZone
        
        // MARK: Print Label names...
//        self.locationLabel.attributedText = formatDescriptionText(normalText: "\(forecast.city.name), ", smallText: forecast.city.country)
        
        self.locationLabel.attributedText = formatDescriptionText(normalText: "\(forecast.city.name), ", smallText: weatherDataModel.getCountryName(code: weatherDataModel.country))
        self.cloudCoveringLabel.attributedText = formatDescriptionText(normalText: "   Cloud Covering", smallText: "")
        self.humidityLabel.attributedText = formatDescriptionText(normalText: "   Humidity", smallText: "")
        self.windSpeedLabel.attributedText = formatDescriptionText(normalText: "   Wind", smallText: " (mph)")
        self.pressureLabel.attributedText = formatDescriptionText(normalText: "   Pressure", smallText: " (inHG)")
        self.rainLabel.attributedText = formatDescriptionText(normalText: "   Rain", smallText: "...(inches previous 3 hours)")
        
        for interval in 0...7 {
            switch interval {
                
            case 0:
                self.dayDate.text = "\(dateFormatters.dayDate(JSONDate: Double(forecast.list[interval + forecastDay].dt), timeZone: timeZone))"
                // print("I: \(interval) fd: \(forecastDay) i+fd: \(interval + forecastDay)")
                
                self.time0.attributedText = getTime(interval: interval + forecastDay)
                self.temp0.text = getTemp(interval: interval + forecastDay)
                self.icon0.image = getIcon(interval: interval + forecastDay)
                self.clouds0.text = getClouds(interval: interval + forecastDay)
                self.humidity0.text = getHumidity(interval: interval + forecastDay)
                self.cond0.text = getCond(interval: interval + forecastDay)
                self.wind0.attributedText = getWind(interval: interval + forecastDay)
                self.presMB0.text = getPressure(interval: interval + forecastDay)
                self.press0.text = getInchPressure(interval: interval + forecastDay)
                self.rain0.text = getRain(interval: interval + forecastDay)
            case 1:
                self.time1.attributedText = getTime(interval: interval + forecastDay)
                self.temp1.text = getTemp(interval: interval + forecastDay)
                self.icon1.image = getIcon(interval: interval + forecastDay)
                self.clouds1.text = getClouds(interval: interval + forecastDay)
                self.humidity1.text = getHumidity(interval: interval + forecastDay)
                self.cond1.text = getCond(interval: interval + forecastDay)
                self.wind1.attributedText = getWind(interval: interval + forecastDay)
                self.presMB1.text = getPressure(interval: interval + forecastDay)
                self.press1.text = getInchPressure(interval: interval + forecastDay)
                self.rain1.text = getRain(interval: interval + forecastDay)
            case 2:
                self.time2.attributedText = getTime(interval: interval + forecastDay)
                self.temp2.text = getTemp(interval: interval + forecastDay)
                self.icon2.image = getIcon(interval: interval + forecastDay)
                self.clouds2.text = getClouds(interval: interval + forecastDay)
                self.humidity2.text = getHumidity(interval: interval + forecastDay)
                self.cond2.text = getCond(interval: interval + forecastDay)
                self.wind2.attributedText = getWind(interval: interval + forecastDay)
                self.presMB2.text = getPressure(interval: interval + forecastDay)
                self.press2.text = getInchPressure(interval: interval + forecastDay)
                self.rain2.text = getRain(interval: interval + forecastDay)
            case 3:
                self.time3.attributedText = getTime(interval: interval + forecastDay)
                self.temp3.text = getTemp(interval: interval + forecastDay)
                self.icon3.image = getIcon(interval: interval + forecastDay)
                self.clouds3.text = getClouds(interval: interval + forecastDay)
                self.humidity3.text = getHumidity(interval: interval + forecastDay)
                self.cond3.text = getCond(interval: interval + forecastDay)
                self.wind3.attributedText = getWind(interval: interval + forecastDay)
                self.presMB3.text = getPressure(interval: interval + forecastDay)
                self.press3.text = getInchPressure(interval: interval + forecastDay)
                self.rain3.text = getRain(interval: interval + forecastDay)
            case 4:
                self.time4.attributedText = getTime(interval: interval + forecastDay)
                self.temp4.text = getTemp(interval: interval + forecastDay)
                self.icon4.image = getIcon(interval: interval + forecastDay)
                self.clouds4.text = getClouds(interval: interval + forecastDay)
                self.humidity4.text = getHumidity(interval: interval + forecastDay)
                self.cond4.text = getCond(interval: interval + forecastDay)
                self.wind4.attributedText = getWind(interval: interval + forecastDay)
                self.presMB4.text = getPressure(interval: interval + forecastDay)
                self.press4.text = getInchPressure(interval: interval + forecastDay)
                self.rain4.text = getRain(interval: interval + forecastDay)
            case 5:
                self.time5.attributedText = getTime(interval: interval + forecastDay)
                self.temp5.text = getTemp(interval: interval + forecastDay)
                self.icon5.image = getIcon(interval: interval + forecastDay)
                self.clouds5.text = getClouds(interval: interval + forecastDay)
                self.humidity5.text = getHumidity(interval: interval + forecastDay)
                self.cond5.text = getCond(interval: interval + forecastDay)
                self.wind5.attributedText = getWind(interval: interval + forecastDay)
                self.presMB5.text = getPressure(interval: interval + forecastDay)
                self.press5.text = getInchPressure(interval: interval + forecastDay)
                self.rain5.text = getRain(interval: interval + forecastDay)
            case 6:
                self.time6.attributedText = getTime(interval: interval + forecastDay)
                self.temp6.text = getTemp(interval: interval + forecastDay)
                self.icon6.image = getIcon(interval: interval + forecastDay)
                self.clouds6.text = getClouds(interval: interval + forecastDay)
                self.humidity6.text = getHumidity(interval: interval + forecastDay)
                self.cond6.text = getCond(interval: interval + forecastDay)
                self.wind6.attributedText = getWind(interval: interval + forecastDay)
                self.presMB6.text = getPressure(interval: interval + forecastDay)
                self.press6.text = getInchPressure(interval: interval + forecastDay)
                self.rain6.text = getRain(interval: interval + forecastDay)
            case 7:
                if forecastDay < 32 {
                    self.time7.attributedText = getTime(interval: interval + forecastDay)
                    self.temp7.text = getTemp(interval: interval + forecastDay)
                    self.icon7.image = getIcon(interval: interval + forecastDay)
                    self.clouds7.text = getClouds(interval: interval + forecastDay)
                    self.humidity7.text = getHumidity(interval: interval + forecastDay)
                    self.cond7.text = getCond(interval: interval + forecastDay)
                    self.wind7.attributedText = getWind(interval: interval + forecastDay)
                    self.presMB7.text = getPressure(interval: interval + forecastDay)
                    self.press7.text = getInchPressure(interval: interval + forecastDay)
                    self.rain7.text = getRain(interval: interval + forecastDay)
                } else {
                    self.time7.text = "--"
                    self.temp7.text = "--"
//                    self.icon7.image = "--"
                    self.clouds7.text = "--"
                    self.humidity7.text = "--"
                    self.cond7.text = "--"
                    self.wind7.text = "--"
                    self.press7.text = "--"
                    self.rain7.text = "--"
                }
            default:
                return
            }
 
        }
    }
    
    func getTime(interval: Int) -> NSAttributedString {
        let timeZone = weatherDataModel.timeZone
        // Using formatting extension
        let formattedString = NSMutableAttributedString()
//        print("\(interval): \(forecast?.list[interval].dt)")
        formattedString
            .normal("\(dateFormatters.hourDate(JSONDate: Double((forecast?.list[interval].dt)!), timeZone: timeZone))")
            .small(" \(dateFormatters.amPmDate(JSONDate: Double((forecast?.list[interval].dt)!), timeZone: timeZone))")
        return formattedString
    }
    
    func getTemp(interval: Int) -> String {
        let fahrenheitOrCelcius = weatherDataModel.fahrenheitOrCelcius
        return "\(weatherDataModel.convertFahrenheitTemp(temp: forecast!.list[interval].main.temp, FahrOrCelc: fahrenheitOrCelcius))°"
    }

    func getIcon(interval: Int) -> UIImage {
        let iconNum = forecast?.list[interval].weather[0].id
        return UIImage(named: weatherDataModel.updateWeatherIcon(condition: iconNum!))!
    }
    
    func getClouds(interval: Int) -> String {
        return "\(forecast!.list[interval].clouds.all)%"
    }
    
    func getHumidity(interval: Int) -> String {
        return "\(forecast!.list[interval].main.humidity)%"
    }
    
    func getCond(interval: Int) -> String {
        return "\(forecast!.list[interval].weather[0].main)"
    }
    
    func getWind(interval: Int) -> NSAttributedString {
            // mph = m/s * (3600/1609.344)
        let windDeg = weatherDataModel.windDirection(degrees: Int((forecast?.list[interval].wind.deg)!))
        let windSpeed = "\(Int(round((forecast?.list[interval].wind.speed)!)))"
        return formatDescriptionText(normalText: windSpeed, smallText: windDeg)
    }
    
    func getPressure(interval: Int) -> String {
        // basic pressure milliBars mB
        let mB = (forecast?.list[interval].main.pressure)!
        return String(Int(mB))
    }
    
    func getInchPressure(interval: Int) -> String {
        // convert pressure from pHa to inHG
        let inHG = (forecast?.list[interval].main.pressure)! * PRESSURE_IPA_TO_INHG
        return String(format: "%.2f", inHG)
    }
    
    func getRain(interval: Int) -> String {
        return String(format:"%.2f", forecast!.list[interval].rain?.threeHour ?? 0.0)
    }
    
    func formatDescriptionText(normalText: String, smallText: String) -> NSAttributedString {
        
        // Using extension
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("\(normalText)")
            .small(" \(smallText)")
        return formattedString
        // Extension finished
        
    }
    
    @IBAction func daySegmentPressed(_ sender: UISegmentedControl) {
        print(daySegment.selectedSegmentIndex * 8)
        updateVC(forecast: forecast!)
    }
    
    
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


