//
//  FavoriteViewController.swift
//  WeatherApp
//
//  Created by K Barnes on 2023/02/06.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Reachability

struct WeatherInfo: Codable {
    
    var place: String
    
    var date: String
    
    var icon: String
    
    var weather: String
    
    var temp: String
    
    var wind: String
    
}


class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherDataArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let weatherData = weatherDataArray[indexPath.row]
        
        cell.textLabel?.text = weatherData.place
        
        cell.detailTextLabel?.text = weatherData.date
        
        let imageStr = weatherData.icon
        
        let url = URL(string: "https://openweathermap.org/img/w/\(imageStr).png")
        
        do {
            
            let data = try Data(contentsOf: url!)
            
            cell.imageView?.image = UIImage(data: data)!
            
        } catch {
            
            print(error)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
        
        UIView.animate(withDuration: 0.1, animations: {
            
            cell?.setSelected(false, animated: true)
            
        })
        
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            
            let alertController = UIAlertController(title: "エラー", message: "通信状態を確認してください", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let favoriteConfirmationController = self.storyboard?.instantiateViewController(withIdentifier: "goFavoriteConfirmation") as! FavoriteConfirmationViewController
            
            favoriteConfirmationController.place = weatherDataArray[indexPath.row].place
            
            favoriteConfirmationController.date = weatherDataArray[indexPath.row].date
            
            favoriteConfirmationController.weather = weatherDataArray[indexPath.row].weather
            
            favoriteConfirmationController.temp = weatherDataArray[indexPath.row].temp
            
            favoriteConfirmationController.wind = weatherDataArray[indexPath.row].wind
            
            favoriteConfirmationController.icon = weatherDataArray[indexPath.row].icon
            
            self.navigationController?.pushViewController(favoriteConfirmationController, animated: true)
            
        }
        
        
    }
    
    var weatherDataArray: [WeatherInfo] = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "お気に入り"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myTableView.delegate = self
        
        myTableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        print(weatherDataArray)
        
        if let indexPath = myTableView.indexPathForSelectedRow {
            
            let cell = myTableView.cellForRow(at: indexPath)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                cell?.contentView.backgroundColor = .clear
                
            })
            
        }
        
    }
    
    
    func getData() {
        
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            
            let alertController = UIAlertController(title: "エラー", message: "通信状態を確認してください", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let db = Firestore.firestore()
            
            db.collection("weather").getDocuments { (snapshot, error) in
                
                if let error = error {
                    
                    let alertController = UIAlertController(title: "エラー", message: "通信状態を確認してください", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    for document in snapshot!.documents {
                        
                        let place = document.data()["place"] as! String
                        
                        let date = document.data()["date"] as! String
                        
                        let icon = document.data()["icon"] as! String
                        
                        let weather = document.data()["weather"] as! String
                        
                        let temp = document.data()["temp"] as! String
                        
                        let wind = document.data()["wind"] as! String
                        
                        let weatherData = WeatherInfo(place: place, date: date, icon: icon, weather: weather, temp: temp, wind: wind)
                        
                        self.weatherDataArray.append(weatherData)
                        print(self.weatherDataArray)
                        
                    }
                    
                    self.myTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
}










