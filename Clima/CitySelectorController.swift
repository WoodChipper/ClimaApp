//
//  CitySelectorController.swift
//  Clima
//
//  Created by Don Gordon on 2/4/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import MapKit

//Write the protocol declaration here:
protocol CitySelectorDelegate {
    func userSelectedNewCity(newCityData: LocationDataModel)  // String, latitude: String, city: String)
}

class CitySelectorController: UIViewController {
    
    var delegate : CitySelectorDelegate?
    var newCity = LocationDataModel()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCompleter.delegate = self
        searchBar.delegate = self
    }
    
}


extension CitySelectorController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension CitySelectorController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // print("completer: \(searchCompleter.queryFragment)")
        searchResults = completer.results
        
        self.searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension CitySelectorController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
 //       print("completerTV: \(searchCompleter.queryFragment) Row: \(indexPath.row) - \(searchResult.title)")

        return cell
    }
}

extension CitySelectorController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                self.newCity.longitude = String(coordinate?.longitude ?? 0.0)
                self.newCity.latitude = String(coordinate?.latitude ?? 0.0)
                self.newCity.cityName = response?.mapItems[0].name ?? "No Data"
                self.newCity.timeZone = (response?.mapItems[0].timeZone?.identifier) ?? "EST"
                self.newCity.country = response?.mapItems[0].placemark.country ?? "No Data"
                self.newCity.countryCode = response?.mapItems[0].placemark.countryCode ?? "--"
                self.newCity.title = response?.mapItems[0].placemark.title ?? "No Data"
  //              self.newCity.subtitle = response?.mapItems[0].placemark.subtitle ?? "No Data"
                
                self.searchBar.text = response?.mapItems[0].name
                
//                print(response?.mapItems[0].name)
//                print(String(describing: coordinate))
//                print(response?.mapItems)
//                print("lon1: \(longitude)")
                
                self.delegate?.userSelectedNewCity(newCityData : self.newCity)
            
        }
        
//        print("TimeZone: \(newCity.timeZone)")


        self.searchResultsTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
    }
}


