
//
//  Calculator - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    private var userTyping = false
    private var formula = ""
    private let numberFormatter = NumberFormatter()
    
    @IBOutlet weak var displayOperandLabel: UILabel!
    @IBOutlet weak var displayOperatorLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNUmberForatter()
        clearStackView()
        clearOperandLabel()
        clearOperatorLabel()
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        
        addDisplayOperandsLabel(digit)
    }
    
    @IBAction func touchOperator(_ sender: UIButton) {
        guard let inputOperator = sender.currentTitle else { return }
        
        addFormula()
        
        displayOperatorLabel.text = inputOperator
        print(formula)
    }
    
    @IBAction func touchCalculate(_ sender: UIButton) {
        guard let operands = displayOperandLabel.text,
              let `operator` = displayOperatorLabel.text else { return }
        
        addFormula()
        
        guard let result = calculateFormula() else { return }

        if `operator` == String(Operator.divide.rawValue) && operands == "0" {
            displayOperandLabel.text = "NaN"
        } else {
            displayOperandLabel.text = result
            clearFormula()
            clearStackView()
        }
        clearOperatorLabel()
    }
    
    @IBAction func touchMenu(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "AC":
            clearOperandLabel()
            clearOperatorLabel()
            clearStackView()
        case "CE":
            clearOperandLabel()
        case "⁺⁄₋":
            changeSign()
        case ".":
            print("dotSign")
        case "00":
            print("doubleZero")
        default:
            break
        }
    }
    private func addDisplayOperandsLabel(_ input: String) {
        guard let operands = displayOperandLabel.text,
              let number = Double(operands + input),
              let result = numberFormatter.string(for: number) else { return }
        
        userTyping = false
        displayOperandLabel.text = result
    }
    
    private func addFormula() {
        guard let operands = displayOperandLabel.text?.replacingOccurrences(of: ",", with: ""),
              let `operator` = displayOperatorLabel.text else { return }
        
        if formula.isEmpty && operands != "0" {
            formula += operands
            addStackView("", operands)
        } else if operands != "0" || (`operator` == String(Operator.divide.rawValue) && operands == "0") {
            formula += " \(`operator`) \(operands)"
            addStackView(`operator`, operands)
        }
        
        clearOperandLabel()
        clearOperatorLabel()
    }

    
    private func addStackView(_ `operator`: String, _ operands: String) {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "\(`operator`) \(operands)"
        
        stackView.addArrangedSubview(label)
        
    }
    
    private func calculateFormula() -> String? {
        var parsedValue = ExpressionParser.parse(from: formula)
        
        userTyping = true

        return numberFormatter.string(for: parsedValue.result())
    }
    
    private func changeSign() {
        guard var operands = displayOperandLabel.text,
              operands != "0" else { return }
        
        if operands.contains("-") {
            operands.removeFirst()
        } else {
            operands.insert(Character("-"), at: operands.startIndex)
        }
        
        displayOperandLabel.text = operands
    }
    
    private func dotSign() {
              
    }
    
    private func doubleZero() {
        
    }
    
    private func clearOperandLabel() {
        displayOperandLabel.text = "0"
    }
    
    private func clearOperatorLabel() {
        displayOperatorLabel.text?.removeAll()
    }
    
    private func clearFormula() {
        formula.removeAll()
    }
    
    private func clearStackView() {
        stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
    }
    
    private func setNUmberForatter() {
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = -2
        numberFormatter.maximumIntegerDigits = 20
        numberFormatter.maximumSignificantDigits = 20
    }
}

