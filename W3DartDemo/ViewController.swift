//
//  ViewController.swift
//  W3DartDemo
//
//  Created by w3nuts on 27/01/22.
//

import UIKit
import W3DartFramework
var sharedAppdelegate:AppDelegate
{
    get
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Validator.sayHallo(window:sharedAppdelegate.window!, vc: self)
//        self.becomeFirstResponder()
    }
//    override var canBecomeFirstResponder: Bool {
//        get {
//            return true
//        }
//    }
//
//    // Enable detection of shake motion
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            print("Why are you shaking me?")
//        }
//    }
    @IBAction func onClickNext(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "secondVC") as! secondVC
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

