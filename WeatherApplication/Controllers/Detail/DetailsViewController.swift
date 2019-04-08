//
//  DetailsViewController.swift
//  WeatherApplication
//
//  Created by Mac on 07/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeatherCondition: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    
    @IBOutlet weak var lblCloudPer: UILabel!
    var weatherData : Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar(navBar: (self.navigationController?.navigationBar)!)
         

        self.title = "Details"
        
        setUpData()
      
    }

    //Set data to view
    func setUpData(){
        
        let city = UserDefaults.standard.value(forKey: CITY) as! String
        lblCity.text = city
        lblDate.text = convertInDayAndDate(date : weatherData.date)
        lblTime.text = convertInTime(date : weatherData.date)
        lblWeatherCondition.text = weatherData.weatherStatus
        let tempInFloat = Float(weatherData.temp)
        let tempInInt = Int(tempInFloat!)
        lblTemp.text = String(describing: tempInInt)
        lblMaxTemp.text = weatherData.maxTemp + "℃"
        lblMinTemp.text = weatherData.minTemp + "℃"
        lblHumidity.text = weatherData.humidity + "%"
        lblSpeed.text = weatherData.windSpeed + "km/h"
        lblCloudPer.text = weatherData.cloudPercentage + "%"
        imgView.image = UIImage(named: weatherData.icon)
        
    }

}
