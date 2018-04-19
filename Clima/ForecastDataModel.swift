//
//  ForecastDataModel.swift
//  Clima
//
//  Created by Don Gordon on 4/12/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

struct ForecastDataModel: Codable {
    
    var cod : String?
    let message : Double
    let cnt : Int
    
    struct List: Codable {
        

 
    }

    struct City: Codable {
        var id : String
        var name : String
        var country : String
        var population : String
        var lat : String
        var lon : String
        
        enum CodeKeys :  String, CodingKey {
            case id
            case name
            case country
            case population
            case coord
        }
        
        enum CoordKey : String, CodingKey {
            case lat
            case lon
        }
    }
    

    
    let city : City
//    let coord : Coord
    
}

//struct Coord : Codable {
//    var lat : Double?
//    var lon : Double?
//}

//    var name : String
//    var temperatureFah : Int
//    var pressure : Int
//    var humidity : Int
//    var condition : String
//    var conditionDescription : String
    
//    enum ForecastDataModel: String, CodingKey {
//        case country = "country"
//        case cityName = "name"
//    }

