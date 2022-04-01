//
//  WebRequest.swift
//  APISwipeDemo
//
//  Created by Mac on 04/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WebRequest {
    static let shared = WebRequest()
//    static var sharedAppdelegate:AppDelegate
//    {
//        get
//        {
//            return UIApplication.shared.delegate as! AppDelegate
//        }
//    }
    
    func request(endPoint: String,parameters:dictionary = [:], isLoader:Bool = true, completion:@escaping(Result<Any>)->Void) {
        if isLoader
        {
            startLoader()
        }
        print("************************")
        print("URL:- \(baseUrl)\(endPoint)")
        print("Param")
        for i in parameters{
            print("\(i.key):\(i.value)")
        }
        print("************************")
        
        if parameters.isEmpty {
            Alamofire.request("\(baseUrl)\(endPoint)").validate(statusCode: 200..<500).responseJSON { (resp) in
                switch resp.result{
                case .success(let value):
                    print(value)
                    completion(Result.success(value))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }else{
            Alamofire.request("\(baseUrl)\(endPoint)", method: .post, parameters: parameters).validate(statusCode: 200..<600).responseJSON { (resp) in
                print(resp)
                switch resp.result{
                case .success(let value):
                    print(value)
                    completion(Result.success(value))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    func requestWithToken(endPoint: String,parameters:dictionary = [:], isLoader:Bool = true, completion:@escaping(Result<Any>)->Void) {
        if isLoader
        {
            startLoader()
        }
        print("************************")
        print("URL:- \(baseUrl)\(endPoint)")
        print("Param")
        for i in parameters{
            print("\(i.key):\(i.value)")
        }
        print("************************")
        var objRequest: URLRequest = URLRequest(url: URL(string: "\(baseUrl)\(endPoint)")!)
        objRequest.httpMethod = Alamofire.HTTPMethod.post.rawValue
        if(parameters.count > 0) {
            objRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        objRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        objRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        objRequest.setValue("Bearer \(UserData.shared.getToken())", forHTTPHeaderField: "Authorization")
        Alamofire.request(objRequest).validate(statusCode: 200..<500).responseJSON { resp in
            switch resp.result{
            case .success(let value):
                print(value)
                completion(Result.success(value))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func requestGet(base: String = baseUrl, endPoint: String, headers:dictionary = [:], completion: @escaping (Result<Any>)->Void){
        startLoader()
        print("************************")
        print("URL:- \(base)\(endPoint)")
        print("Param")
        for i in headers{
            print("\(i.key):\(i.value)")
        }
        print("************************")
        
        Alamofire.request("\(base)\(endPoint)", method: .get, parameters: headers).validate(statusCode: 200..<500).responseJSON { (resp) in
            switch resp.result{
            case .success(let value):
                print(value)
                completion(Result.success(value))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func requestGetWithToken(base: String = baseUrl, endPoint: String, headers:dictionary = [:], completion: @escaping (Result<Any>)->Void) {
        startLoader()
        print("************************")
        print("URL:- \(baseUrl)\(endPoint)")
        print("Param")
        //        for i in parameters{
        //            print("\(i.key):\(i.value)")
        //        }
        print("************************")
        //        let headers: HTTPHeaders = [
        //            "Authorization": "Bearer: \(token)",
        //            "Accept": "application/json"]
        //        let token = "xqvvib8hkn1r9398axfj23v8tyjnspvb"
        var objRequest: URLRequest = URLRequest(url: URL(string: "\(baseUrl)\(endPoint)")!)
        objRequest.httpMethod = Alamofire.HTTPMethod.get.rawValue
        //        if(parameters.count > 0) {
        //            objRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        //        }
        objRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        objRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        objRequest.setValue("Bearer \(UserData.shared.getToken())", forHTTPHeaderField: "Authorization")
        Alamofire.request(objRequest).validate(statusCode: 200..<500).responseJSON { resp in
            switch resp.result{
            case .success(let value):
                print(value)
                completion(Result.success(value))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    var dataRequest: DataRequest!
    
    func requestsWithImage(url:String, parameter:dictionary = dictionary(), withPostImage postImg:UIImage?, withPostImageName imgName:String?, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), withParamName:String, completion:@escaping(Result<Any>)->Void){
        startLoader()
        var imgNm = "image.jpeg"
        if imgName != nil{
            imgNm = imgName!
        }
        print("**********************")
        print("URL: \(url)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept":"application/json",
//            "Authorization":"Bearer \(UserData.shared.getToken())"
        ]
        print("**********************")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let postImg = postImg{
                    //Single image upload
                    let imgData:Data = WebRequest.getDataFromImage(imageName: imgNm, postImage: postImg)
                    multipartFormData.append(imgData,
                                             withName: withParamName, fileName: imgNm,
                                             mimeType: WebRequest.getMimeType(imageName: imgNm))
                    print("[\(withParamName)]: \(imgNm) => \(String(describing: postImg))")
                    print("**********************")
                }
                else if postImgsAry.count > 0{
                    //Multiple image upload
                    for (i,img) in postImgsAry.enumerated() {
                        multipartFormData.append(WebRequest.getDataFromImage(imageName: imgNameAry[i], postImage: img), withName: "\(withParamName)[\(i)]", fileName: imgNameAry[i], mimeType: WebRequest.getMimeType(imageName: imgNameAry[i]))
                        print("\(withParamName)[\(i)]: \(imgNameAry[i]) => \(String(describing: img))")
                    }
                    print("**********************")
                }
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                //add ertra arguments
                //This is only use for editProfile API
                if let str = parameter["avl_dat"] as? String{
                    let strAry = str.components(separatedBy: ",")
                    for value in strAry{
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "avl_dat[]")
                    }
                }
            },
            usingThreshold: UInt64.init(),//this new line added
            to: url, method: .post, headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print(“Respones: \(value)“)
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
            })
    }
    
    func requestsSendImage(url:String, parameter:dictionary = dictionary(), withPostImage postImg:UIImage?, withPostImageName imgName:String?, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), withParamName:String, withParamNameAry:[String] = [String](), completion:@escaping(Result<Any>)->Void){
        var imgNm = "image.jpeg"
        if imgName != nil{
            imgNm = imgName!
        }
        print("**********************")
        print("URL: \(url)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let postImg = postImg{
                    //Single image upload
                    let imgData:Data = WebRequest.getDataFromImage(imageName: imgNm, postImage: postImg)
                    multipartFormData.append(imgData,
                                             withName: withParamName, fileName: imgNm,
                                             mimeType: WebRequest.getMimeType(imageName: imgNm))
                    print("[\(withParamName)]: \(imgNm) => \(String(describing: postImg))")
                    print("**********************")
                }
                else if postImgsAry.count > 0{
                    //Multiple image upload
                    for (i,img) in postImgsAry.enumerated() {
                        multipartFormData.append(WebRequest.getDataFromImage(imageName: imgNameAry[i], postImage: img), withName: withParamNameAry[i], fileName: imgNameAry[i], mimeType: WebRequest.getMimeType(imageName: imgNameAry[i]))
                        print("\(withParamName)[\(i)]: \(imgNameAry[i]) => \(String(describing: img))")
                    }
                    print("**********************")
                }
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                //add ertra arguments
                //This is only use for editProfile API
                if let str = parameter["avl_dat"] as? String{
                    let strAry = str.components(separatedBy: ",")
                    for value in strAry{
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "avl_dat[]")
                    }
                }
            },
            usingThreshold: UInt64.init(),//this new line added
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print(“Respones: \(value)“)
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
            })
    }
    
    
    func requestsWithImages(url:String, parameter:dictionary = dictionary(), withPostImage postImg:UIImage?, withPostImageName imgName:String?, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), withParamName:[String], completion:@escaping(Result<Any>)->Void){
        var imgNm = "image.jpeg"
        if imgName != nil{
            imgNm = imgName!
        }
        print("**********************")
        print("URL: \(url)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let postImg = postImg{
                    //Single image upload
                    let imgData:Data = WebRequest.getDataFromImage(imageName: imgNm, postImage: postImg)
                    multipartFormData.append(imgData,
                                             withName: withParamName.first!, fileName: imgNm,
                                             mimeType: WebRequest.getMimeType(imageName: imgNm))
                    print("[\(withParamName)]: \(imgNm) => \(String(describing: postImg))")
                    print("**********************")
                }
                else if postImgsAry.count > 0{
                    //Multiple image upload
                    for (i,img) in postImgsAry.enumerated() {
                        multipartFormData.append(WebRequest.getDataFromImage(imageName: imgNameAry[i], postImage: img), withName: "\(withParamName[i])", fileName: imgNameAry[i], mimeType: WebRequest.getMimeType(imageName: imgNameAry[i]))
                        print("\(withParamName[i]): \(imgNameAry[i]) => \(String(describing: img))")
                    }
                    print("**********************")
                }
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                //add ertra arguments
                //This is only use for editProfile API
                if let str = parameter["avl_dat"] as? String{
                    let strAry = str.components(separatedBy: ",")
                    for value in strAry{
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "avl_dat[]")
                    }
                }
            },
            usingThreshold: UInt64.init(),//this new line added
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print(“Respones: \(value)“)
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
            })
    }
    
    func imageAPI(url: String,completion: @escaping ((UIImage?, String?) -> ()))  {
        Alamofire.request(url).responseImage { (resp) in
            switch resp.result{
                
            case .success(let data):
                print(data)
                completion(data,nil)
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil,err.localizedDescription)
            }
        }
    }
}

extension WebRequest
{
    func cancelAllReuest()
    {
        //https://stackoverflow.com/questions/41478122/cancel-a-request-alamofire
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    func cancelCurrentRequest()
    {
        dataRequest.cancel()
    }
    fileprivate static func getDataFromImage(imageName imgNm: String, postImage img:UIImage) -> Data
    {
        if (imgNm.fileExtensionOnly().localizedStandardContains("png"))
        {
            
            return img.pngData()!
        }
        else
        {
            return img.jpegData(compressionQuality: 0.2) ?? Data()//UIImageJPEGRepresentation(img, 1.0)!
        }
    }
    fileprivate static func getMimeType(imageName imgNm:String ) -> String{
        return (WebRequest.acceptableImageContentTypes.contains("image/\(imgNm.fileExtensionOnly())")
                ? "image/\(imgNm.fileExtensionOnly())" : "")
    }
    private static var acceptableImageContentTypes: Set<String> = [
        "image/tiff",
        "image/jpeg",
        "image/jpg",
        "image/gif",
        "image/png",
        "image/ico",
        "image/x-icon",
        "image/bmp",
        "image/x-bmp",
        "image/x-xbitmap",
        "image/x-ms-bmp",
        "image/x-win-bitmap"
    ]
}

extension String{
    func fileExtensionOnly() -> String {
        let fileExtension = URL(fileURLWithPath: self).pathExtension
        if !fileExtension.isEmpty{
            return fileExtension
        } else {
            return ""
        }
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
    func fileNameWithExtension() -> String {
        let fileNameWithoutExtension = URL(fileURLWithPath: self).lastPathComponent
        if !fileNameWithoutExtension.isEmpty {
            return fileNameWithoutExtension
        } else {
            return ""
        }
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).lastPathComponent {
            return fileNameWithoutExtension
        } else {
            return ""
        }
    }
}

extension WebRequest{
    
    func requestsWithAttachments(url:String,
                                 method:HTTPMethod = .post,
                                 timeInterval interval: TimeInterval = 60,
                                 parameter:dictionary = dictionary(),
                                 uploadImage:UploadImageData? = nil,
                                 uploadImages:[UploadImageData]? = nil,
                                 uploadFile:UploadFileData? = nil,
                                 uploadFiles:[UploadFileData]? = nil,
                                 isLoader:Bool = true,
                                 isRapidCall:Bool = false,
                                 isRetry:Bool = true,
                                 uploadProgress: @escaping((Progress)->()),
                                 completion:@escaping(Result<Any>)->Void)
    {
        
        func rapidCall(){
            requestsWithAttachments(url: url,
                                    method: method,
                                    timeInterval: interval,
                                    parameter: parameter,
                                    uploadImage: uploadImage,
                                    uploadImages: uploadImages,
                                    uploadFile: uploadFile,
                                    uploadFiles: uploadFiles,
                                    isLoader: isLoader,
                                    isRapidCall: isRapidCall,
                                    isRetry: isRetry,
                                    uploadProgress: uploadProgress,
                                    completion: completion)
        }
        
        
        //For loader
        //            if isLoader {
        //                DispatchQueue.main.async {
        //                    API.sharedAppdelegate.startLoader(isDisableUI: isLoader)
        //                }
        //            }
        // for log param in console
        self.printSendData(url: url, param: parameter)
        let manager = SessionManager.getConfigureManager(withTimeInterval: interval)//default 60
        manager.upload(multipartFormData: { (multipartFormData) in
            
            //            upload single Image
            if let uploadImage = uploadImage{
                let imgData = WebRequest.getDataFromImage(imageName: uploadImage.name, postImage: uploadImage.img)
                let mimeType = WebRequest.getMimeType(imageName: uploadImage.name)
                multipartFormData.append(imgData, withName: uploadImage.paramName, fileName: uploadImage.name, mimeType:mimeType)
            }
            // upload multiple images
            if let uploadImages = uploadImages{
                
                for (uploadImage) in uploadImages{
                    let imgData = WebRequest.getDataFromImage(imageName: uploadImage.name, postImage: uploadImage.img)
                    let mimeType = WebRequest.getMimeType(imageName: uploadImage.name)
                    multipartFormData.append(imgData, withName: uploadImage.paramName, fileName: uploadImage.name, mimeType:mimeType)
                }
            }
            
            //            upload single file
            if let uploadFile = uploadFile{
                multipartFormData.append(uploadFile.file, withName: uploadFile.paramName, fileName: uploadFile.name, mimeType: uploadFile.mimeType ?? "")
            }
            //             upload multiple files
            if let uploadFiles = uploadFiles{
                for uploadFile in uploadFiles{
                    multipartFormData.append(uploadFile.file, withName: uploadFile.paramName, fileName: uploadFile.name, mimeType: uploadFile.mimeType ?? "")
                }
            }
            
            for (key,value) in parameter{
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        },
                       usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, //UInt64.init(),//this new line added
                       to: url,
                       method: method,
                       encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    uploadProgress(progress)
                    print("Uploaded \(progress.fractionCompleted.roundToDecimal(2))%")
                }
                upload.responseJSON { response in
                    switch response.result{
                    case .success(let value):
                        print("Respones: \(value)")
                        //                                self.timeOutCounter = 0
                        completion(Result.success(value))
                    case.failure(let error):
                        print("ResponesError: \(error)")
                        completion(Result.failure(error))
                    }
                }
                break
            case .failure(let error):
                //Uploading time error
                self.manageFailure(error: error, isRapidCall: isRapidCall, isRetry: isRetry, rapidCall: rapidCall, completion: completion)
                break
            }
        })
    }
    
    private func manageFailure(error:Error, isLoader:Bool = true, isRapidCall:Bool, isRetry:Bool, rapidCall: @escaping ()->Void, completion:@escaping(Result<Any>)->Void) {
        if isRapidCall{
            if error.code == NSURLErrorNotConnectedToInternet {
                //                    self.timeOutCounter = 0
                completion(Result.failure(error))
                return
            }else if (error.code == NSURLErrorCancelled || error.code == NSURLErrorNetworkConnectionLost){
                print("NSURLErrorCancelled || NSURLErrorNetworkConnectionLost")
                //rapidCall()
                completion(Result.failure(error))
                return
            }else if error.code == NSURLErrorTimedOut {
                print("NSURLErrorTimedOut")
                //                    if self.timeOutCounter < 2{
                //                        self.timeOutCounter = self.timeOutCounter + 1
                //                        rapidCall()
                //                    }else{
                //API.sharedAppdelegate.stoapLoader()
                //                        self.timeOutCounter = 0
                if isRetry{
                    //                            UIApplication.alert(title: "", message: error.localizedDescription, actions: ["Retry".localized, "Cancel".localized], style: [.default, .cancel], completion: { (flag) in
                    //                                if flag == 0{ //Retry
                    //                                    rapidCall()
                    //                                }else{ //Cancel
                    //                                    print("Cancel request")
                    //                                }
                    //                            })
                }
                //                    }
                return
            }
        }
        //            self.timeOutCounter = 0
        completion(Result.failure(error))
    }
    
    
    struct UploadImageData {
        var paramName:String
        var name:String
        var img:UIImage
    }
    
    struct UploadFileData {
        var paramName:String
        var name:String
        var file:Data
        var mimeType:String?
    }
    
    private func printSendData(url:String, param parameter:dictionary){
        print("\n********")
        print("URL: \(url)")
        print("Parameters:\n")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("********\n")
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension SessionManager{
    static func getConfigureManager(withTimeInterval interval: TimeInterval) -> SessionManager {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = interval //default 60
        return manager
    }
}

