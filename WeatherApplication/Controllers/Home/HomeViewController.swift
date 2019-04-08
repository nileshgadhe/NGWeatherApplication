//
//  HomeViewController.swift
//  WeatherApplication
//
//  Created by Mac on 06/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import SVProgressHUD


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var lblWeatherCondition: UILabel!
    @IBOutlet weak var btnSignOut: UIButton!
    
    //Varable and constants
    var userDefault = UserDefaults.standard
    var weatherDataArray = [Weather]()
    var city = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setUpView()
        setUpTable()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpView(){
        
        tblView.layer.cornerRadius = 8
        btnSignOut.layer.cornerRadius = 5
    }
    
    func setUpTable(){
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.estimatedRowHeight = 100
        tblView.rowHeight = UITableViewAutomaticDimension
        
        tblView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
    }
    
    func loadData(){
        SVProgressHUD.show()
        city = userDefault.value(forKey: CITY) as! String
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(API_KEY)&units=metric").responseJSON{
            response in
            
            let result = response.result
            if let dictionary = result.value as? Dictionary<String,AnyObject>{
                let code = dictionary["cod"] as? String
                if code == "200"{
                    self.weatherDataArray.removeAll()
                    if let list = dictionary["list"] as? [Dictionary<String,AnyObject>]{
                        for item in list{
                            
                            let date = item["dt_txt"] as! String
                            let mainDictionary = item["main"] as? Dictionary<String,AnyObject>
                            let humidity = mainDictionary!["humidity"] as! Int
                            let temp = mainDictionary!["temp"] as! Double
                            let maxTemp = mainDictionary!["temp_max"] as! Double
                            let minTemp = mainDictionary!["temp_min"] as! Double
                            let windDic = item["wind"] as? Dictionary<String,AnyObject>
                            let windSpeed = windDic!["speed"] as! Double
                            let weatherArray = item["weather"] as! [AnyObject]
                            let weatherDic = weatherArray[0] as? Dictionary<String,AnyObject>
                            let weatherStatus = weatherDic!["main"] as! String
                            let icon = weatherDic!["icon"] as! String
                            let cloudDic = item["clouds"] as? Dictionary<String,AnyObject>
                            let cloudPer = cloudDic!["all"] as! Int
                            
                            let weatherData = Weather(temp: String(temp), maxTemp: String(maxTemp), minTemp: String(minTemp), windSpeed: String(windSpeed), date: date, cloudPercentage: String(cloudPer), humidity: String(humidity), weatherStatus: weatherStatus, icon: icon)
                            
                            self.weatherDataArray.append(weatherData)
                        }
                        
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.setData()
                        self.tblView.reloadData()
                        SVProgressHUD.dismiss()
                    })
                    
                } else{
                     SVProgressHUD.showError(withStatus: "City not found")
                }
                
            }
            
            
        }
        
    }
    
    //Set data to view
    func setData(){
        
        city = userDefault.value(forKey: CITY) as! String
        let todayWeather = weatherDataArray.first as! Weather
        lblCity.text = city
        let tempInFloat = Float(todayWeather.temp)
        let tempInInt = Int(tempInFloat!)
        lblTemprature.text = String(describing: tempInInt)
        let weatherState = todayWeather.weatherStatus
        lblWeatherCondition.text = weatherState
        imgView.image = UIImage(named: todayWeather.icon)
        
        
    }
    
    // Mark :- Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let weatherData = weatherDataArray[indexPath.row]
        cell.lblDay.text = convertInDay(date: weatherData.date)
        cell.lblDateTime.text = convertDateFormater(date: weatherData.date) + " / " + weatherData.weatherStatus
        cell.lblTemp.text = weatherData.maxTemp + " / " + weatherData.minTemp
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dvc = DetailsViewController()
        dvc.weatherData = weatherDataArray[indexPath.row]
        self.navigationController?.pushViewController(dvc, animated: true)
        
    }
    
    //Search weather for city
    @IBAction func searchAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter City Name", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Search", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            if textField.text != ""{
                
                self.city = textField.text!
                self.userDefault.set(self.city, forKey: CITY)
                self.loadData()
                
            } else{
                SVProgressHUD.showError(withStatus: "Please enter city name")
                
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "City"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Mark :- Signout
    @IBAction func signOut(_ sender: Any) {
        do{
            try GIDSignIn.sharedInstance().signOut()
            userDefault.set(false, forKey: SIGNIN)
            userDefault.synchronize()
            (UIApplication.shared.delegate as! AppDelegate).setUpSignInViewController()
        } catch{
            print("error")
        }
        
    }
    
}
