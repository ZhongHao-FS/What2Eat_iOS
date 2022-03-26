//
//  MainViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/23/22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchInput: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage()
        searchInput.backgroundImage = image
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
