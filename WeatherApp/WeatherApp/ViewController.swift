//
//  ViewController.swift
//  WeatherApp
//
//  Created by K Barnes on 2023/01/31.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var prefecturesArray = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
    
    var alphabetPrefecturesArray = ["hokkaido","aomori","iwate","miyagi","akita","yamagata","fukushima","ibaraki","tochigi","gunma","saitama","chiba","tokyo","kanagawa","niigata","toyama","ishikawa","fukui","yamanashi","nagano","gifu","shizuoka","aichi","mie","shiga","kyoto","osaka","hyogo","nara","wakayama","tottori","shimane","oakayama","hiroshima","yamaguchi","tokushima","kagawa","ehime","kochi","fukuoka","saga","nagasaki","kumamoto","oita","miyazaki","kagoshima","okinawa"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return prefecturesArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = prefecturesArray[indexPath.row]
        
        cell.backgroundColor = .clear
        
        cell.textLabel?.textAlignment = .center
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
          cell?.isSelected = false
        
          UIView.animate(withDuration: 0.5, animations: {
              
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
            
            let weatherViewController = self.storyboard?.instantiateViewController(withIdentifier: "goWeather") as! WeatherViewController
            
            guard let keyword = alphabetPrefecturesArray[indexPath.row] as? String else {
                
                return
                
            }
            
            let urlfile = "https://api.openweathermap.org/data/2.5/weather?q=\(keyword)&units=metric&APPID=3c65c43e5828fd90fa42ec79722de5b4&lang=ja"
            
            AF.request(urlfile).responseJSON{ (response) in
                
                
                switch response.result {
                    
                case.success(_):
                    
                    do {
                        
                        let json: JSON = JSON(response.data as Any)
                        
                        let weather = json["weather"][0]
                        
                        weatherViewController.icon = weather["icon"].stringValue
                        
                        weatherViewController.place = json["name"].stringValue
                        
                        weatherViewController.temp = String(json["main"]["temp"].doubleValue)
                        
                        weatherViewController.wind = String(json["wind"]["speed"].doubleValue)
                        
                        weatherViewController.weather = weather["description"].stringValue
                        
                        let dt = json["dt"].doubleValue
                        
                        let date = Date(timeIntervalSince1970: dt)
                        
                        let formatter = DateFormatter()
                        
                        formatter.dateFormat = "yyyy／MM／dd HH:mm"
                        
                        
                        
                        weatherViewController.date = formatter.string(from: date)
                        
                    } catch {
                        
                        print("失敗しました")
                        
                    }
                    
                case.failure(let error):
                    
                    print("Error Occured \(error.localizedDescription)")
                    
                }
                
                self.navigationController?.pushViewController(weatherViewController, animated: true)
                
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        
        myTableView.delegate = self
        
        self.navigationItem.title = "天気予報アプリ"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // UIBarbuttonItemのactionを設定
        let button = UIBarButtonItem(title: "お気に入り", style: .done, target: self, action: #selector(self.buttonTapped(_:)))
        
        self.navigationItem.leftBarButtonItem = button
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = myTableView.indexPathForSelectedRow {
            
                let cell = myTableView.cellForRow(at: indexPath)
            
            UIView.animate(withDuration: 0.5, animations: {
                    
                    cell?.contentView.backgroundColor = .clear
                    
                })
            
            }
        
    }
    
    
    @objc func buttonTapped(_ sender: UIBarButtonItem) {
        
        let weatherViewController = self.storyboard?.instantiateViewController(withIdentifier: "goFavorite") as! FavoriteViewController
        
        self.navigationController?.pushViewController(weatherViewController, animated: true)
        
        return
        
    }
    
    /* 引数あり、戻り値ありの関数 */
    
//    var aaacount = 12
//    var bbbcount = 0
//
    /* start 呼び出したいところに入れてください
    let abc = test(one: aaacount, two: bbbcount)
    print(abc)
     end 呼び出したいところに入れてください */

//    func test(one: Int, two : Int) -> Int{
//
//        let after = 1 + one
//
//        let bafter = 1 + two
//
//        let cafter = after + bafter
//
//        if testflag == 0 {
//
//            return after
//
//        } else if testflag == 1 {
//
//            return bafter
//
//        } else {
//
//            return cafter
//        }
//    }
    
}


