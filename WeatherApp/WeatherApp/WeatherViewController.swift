//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by K Barnes on 2023/01/31.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Reachability

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
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
        
        let button = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(self.buttonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = button
        
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
                
                iconImage.image = UIImage(data: data)
                
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
    
    
    @objc func buttonTapped(_ sender: UIBarButtonItem) {
        
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            
            let dialog = UIAlertController(title: "エラー", message: "通信状態を確認してください", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            
        } else {
            
            let db = Firestore.firestore()
            
            let data: [String: Any] = ["place": place, "date": date, "icon": icon, "weather": weather, "temp": temp, "wind": wind]
            
            let doc = "\(place):\(date)"
            print(date)
            
            db.collection("weather").document(doc).setData(data) { (error) in
                
                if let error = error {
                    
                    let alertController = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    let dialog = UIAlertController(title: "保存されました", message: "", preferredStyle: .alert)
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(dialog, animated: true, completion: nil)
                    
                }
                
            }
            
        }
            
            return
            
        }
        
    }
    

extension UIView {
    
    func addBackground(name: String) {
        
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        
        let height = UIScreen.main.bounds.size.height
        
        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        
        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
        
    }
    
}
