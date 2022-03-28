//
//  CarouselViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/27/22.
//

import UIKit
import Foundation

class CarouselViewController: UIViewController {

    @IBOutlet weak var container: StackContainerView!
    
    var api = ""
    var imageString = ""
    var nameString = ""
    var descripString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if api != "" {
            searchTask(api)
        }
    }
    
    func searchTask(_ urlString: String) {
        let headers = [
          "Accept": "application/json",
          "Authorization": "fsq3MjiKi+i7kTBHl09T7QY2jRL1NlPAcbbqIq5WwgLM+UU="
        ]

        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
          if let e = error {
              print(e.localizedDescription)
          } else {
              guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {return}
              
              do {
                  if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                      guard let results = json["results"] as? [Any],
                            let restaurant = results[0] as? [String: Any] else {return}
                      if let description = restaurant["description"] as? String {
                          self.descripString = description
                      }
                      if let name = restaurant["name"] as? String {
                          self.nameString = name
                      }
                      
                      guard let photos = restaurant["photos"] as? [Any],
                            let photo = photos[0] as? [String: Any],
                            let prefix = photo["prefix"] as? String,
                            let suffix = photo["suffix"] as? String else {return}
                      self.imageString = prefix + "280x408" + suffix
                      
                  }
              } catch {
                  print(error.localizedDescription)
              }
              
              DispatchQueue.main.async {
                  self.container.addSubview(self.loadSlide())
              }
          }
        })

        dataTask.resume()
    }
    
    func loadSlide() -> Slide {
        let slide = Bundle.main.loadNibNamed("Slide", owner: self)?.first as! Slide
        slide.title.text = nameString
        slide.descriptions.text = descripString
        if let url = URL(string: imageString) {
            do {
                let imageData = try Data.init(contentsOf: url)
                slide.featureImage.image = UIImage(data: imageData)
            } catch {
                print("image loading error")
            }
        }
        
        return slide
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
