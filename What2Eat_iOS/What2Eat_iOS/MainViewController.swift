//
//  MainViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/23/22.
//

import UIKit
import CoreLocation
import CoreLocationUI

class MainViewController: UIViewController, CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    @IBOutlet weak var searchInput: UISearchBar!
    
    let locationManager = CLLocationManager()
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
