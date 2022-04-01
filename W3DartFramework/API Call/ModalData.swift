//
//  ModalData.swift
//  Resourse Tracker
//
//  Created by w3nuts on 15/06/21.
//

import UIKit

class User{
    var name:String
    var email:String
    var gender:String
    var dob:String
    var id:Int
    var token:String
    var weight:String
    var height:String
    var measurement_unit:String
    var is_data_shareable:String
    var is_active:String
    //    var email_verified_at:String
    var avatar:String
    var bmi:Double
    var bmi_category:String
    var in_app_purchase:Int
    var remaining_days:Int
    
    init(data:dictionary) {
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.gender = data["gender"] as? String ?? ""
        self.dob = data["dob"] as? String ?? ""
        self.id = data["id"] as? Int ?? 0
        self.token = data["token"] as? String ?? ""
        self.weight = data["weight"] as? String ?? ""
        self.height = data["height"] as? String ?? ""
        self.measurement_unit = data["measurement_unit"] as? String ?? "Centimeter"
        self.is_data_shareable = data["is_data_shareable"] as? String ?? ""
        self.is_active = data["is_active"] as? String ?? ""
        //        self.email_verified_at = data["email_verified_at"] as? String ?? ""
        self.avatar = data["avatar"] as? String ?? ""
        self.bmi = data["bmi"] as? Double ?? 0.0
        self.bmi_category = data["bmi_category"] as? String ?? ""
        self.in_app_purchase = data["in_app_purchase"] as? Int ?? 0
        self.remaining_days = data["remaining_days"] as? Int ?? 0
    }
}

