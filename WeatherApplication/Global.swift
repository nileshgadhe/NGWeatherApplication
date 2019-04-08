//
//  Global.swift
//  WeatherApplication
//
//  Created by Mac on 06/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

// Mark :- User Default keys
let SIGNIN = "signin"
let CITY = "city"

//API Keys
let API_KEY = "1764efb2acd0ca36abcda718fb6ced8f"

//Set up navigation bar
func setupNavigationBar(navBar : UINavigationBar) {
    
    navBar.barTintColor = UIColor.hexStringToUIColor(hex: "#83A8E2")
    navBar.tintColor = UIColor.white
    navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    //navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: setBoldFontWithSize(size: 17)]
    navBar.isTranslucent = false
}

//Date format converter functions
func convertDateFormater(date: String) -> String {
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let date = dateFormatter.date(from: date) else {
        
        return ""
    }
    
    dateFormatter.dateFormat = "d MMM yyyy"
    let timeStamp = dateFormatter.string(from: date)
    
    return timeStamp
}
func convertInDay(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let date = dateFormatter.date(from: date) else {
        
        return ""
    }
    
    dateFormatter.dateFormat = "EEEE / h:mm a"
    let timeStamp = dateFormatter.string(from: date)
    
    return timeStamp
}

func convertInDayAndDate(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let date = dateFormatter.date(from: date) else {
        
        return ""
    }
    
    dateFormatter.dateFormat = "EEEE, d MMM yyyy"
    let timeStamp = dateFormatter.string(from: date)
    
    return timeStamp
}

func convertInTime(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let date = dateFormatter.date(from: date) else {
        
        return ""
    }
    
    dateFormatter.dateFormat = "h:mm a"
    let timeStamp = dateFormatter.string(from: date)
    
    return timeStamp
}

//MARK- Extention for color
extension UIColor {
    
    // A UIColor class method to create colors from hex values conveniently
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

