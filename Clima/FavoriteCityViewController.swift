//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName(favCity: LocationDataModel)
}


class FavoriteCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    var favoriteCity = LocationDataModel()
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!


    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //********************************************************************
    
    @IBAction func PineBushUSButtonPushed(_ sender: UIButton) {
        
        favoriteCity.cityName = "Pine Bush"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/New_York"
        favoriteCity.longitude = "-74.2990401"
        favoriteCity.latitude = "41.6081492"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func SonomaButtonPushed(_ sender: UIButton) {
        
        favoriteCity.cityName = "Sonoma"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/Los_Angeles"
        favoriteCity.longitude = "-122.458036"
        favoriteCity.latitude = "38.291859"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func PineBushButtonPushed(_ sender: UIButton) {

        favoriteCity.cityName = "Anchorage"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/Juneau"
        favoriteCity.longitude = "-149.900278"
        favoriteCity.latitude = "61.218056"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func London(_ sender: UIButton) {
        
        favoriteCity.cityName = "London"
        favoriteCity.countryCode = "GB"
        favoriteCity.timeZone = "UTC"
        favoriteCity.longitude = "-0.127758"
        favoriteCity.latitude = "51.507351"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func NewYorkButtonPressed(_ sender: UIButton) {
        
        favoriteCity.cityName = "New York"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/New_York"
        favoriteCity.longitude = "-74.005973"
        favoriteCity.latitude = "40.712775"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func SanClementeButtonPressed(_ sender: UIButton) {
        
        favoriteCity.cityName = "San Clemente"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/Los_Angeles"
        favoriteCity.longitude = "-117.612600"
        favoriteCity.latitude = "33.427352"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func MelborneButtonPressed(_ sender: UIButton) {
        
        favoriteCity.cityName = "Sabina"
        favoriteCity.countryCode = "US"
        favoriteCity.timeZone = "America/New_York"
        favoriteCity.longitude = "-83.636866"
        favoriteCity.latitude = "39.488673"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func thisLocationButtonPressed(_ sender: UIButton) {
        favoriteCity.cityName = "ThisLocation"
        
        delegate?.userEnteredANewCityName(favCity: self.favoriteCity)
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
