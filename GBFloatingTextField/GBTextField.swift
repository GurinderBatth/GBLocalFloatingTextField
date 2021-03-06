//
//  GBTextField.swift
//  Post
//
//  Created by Batth on 03/10/18.
//  Copyright © 2018 Gurinder Batth. All rights reserved.
//

import UIKit

@objc protocol GBTextFieldDelegate: class
{
    @objc optional func gbLeftView(_ textField: GBTextField?)
    @objc optional func gbRightView(_ textField: GBTextField?)
}

typealias GBFloatingDelegate = GBTextFieldDelegate & UITextFieldDelegate

@IBDesignable
class GBTextField: UITextField {

//MARK:-  Public Properties
    @IBOutlet weak var gbTextFieldDelegate: GBTextFieldDelegate?
    
    @IBInspectable
    var lineHeight: CGFloat = 0{
        didSet{
            setupLine()
        }
    }
    
    @IBInspectable
    var selectedLineHeight: CGFloat = 0{
        didSet{
            if selectedLineHeight == 0{
                selectedLineHeight = lineHeight
            }
        }
    }
    
    @IBInspectable
    var titleLabelColor: UIColor = .darkGray
    
    @IBInspectable
    var lineColor: UIColor = .darkGray{
        didSet{
            self.viewLine.backgroundColor = lineColor
        }
    }
    
    @IBInspectable
    var selectedTitleColor: UIColor = .blue
    
    @IBInspectable
    var selectedLineColor: UIColor = .blue
    
    @IBInspectable
    var errorColor: UIColor = .red{
        didSet{
            self.labelError.textColor = errorColor
        }
    }
    
    @IBInspectable
    var rightImage: UIImage?{
        didSet{
            viewRight = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            if rightImageClicable{
                viewRight!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightViewSelected(_:))))
            }
            let imageView = UIImageView(image: rightImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            viewRight?.addSubview(imageView)
            
            imageView.topAnchor.constraint(equalTo: viewRight!.topAnchor, constant: 7).isActive = true
            imageView.leftAnchor.constraint(equalTo: viewRight!.leftAnchor, constant: 7).isActive = true
            imageView.bottomAnchor.constraint(equalTo: viewRight!.bottomAnchor, constant: -7).isActive = true
            imageView.rightAnchor.constraint(equalTo: viewRight!.rightAnchor, constant: -7).isActive = true
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            self.rightView = viewRight
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable
    var leftImage: UIImage?{
        didSet{
            viewLeft = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            if leftImageClicable{
                if viewLeft != nil{
                    viewLeft?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftViewSelected(_:))))
                }
            }
            let imageView = UIImageView(image: leftImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            viewLeft?.addSubview(imageView)
            
            imageView.topAnchor.constraint(equalTo: viewLeft!.topAnchor, constant: 7).isActive = true
            imageView.leftAnchor.constraint(equalTo: viewLeft!.leftAnchor, constant: 7).isActive = true
            imageView.bottomAnchor.constraint(equalTo: viewLeft!.bottomAnchor, constant: -7).isActive = true
            imageView.rightAnchor.constraint(equalTo: viewLeft!.rightAnchor, constant: -7).isActive = true
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            self.leftView = viewLeft
            self.leftViewMode = .always
        }
    }
    
    var rightImageClicable: Bool = false{
        didSet{
            if rightImageClicable{
                viewRight?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightViewSelected(_:))))
            }
        }
    }
    
    var leftImageClicable: Bool = false{
        didSet{
            if leftImageClicable{
                viewLeft?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftViewSelected(_:))))
            }
        }
    }
    
//MARK:-  Public Function
    
//MARK:-  Private Properties
    private var viewRight: UIView?
    private var viewLeft: UIView?

    private lazy var viewLine:UIView = {
        let prntView = UIView()
        prntView.translatesAutoresizingMaskIntoConstraints = false
        return prntView
    }()
    
    private lazy var labelPlaceholder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = self.placeholder
        lbl.textColor = .clear
        lbl.font = self.font
        return lbl
    }()
    
    private lazy var labelError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = self.font
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    private var constraintFloatingLabelTop: NSLayoutConstraint!
    private var constraintFloatingLabelLeft: NSLayoutConstraint!
    private var constraintFloatingLabelHeight: NSLayoutConstraint!
    private var constraintLineHeight: NSLayoutConstraint?
    
    private var showError: Bool = false{
        didSet{
            if showError{
                self.setupError()
            }else{
                if isEditing{
                    self.viewLine.backgroundColor = selectedLineColor
                    self.labelPlaceholder.textColor = selectedTitleColor
                }else{
                    self.viewLine.backgroundColor = lineColor
                    self.labelPlaceholder.textColor = titleLabelColor
                }
                self.labelError.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addViews()
    }
    
    func showErrorMessage(_ error: String){
        if error.count > 0{
            self.showError = true
            self.setupError()
            print(labelError)
            self.labelError.isHidden = false
            labelError.textColor = errorColor
            labelError.text = error
            viewLine.backgroundColor = errorColor
            if let text = text{
                if text.count > 0{
                    labelPlaceholder.textColor = errorColor
                }
            }
        }else{
            self.showError = false
            self.labelError.isHidden = true
        }
    }
    
//MARK:-  Private Functions
    
    @objc func rightViewSelected(_ gesture: UITapGestureRecognizer){
        let textField = gesture.view?.superview as? GBTextField
        if self.gbTextFieldDelegate?.gbRightView?(textField) != nil{
            self.gbTextFieldDelegate?.gbRightView!(textField)
        }else{
            self.showErrorMessage("Please implement right GBFloatingTextField Delegate")
        }
    }
    
    @objc func leftViewSelected(_ gesture: UITapGestureRecognizer){
        let textField = gesture.view?.superview as? GBTextField
        if self.gbTextFieldDelegate?.gbLeftView?(textField) != nil{
            self.gbTextFieldDelegate?.gbLeftView!(textField)
        }else{
            self.showErrorMessage("Please implement left GBFloatingTextField Delegate")
            //print("NIL")
        }
    }
    
    private func addViews(){
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        for subView in self.subviews{
            if subView == labelPlaceholder{
                return
            }
        }
        addSubview(labelPlaceholder)
        labelPlaceholder.text = placeholder
        self.constraintFloatingLabelTop = self.labelPlaceholder.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        self.constraintFloatingLabelTop.isActive = true
        self.constraintFloatingLabelLeft = self.labelPlaceholder.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        self.constraintFloatingLabelLeft.isActive = true
        self.constraintFloatingLabelHeight = self.labelPlaceholder.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        self.constraintFloatingLabelHeight.isActive = true
    }
    
    private func setupLine(){
        if lineHeight != 0{
            for subview in self.subviews{
                if subview == self.viewLine{
                    return
                }
            }
            addSubview(self.viewLine)
            viewLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            viewLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            viewLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            constraintLineHeight = viewLine.heightAnchor.constraint(equalToConstant: lineHeight)
            constraintLineHeight?.isActive = true
        }
    }
    
    private func setupError(){
        for subview in self.subviews{
            if subview == self.labelError{
                return
            }
        }
        addSubview(self.labelError)
        labelError.topAnchor.constraint(equalTo: self.viewLine.bottomAnchor, constant: 0).isActive = true
        labelError.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        labelError.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        labelError.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override internal func becomeFirstResponder() -> Bool {
        self.labelPlaceholder.text = placeholder
        if selectedLineHeight == 0{
            constraintLineHeight?.constant = lineHeight
        }else{
            constraintLineHeight?.constant = selectedLineHeight
        }
        self.viewLine.backgroundColor = selectedLineColor
        if let count = self.text?.count{
            if count > 0{
                self.labelPlaceholder.textColor = selectedTitleColor
                if showError{
                    viewLine.backgroundColor = errorColor
                    labelPlaceholder.textColor = errorColor
                }
            }
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        constraintLineHeight?.constant = lineHeight
        self.viewLine.backgroundColor = lineColor
        if let count = self.text?.count{
            if count > 0{
                self.labelPlaceholder.textColor = titleLabelColor
            }else{
                self.labelPlaceholder.textColor = .clear
            }
            if showError{
                viewLine.backgroundColor = errorColor
                labelPlaceholder.textColor = errorColor
            }
        }else{
            self.labelPlaceholder.textColor = .clear
        }
        return super.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField:UITextField){
        if let text = self.text{
            if text.count > 0{
                if self.showError != false{
                    self.showError = false
                    self.labelPlaceholder.textColor = self.selectedTitleColor
                    self.viewLine.backgroundColor = self.selectedLineColor
                }
                if self.constraintFloatingLabelTop.constant != -15{
                    self.constraintFloatingLabelHeight.isActive = false
                    self.constraintFloatingLabelTop.constant = -15
                    self.labelPlaceholder.font = UIFont.boldSystemFont(ofSize: 12)
                    UIView.transition(with: self.labelPlaceholder, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.layoutIfNeeded()
                        self.labelPlaceholder.textColor = self.selectedTitleColor
                    }) { (completed) in
                        
                    }
                }
            }else{
                self.constraintFloatingLabelHeight.isActive = false
                self.constraintFloatingLabelHeight = self.labelPlaceholder.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
                self.constraintFloatingLabelHeight.isActive = true
                self.constraintFloatingLabelTop.constant = 20
                UIView.transition(with: self.labelPlaceholder, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.layoutIfNeeded()
                    self.labelPlaceholder.font = self.font
                    self.labelPlaceholder.textColor = .clear
                }) { (completed) in
                    
                }
            }
        }
    }
}
