//
//  W3DartVC.swift
//  W3DartFramework
//
//  Created by w3nuts on 22/12/21.
//

import UIKit

class W3DartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manufactureName = self.getManufactureName(name: "APPLE")
        print("Manufacture Name = \(manufactureName)")
        let modelName = UIDevice.modelName
        print("Model Name = \(modelName)")
        print("CPU Name = \(UIDevice.current.getCPUName())")
        print("CPU Speed \(UIDevice.current.getCPUSpeed())")
    }
    func getManufactureName(name:String) -> String{
        return name
    }
}
