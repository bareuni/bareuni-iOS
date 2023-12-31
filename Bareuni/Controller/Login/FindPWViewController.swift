//
//  FindPWViewController.swift
//  Bareuni
//
//  Created by 윤지성 on 2023/07/18.
//

import UIKit

class FindPWViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainLb.numberOfLines = 2
        explainLb.text = "가입한 이메일 주소를 입력해주세요 \n비밀번호 재설정을 위한 이메일을 보내드리겠습니다 "
        findEmailTF.doViewSetting(paddingWidth: 28, cornerRadius: 12)
        self.findEmailTF.addTarget(self, action: #selector(self.textFieldDidChange(_sender:)), for: .editingChanged)
        
        confirmBtn.backgroundColor = UIColor(red: 0.821, green: 0.821, blue: 0.821, alpha: 1)
        confirmBtn.layer.cornerRadius = 12
        self.setBackBtn()
        self.hideKeyboardWhenTappedAround() 
        
    }
    

    @IBOutlet weak var explainLb: UILabel!
    @IBOutlet weak var findEmailTF: UITextField!
    @IBOutlet weak var warningLb: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @objc func textFieldDidChange(_sender: Any) {
        
        if(self.findEmailTF.text!.count == 0){
            self.confirmBtn.isEnabled = false
            self.confirmBtn.backgroundColor = UIColor(named: "disabledBtnColor")
            
        }
        else if(self.findEmailTF.checkEmailValid() == false){
            explainLb.layer.borderColor = UIColor(red: 1, green: 0.314, blue: 0.314, alpha: 1).cgColor
            
            warningLb.text = "이메일을 확인해주세요."
            warningLb.textColor = UIColor(red: 1, green: 0.314, blue: 0.314, alpha: 1)
            self.confirmBtn.isEnabled = false
            self.confirmBtn.backgroundColor = UIColor(named: "disabledBtnColor")
        }
        else{
            findEmailTF.doViewSetting(paddingWidth: 28, cornerRadius: 12)
            warningLb.text = "대소문자를 구분하여 입력해주세요."
            warningLb.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
            self.confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor(named: "BackgroundBlue")
        }
    }
    
    @IBAction func confirmBtnDidTap(_ sender: Any) {
        LoginAPI.shared.findPassword(email: self.findEmailTF.text!, completion: {
            result in
            switch result{
            case .success(let result):
                if(result.code == 1000){
                    self.navigationController?.popViewController(animated: true)
                }
                else if (result.code == 3014){
                    self.warningLb.text = "존재하지 않는 이메일입니다."
                    self.warningLb.textColor = .red
                }
            case .failure(let error):
                print("error: \(error)")
            }
        })
    }
    
    
}

extension UITextField {
    public func checkEmailValid() -> Bool {
        let str =  self.text
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    public func checkPW() -> Bool {
        // 최소 8자, 최소 하나의 문자 및 하나의 숫자
        let str =  self.text
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8,64}"
        return  NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: str)
    }
}

// 키보드 숨기기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)

    }

}
