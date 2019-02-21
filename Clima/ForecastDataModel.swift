//
//  ForecastDataModel.swift
//  Clima
//
//  Created by Don Gordon on 4/12/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

public struct Forecast : Codable {
    var cod : String
    var message : Double
    var cnt : Int
    var list : [ForecastItem]
    var city : City
}

public struct ForecastItem : Codable {  // "list"
    var dt : Int
    var main : MainData
    var weather : [Weather]
    var clouds : Clouds
    var wind : Wind
    var rain : Rain?
    var sys : System
    var dateText : String
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case rain
        case sys
        case dateText = "dt_txt"
    }
}

struct MainData : Codable {
    var temp : Double
    var tempMax : Double
    var tempMin : Double
    var pressure : Double
    var seaLevel : Double
    var grndLevel : Double
    var humidity : Int
    var tempKF  : Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case tempKF = "temp_kf"
    }
}

public struct Weather : Codable {
    var id : Int
    var main : String
    var description : String
    var icon : String
}

public struct Clouds : Codable {
    var all : Int
}

public struct Wind : Codable {
    var speed : Double
    var deg : Double
}

public struct Rain : Codable {
    var threeHour : Double?

    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}

public struct System : Codable {
    var pod : String
}

public struct City : Codable {
    var id : Int
    var name : String
    var coord : Coordinates
    var country : String
    var population : Int
}

public struct Coordinates : Codable {
    var lat : Double
    var lon : Double
}

public class ForecastDecoder {
//    /// Decodes the `date (dt) or (dt_txt)` fields in `Forecast` structs.
//    lazy var dateTimeFormatter: DateFormatter = {
//        let formatter = DateFormatter.init()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        return formatter
//    }()
//
//    /// Decodes the `date (dt) or (dt_txt)` fields in `FeedItem` structs.
//    lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter.init()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
    
    /// Decodes a Forecast with embedded `list`s and multiple date formats.
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        return decoder
    }()
    
    public func decodeFeed(from data: Data) -> Forecast {
  
        let forecastData = try! self.decoder.decode(Forecast.self, from: data)
        return forecastData
    }
}
