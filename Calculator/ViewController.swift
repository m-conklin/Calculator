//
//  ViewController.swift
//  Calculator
//
//  Created by M Conklin on 2015-04-21.
//  Copyright (c) 2015 GetErDone. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var decimalPointNotUsed = true

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
            history.text = history.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
            history.text = history.text! + " " + digit
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
        display.text = "0"
        history.text = ""
        operandStack.removeAll(keepCapacity: true)
        println("operandStack = \(operandStack)")
        
    }
    
    
    @IBAction func point() {
        if !userIsInTheMiddleOfTypingANumber{
            display.text = "0"
            history.text = history.text! + " 0"
            userIsInTheMiddleOfTypingANumber = true
        }
        if decimalPointNotUsed {
            display.text = display.text! + "."
            decimalPointNotUsed = false
        }
        history.text = history.text! + "."

    }
    
    @IBAction func pi() {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        display.text = "\(M_PI)"
        history.text = history.text! + " π"
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        history.text = history.text! +  " \(operation)"
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }

        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin ɵ": performOperation { sin($0) }
        case "cos ɵ": performOperation { cos($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
   
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
//        history.text = history.text! + display.text!
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

