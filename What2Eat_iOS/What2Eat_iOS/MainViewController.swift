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
        if let last = locations.last {
            urlString = "https://api.foursquare.com/v3/places/search?ll=\(last.coordinate.latitude)%2C\(last.coordinate.longitude)&radius=8000&categories=13000&fields=name%2Cdescription%2Cphotos"
            
            performSegue(withIdentifier: "search", sender: manager)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false && searchBar.text != "" {
            urlString = "https://api.foursquare.com/v3/places/search?categories=13000&fields=name%2Cdescription%2Cphotos&near=" + (searchBar.text ?? "Orlando%2C%20FL")
            
            performSegue(withIdentifier: "search", sender: searchBar)
        }
    }
    
    @IBOutlet weak var searchInput: UISearchBar!
    
    let locationManager = CLLocationManager()
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage()
        searchInput.backgroundImage = image
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        let clButton = CLLocationButton()
        clButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
    }
    
    @objc func getCurrentLocation() {
        self.locationManager.requestLocation()
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
