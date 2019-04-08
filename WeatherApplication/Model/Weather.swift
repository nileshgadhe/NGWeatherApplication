//
//  Weather.swift
//  WeatherApplication
//
//  Created by Mac on 06/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
class Weather : NSObject{
    
    var temp : String
    var maxTemp : String!
    var minTemp : String!
    var windSpeed :String!
    var date : String!
    var cloudPercentage : String!
    var humidity : String!
    var weatherStatus : String!
    var icon : String!
    
    init( temp : String, maxTemp : String, minTemp : String, windSpeed : String, date : String, cloudPercentage : String, humidity : String, weatherStatus : String, icon : String){
        
        self.temp = temp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.windSpeed = windSpeed
        self.date = date
        self.cloudPercentage = cloudPercentage
        self.humidity = humidity
        self.weatherStatus = weatherStatus
        self.icon = icon
        
        
    }

}
