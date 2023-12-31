//
//  ConfirmPWViewController.swift
//  Bareuni
//
//  Created by 윤지성 on 2023/07/21.
//

import UIKit

class ConfirmPWViewController: UIViewController, UITextFieldDelegate{
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        pwTextField.doViewSetting(paddingWidth: 28, cornerRadius: 12)
        anotherPWTextField.doViewSetting(paddingWidth: 28, cornerRadius: 12)

        nextBtn.layer.cornerRadius = 12
        nextBtn.changeDisabledState()
        self.setBackBtn()
        
        pwTextField.delegate = self
        anotherPWTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func nextBtnDidTap(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfServiceViewController") as? TermsOfServiceViewController
        var signUpData = SignUpRequest.init()
        signUpData.email = email
        signUpData.password = pwTextField.text!
        nextVC!.signUpData = signUpData
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var anotherPWTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var isFirstPWRight: Bool = false
    var isSecondPWRight: Bool = false
    
    
    @IBOutlet weak var firstPwWarningLb: UILabel!
    @IBOutlet weak var secondPwWarningLb: UILabel!
    
    @IBAction func firstPWDidChange(_ sender: Any) {
        isPWAllRight()
    }
    
    @IBAction func secondPWDidChange(_ sender: Any) {
        isPWAllRight()
    }
    func isPWAllRight(){
        if(pwTextField.text?.count ?? 0  < 8){
            firstPwWarningLb.text = "비밀번호는 최소 8자 이상이어야 합니다."
            firstPwWarningLb.isHidden = false
            isFirstPWRight = false
        }
        else{
            if(pwTextField.checkPW() == false){
                firstPwWarningLb.isHidden = false
                firstPwWarningLb.text = "비밀번호가 형식에 맞지 않습니다."
                isFirstPWRight = false
            }else{
                firstPwWarningLb.isHidden = true
                isFirstPWRight = true
            }
        }
        if(pwTextField.text == anotherPWTextField.text){
            secondPwWarningLb.isHidden = true
            isSecondPWRight = true
        }else{
            nextBtn.changeDisabledState()
            secondPwWarningLb.isHidden = false
            secondPwWarningLb.text = "비밀번호가 일치하지 않습니다."
        }
        if(isFirstPWRight == true && isSecondPWRight == true){
            nextBtn.changeEnabledState()
        }else{
            nextBtn.changeDisabledState()

        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
            return !(newLength > 64)
    }
    
}

extension UIButton{
    func changeDisabledState() {
        self.isEnabled = false
        self.tintColor = .white
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor(named: "disabledBtnColor")

    }
    
    func changeEnabledState() {
        self.isEnabled = true
        self.tintColor = .white
        self.backgroundColor = UIColor(named: "BackgroundBlue")
    }
}
