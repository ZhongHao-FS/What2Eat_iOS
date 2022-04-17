//
//  MainViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/23/22.
//

import UIKit
import CoreLocation
import CoreLocationUI

class MainViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating location...")
        if let first = locations.first {
            clLocation = first
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            urlString = "https://api.foursquare.com/v3/places/search?categories=13000&fields=name%2Cdescription%2Cphotos&near=" + keyword
        
            performSegue(withIdentifier: "search", sender: searchBar)
        }
    
    }
    
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var locationButton: CLLocationButton!
    
    let locationManager = CLLocationManager()
    var urlString = ""
    var clLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage()
        searchInput.backgroundImage = image
        searchInput.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let clButton = CLLocationButton()
        clButton.addTarget(locationButton, action: #selector(searchWithLocation), for: .touchUpInside)
    }
    
    @objc func searchWithLocation() {
        urlString = "https://api.foursquare.com/v3/places/search?ll=\(self.clLocation.coordinate.latitude)%2C\(self.clLocation.coordinate.longitude)&radius=8000&categories=13000&fields=name%2Cdescription%2Cphotos"
        print(urlString)
        
        performSegue(withIdentifier: "search", sender: self)
    }
    
    @IBAction func segueOverridden(_ sender: UIButton) {
        urlString = "https://api.foursquare.com/v3/places/search?categories=13000&fields=name%2Cdescription%2Cphotos&near=Orlando%2C%20FL"
        performSegue(withIdentifier: "search", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? CarouselViewController {
            // Pass the selected object to the new view controller.
            destination.api = self.urlString
        }
        
    }
    

}
