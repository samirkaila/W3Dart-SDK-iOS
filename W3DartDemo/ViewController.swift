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
    }
    @IBAction func onClickNext(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "secondVC") as! secondVC
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

