//
//  EmailAuthViewController.swift
//  Bareuni
//
//  Created by 윤지성 on 2023/07/20.
//

import UIKit

class EmailAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        authCodeTF.doViewSetting(paddingWidth: 28, cornerRadius: 12)
        nextBtn.layer.cornerRadius = 12
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTimer()
    }
    @IBOutlet weak var timerLb: UILabel!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var countDownTime: Int = 180
    var timer: Timer?
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.countDownTime = self.countDownTime - 1
            
            let minute =  self.countDownTime / 60
            let second =  self.countDownTime % 60
            self.timerLb.text = "\(minute):\(String(format: "%02d", second))"
            
            if  self.countDownTime <= 0 {
                timer.invalidate()
                DispatchQueue.main.async {
                    self.nextBtn.isEnabled = false
                    self.nextBtn.backgroundColor = UIColor(named: "disabledBtnColor")
                }
            }
        }
    }
    
    @IBAction func reSendBtnDidTap(_ sender: Any) {
        self.timerLb.text = "3:00"
        timer!.invalidate()
        countDownTime = 180
        setTimer()
    }
    
    
    

}
