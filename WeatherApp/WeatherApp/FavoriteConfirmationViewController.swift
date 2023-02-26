//
//  FavoriteConfirmationViewController.swift
//  WeatherApp
//
//  Created by K Barnes on 2023/02/07.
//

import UIKit

class FavoriteConfirmationViewController: UIViewController {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    var place = ""
    
    var date = ""
    
    var icon = ""
    
    var weather = ""
    
    var temp = ""
    
    var wind = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "天気予報アプリ"
        
        self.view.addBackground(name: "sunny")
        
        placeLabel.text = ("ここは\(place)")
        
        dateLabel.text = ("今日は\(date)")
        
        weatherLabel.text = ("天候は\(weather)")
        
        tempLabel.text = ("気温は\(temp)")
        
        windLabel.text = ("風速は\(wind)")
        
        let url = "https://openweathermap.org/img/w/\(icon).png"
        
        if let imageUrl = URL(string: url) {
            
            do {
                
                let data = try Data(contentsOf: imageUrl)
                
                iconImageView.image = UIImage(data: data)
                
            } catch {
                
                print("error")
                
            }
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let subviews = view.subviews
        
        for subview in subviews {
            
            subview.removeFromSuperview()
            
        }
        
    }
    
}
