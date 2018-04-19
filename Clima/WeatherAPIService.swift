//
//  WeatherAPIService.swift
//  Clima
//
//  Created by Don Gordon on 4/11/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherAPIService {
    
    var weatherJSON : JSON = []
    
    func executeWebRequest(urlToExecute : URL, completionHandler : @escaping ([String:Any]?, Error?)->Void) {
    
        let sharedSession = URLSession.shared
    
        let webRequest = URLRequest(url: urlToExecute)
    
        let dataTask = sharedSession.dataTask(with: webRequest) { (webData, URLResponse, apiError) in
            
            // catch no response from the WEB
            guard let unwrappedData = webData else {
                completionHandler(nil, apiError)
                return
            }
            
            // Now we safely have a response...
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String:Any]
                
                completionHandler(jsonResponse, nil)
            } catch {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
        dataTask.resume()
    }
}
