//
//  ViewController.swift
//  GBFloatingTextField
//
//  Created by Apple on 04/10/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit

class ViewController: UIViewController , GBTextFieldDelegate {
    var textField: GBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField = GBTextField(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width - 20, height: 40))
        textField.borderStyle = .roundedRect
        textField.lineHeight = 1
        textField.selectedLineHeight = 3
        textField.placeholder = "Test"
        textField.gbTextFieldDelegate = self
        textField.leftImage = UIImage(named: "arrow")
        textField.leftImageClicable = true
        self.view.addSubview(textField)
    }
    
    @IBAction func btnCheck(_ sender: Any?){
        self.textField.showErrorMessage("fghfgh")
    }
    
    @IBAction func btnOK(_ sender: Any?){
        self.textField.showErrorMessage("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gbLeftView(_ textField: GBTextField?) {
        print("Left")
    }
    func gbRightView(_ textField: GBTextField?) {
        print("Right")
    }
}
