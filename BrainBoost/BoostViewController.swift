//
//  BoostViewController.swift
//  BrainBoost
//
//  Created by Rithvik Saravanan on 9/18/21.
//

import UIKit
import CoreData

class BoostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var operand1: UILabel!
    @IBOutlet weak var operand2: UILabel!
    @IBOutlet weak var operatorSign: UIImageView!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedOperator: String?
    var timer: Timer?
    var expectedResult: Int?
    
    let returnToHomeSegueIdentifier = "returnToHomeSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultField.delegate = self
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        self.timeRemaining.layer.borderWidth = 3
        self.timeRemaining.layer.cornerRadius = 25
        self.timeRemaining.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        self.timeRemaining.layer.borderColor = CGColor.init(red: 240 / 255, green: 130 / 255, blue: 150 / 255, alpha: 1)
        
        self.updateOperands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentScore.text = String(0)
        self.timeRemaining.text = String(60)
        self.operatorSign.image = UIImage(systemName: self.selectedOperator!)
    }
    
    @objc func updateTimer() {
        if (Int(self.timeRemaining.text!) == 0) {
            self.timer!.invalidate()
            
            let alert = UIAlertController(title: "Your time's up!", message: "Great job! Your score is \(self.currentScore.text!). Can you boost it more?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self]
                _ in
                
                // update the max score for the current operator
                switch self.selectedOperator {
                case "plus":
                    scores[0] = max(scores[0], Int(self.currentScore.text!)!)
                case "minus":
                    scores[1] = max(scores[1], Int(self.currentScore.text!)!)
                case "multiply":
                    scores[2] = max(scores[2], Int(self.currentScore.text!)!)
                case "divide":
                    scores[3] = max(scores[3], Int(self.currentScore.text!)!)
                default:
                    break
                }
                
                self.performSegue(withIdentifier: returnToHomeSegueIdentifier, sender: self)
            }))

            self.present(alert, animated: true)
        } else {
            // decrement timer every second
            self.timeRemaining.text = String(Int(self.timeRemaining.text!)! - 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
            // update score and operands if answer is correct
//            if ((Int(textField.text! + string)!) == self.expectedResult) {
//                self.currentScore.text = String(Int(self.currentScore.text!)! + 1)
//                updateOperands()
//            }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // update score and operands if answer is correct
        if let result = Int(self.resultField.text!),
           result == self.expectedResult {
            self.currentScore.text = String(Int(self.currentScore.text!)! + 1)
            updateOperands()
        }
        
        self.resultField.text = ""
    }
    
    func updateOperands() {
        if (selectedOperator == "plus") {
            self.operand1.text = String(Int.random(in: 0...99))
            self.operand2.text = String(Int.random(in: 0...99))
        } else if (selectedOperator == "minus") {
            // ensure that answers are non-negative
            let op1 = Int.random(in: 0...99)
            self.operand1.text = String(op1)
            self.operand2.text = String(Int.random(in: 0...op1))
        } else if (selectedOperator == "multiply") {
            self.operand1.text = String(Int.random(in: 0...99))
            self.operand2.text = String(Int.random(in: 0...99))
        } else if (selectedOperator == "divide") {
            // ensure that answers are whole numbers
            let op1 = Int.random(in: 1...99)
            let factors = calculateFactors(n: op1)
            self.operand1.text = String(op1)
            self.operand2.text = String(factors[Int.random(in: 0..<factors.count)])
        }
        
        // store expected result for given operands
        self.expectedResult = Int(self.operand1.text!)
        
        // apply appropriate operation
        switch self.selectedOperator {
        case "plus":
            self.expectedResult! += Int(self.operand2.text!)!
        case "minus":
            self.expectedResult! -= Int(self.operand2.text!)!
        case "multiply":
            self.expectedResult! *= Int(self.operand2.text!)!
        case "divide":
            self.expectedResult! /= Int(self.operand2.text!)!
        default:
            break
        }
    }
    
    func calculateFactors(n: Int) -> [Int] {
        var result: [Int] = []
        for i in 1...n {
            guard n % i == 0  else {continue}
            result.append(i)
        }
        print("FACTORS:", result)
        return result
    }

}
