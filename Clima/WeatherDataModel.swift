//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Declare your model variables here
    var longitude = 0.0        // -0.13
    var latitude = 0.0         // 51.51
    var temperature = 0       //
    var pressure = 0.0        // hPa at sea level
    var humidity = 0          // 74
    var tempMin = 0           // 275.15   This represents current deviation within area of readings
    var tempMax = 0           // 277.15   This represents current deviation within area of readings
    var visibility = 0.0      // 10000
    var windSpeed = 0.0       // 4.6
    var windDirection = 0     // 250
    var clouds = ""           // 0  cloud % 
    var condition = 0         // based on weather.id - see switch below for selecting graphic icon
    var city = ""             // London
    var country = ""          // GB
    var cityID = ""           // 2643743
    var weatherIconName = ""  // 01n
                              // The time is set as a string value from the JSON conversion
    var timeOfReading = ""    // dt:  1517428200
    var sunrise = ""          // 1517384353  -  we store the Time as string, as we do not do any futher calculations
    var sunset = ""           // 1517417375
    var mainDescription = ""  // Clear
    var subDescription = ""   // clear sky
    
    
    // This method turns the wind direction degrees in symbol
    func windDirection(degrees: Int) -> String {
        
        switch (degrees) {

        case 0...11 : return "N"
        case 348...360 : return "N"
        case 12...34 : return "NNE"
        case 35...56 : return "NE"
        case 57...78 : return "ENE"
        case 79...101 : return "E"
        case 102...123 : return "ESE"
        case 124...146 : return "SE"
        case 147...168 : return "SSE"
        case 169...191 : return "S"
        case 192...213 : return "SSW"
        case 214...236 : return "SW"
        case 237...258 : return "WSW"
        case 259...281 : return "W"
        case 282...303 : return "WNW"
        case 304...326 : return "NW"
        case 327...347 : return "NNW"
            
        default : return "-"
        }
    }
    
    //This method turns a condition code into the name of the weather condition image
    func updateWeatherIcon(condition: Int) -> String {
        
    switch (condition) {
    
        case 0...300 :
            return "tstorm1"
        
        case 301...500 :
            return "light_rain"
        
        case 501...600 :
            return "shower3"
        
        case 601...700 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...903, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }

    }
 
    func getCountryName(code : String) -> String {
        let countries = [
            "AU" : "Australia",
            "GB" : "Britain",
            "BR" : "Brazil",
            "CA" : "Canada",
            "FR" : "France",
            "DE" : "Germany",
            "CL" : "Chile",
            "NL" : "Netherlands",
            "BE" : "Begium",
            "US" : "United States",
            "NZ" : "New Zealand"
        ]
        
        return countries[code]  ?? code
    }
}



// This is the JSON data for Pine Bush,US

//{
//    "main" : {
//        "humidity" : 50,
//        "temp_max" : 272.14999999999998,
//        "temp_min" : 269.14999999999998,
//        "temp" : 270.94999999999999,
//        "pressure" : 1016
//    },
//    "name" : "Pine Bush",
//    "id" : 5131321,
//    "coord" : {
//        "lon" : -74.299999999999997,
//        "lat" : 41.609999999999999
//    },
//    "weather" : [
//    {
//    "id" : 803,
//    "main" : "Clouds",
//    "icon" : "04n",
//    "description" : "broken clouds"
//    }
//    ],
//    "clouds" : {
//        "all" : 75
//    },
//    "dt" : 1517453760,
//    "base" : "stations",
//    "sys" : {
//        "id" : 2114,
//        "message" : 0.0038,
//        "country" : "US",
//        "type" : 1,
//        "sunset" : 1517523193,
//        "sunrise" : 1517486935
//    },
//    "cod" : 200,
//    "visibility" : 16093,
//    "wind" : {
//        "speed" : 5.0999999999999996,
//        "deg" : 220
//    }
//}

