//
//  ForecastViewController.swift
//  Clima
//
//  Created by Don Gordon on 4/6/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//
//
//import UIKit
//import Foundation
//import CoreLocation
//import Alamofire
//import SwiftyJSON
//
//class ForecastViewControllerOld: UIViewController {
//    
//
//    //Constants
//    // api.openweathermap.org/data/2.5/weather?q=London
//    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?"
//    let APP_ID = "e6c49a8257af1f11fc21c0915ffeff43"
//
//    let PRESSURE_IPA_TO_INHG = 0.029529983071445
//    let METERS_TO_MILES = 0.00062137
//
//    // LONDON Forecast:  "http://api.openweathermap.org/data/2.5/forecast?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43"
//    // LONDON Weather:  "http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43"
//    // PineBush Forec:  "http://api.openweathermap.org/data/2.5/forecast?lat=41.6081492&lon=-74.2990401&APPID=e6c49a8257af1f11fc21c0915ffeff43"
//
//    // http://api.openweathermap.org/data/2.5/weather?q=London,UK&APPID=e6c49a8257af1f11fc21c0915ffeff43
//    //  THIS LINE PRINTS ALL TIMEZONE CODES USED IN SWIFT:
//    //  print(TimeZone.abbreviationDictionary)
//
//    let apiService = WeatherAPIService()
//    var weatherDataModel = WeatherDataModel()
//    var location : [String : String?] = [:]
//    var weatherJSON : JSON = []
//    var forecast : Forcast?
//    
//    @IBOutlet weak var locationLabel: UILabel!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //        callAlamofire(url: WEATHER_URL, parameters: location as! [String : String])
//
//
//        getWebRequest()
//        //        print(weatherJSON)
//        //        locationLabel.text = weatherJSON["city"]["name"].stringValue
//
//    }
//
//    //    func getWebRequestTest() {
//    //
//    //
//    ////        guard let gitUrl = URL(string: "https://api.github.com/users/" + userText!) else { return }
//    //        guard let gitUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=41.6081492&lon=-74.2990401&APPID=e6c49a8257af1f11fc21c0915ffeff43") else { return }
//    //        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
//    //
//    //            guard let data = data else { return }
//    //            do {
//    //
//    //                let decoder = JSONDecoder()
//    ////                let forecastData = try decoder.decode(weatherDataModel, from: data)
//    //                let forecastData = try decoder.decode(ForecastDataModel.self, from: data)
//    ////                let coord = try decoder.decode(Coord, from: data)
//    //
//    ////                print(forecastData)
//    //
//    //                DispatchQueue.main.sync {
//    //                    print(forecastData)
//    ////                    print(forecastData.co)
//    //
//    //
//    //
//    ////                    if let gimage = gitData.avatarUrl {
//    ////                        let data = try? Data(contentsOf: gimage)
//    ////                        let image: UIImage = UIImage(data: data!)!
//    ////                        self.gravatarImage.image = image
//    ////                    }
//    ////
//    ////
//    ////                    if let gname = gitData.name {
//    ////                        self.name.text = gname
//    ////                    }
//    ////                    if let glocation = gitData.location {
//    ////                        self.location.text = glocation
//    ////                    }
//    ////
//    ////                    if let gfollowers = gitData.followers {
//    ////                        self.followers.text = String(gfollowers)
//    ////                    }
//    ////
//    ////                    if let grepos = gitData.repos {
//    ////                        self.blog.text = String(grepos)
//    ////                    }
//    ////                    self.setLabelStatus(value: false)
//    //                }
//    //
//    //            } catch let err {
//    //                print("Err", err)
//    //            }
//    //            }.resume()
//    //    }
//    
//    func getWebRequest() {
//
//        let jsonResponse = str.data(using: .utf8)
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        let result = try! decoder.decode(ProductVersion.self, from: jsonResponse!)
//
//
//        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=41.6081492&lon=-74.2990401&APPID=e6c49a8257af1f11fc21c0915ffeff43")
//
//        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            guard let data = data else {
//                print("Error: \(String(describing: error))")
//                return
//            }
//
//            let forecastWrapper = try! self.decoder.decode([String: Forcast].self, from: data)
//            let forecast = forecastWrapper["forecast"]!
//
//            print("\(forecast)")
//        }
//
//        task.resume()
//        
//        
//    }
//
//    //      OLD VERSION OF REQUEST...
//
//    //        apiService.executeWebRequest(urlToExecute: url!) { (responseDic, error) in
//    //            DispatchQueue.main.async {
//    //
//    //                if let unwrappedError = error {
//    //                    print(unwrappedError.localizedDescription)
//    //                }
//    //
//    //                let stringResponse = responseDic?.description
//    //                self.weatherJSON = JSON(stringResponse)
//    //
//    //
//    //                print(self.weatherJSON)
//    //
//    //                do {
//    //                    let forecastData = try JSONDecoder().decode(ForecastDataModel, from: weatherJSON)
//    //                } catch {
//    //                    print("Error in JSON conversion")
//    //                }
//    //            }
//    //
//    //
//    //        }
//    //
//    //    }
//
//
//    func callAlamofire(url: String, parameters: [String: String]) {
//        
//        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
//            response in
//            if response.result.isSuccess {
//
//                self.weatherJSON = JSON(response.result.value!)
//                print("Here: \(self.weatherJSON)  **********Done")
//                self.parseWeatherData(json: self.weatherJSON)
//
//
//            } else {
//                print("Error \(String(describing: response.result.error))")
//            }
//        }
//    }
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//
//    //Write the updateWeatherData method here:
//    
//    func parseWeatherData(json : JSON) {
//        var x = 0
//        
//        if let count = json["cnt"].int {
//            
//            if let tempResult = json["list"][x]["main"]["temp"].double {
//                // Fahrenheit conversion - ° F = 9/5(K - 273) + 32
//                weatherDataModel.temperatureFah = Int(((tempResult - 273.15) * (9 / 5)) + 32)
//                // Celcius conversion
//                weatherDataModel.temperatureCel = Int(tempResult - 273.15)
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
//            // Now change formatter to location's time zone.
//            formatter.dateFormat = "h:mm a"
//            //            formatter.timeZone = TimeZone(identifier: String(describing: locationTimeZone))
//            let tempSunrise = json["sys"]["sunrise"].doubleValue
//            weatherDataModel.sunrise = formatter.string(from: Date(timeIntervalSince1970: tempSunrise))
//            let tempSunset = json["sys"]["sunset"].doubleValue
//            weatherDataModel.sunset = formatter.string(from: Date(timeIntervalSince1970: tempSunset))
//            
//
//            //            print("\(weatherDataModel.city),\(weatherDataModel.country) sunset: \(tempSunset) TimeZone: \(locationTimeZone)")
//
//            //            updateUIWithWeatherData()
//
//        } else {
//            //            cityLabel.text = "Weather Unavailable"
//        }
//    }
//
//}
