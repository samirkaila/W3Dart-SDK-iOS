//
//  API.swift
//  APISwipeDemo
//
//  Created by Mac on 04/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

typealias failureBlock = (String) -> Void
typealias successBlock = ([String:Any]) -> Void
class API {
    static let shared = API()
    func callAPI(endPoint: String, vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock)
    {
        WebRequest.shared.request(endPoint:endPoint,parameters: param) { (result) in
            print(result)
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess
            {
                success(responce.dic!)
            }
            else
            {
                failer?(responce.message!)
            }
        }
    }
    
    func callAPIHeader(endPoint: String, vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock)
    {
        WebRequest.shared.requestWithToken(endPoint:endPoint,parameters: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess
            {
                success(responce.dic!)
            }
            else
            {
                failer?(responce.message!)
            }
        }
    }
    
    func getCallAPI(endPoint: String, vc:UIViewController,failer:failureBlock? = nil, success:@escaping successBlock){
        WebRequest.shared.requestGet(endPoint: endPoint) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess
            {
                success(responce.dic!)
            }
            else
            {
                failer?(responce.message!)
            }
        }
    }
    
    func getCallAPIHeader(endPoint: String, vc:UIViewController,failer:failureBlock? = nil, success:@escaping successBlock){
        WebRequest.shared.requestGetWithToken(endPoint: endPoint) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess
            {
                success(responce.dic!)
            }
            else
            {
                failer?(responce.message!)
            }
        }
    }
    
    func uploadImage(endPoint:String, vc:UIViewController, param: dictionary, image:UIImage, imageName:String, paramName:String, failer:failureBlock? = nil, success:@escaping successBlock){
        WebRequest.shared.requestsWithImage(url: "\(baseUrl)\(endPoint)", parameter: param, withPostImage: image, withPostImageName: imageName, withPostImageAry: [], withPostImageNameAry: [], withParamName: paramName) { result in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess
            {
                success(responce.dic!)
            }
            else
            {
                failer?(responce.message!)
            }
        }
    }
}


extension API{
    
    private func checkResponce(vc: UIViewController?, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        stoapLoader()
        //        Modal.sharedAppdelegate.stoapLoader()
        switch result {
        case .success(let val):
            print("Response val: \(val)")
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else { //server side respose false
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                if let vc = vc{
                    stoapLoader()
                    vc.alert(title: "Error", message: message)
//                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
                return (isSuccess: false, dic: nil, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
                if let vc = vc{
                    vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
                        if flag == 1{ //Settings
//                            vc.open(scheme:UIApplication.openSettingsURLString)
                        }
                        else{ //== 0 Cancel
                        }
                    })
//                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
            }else{
                if let vc = vc{
                    vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
                        if flag == 1{ //Settings
//                            vc.open(scheme:UIApplication.openSettingsURLString)
                        }
                        else{ //== 0 Cancel
                        }
                    })
//                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
            }
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
}
