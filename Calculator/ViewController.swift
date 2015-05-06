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
    var computed = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if computed {
            let range = advance(history.text!.endIndex, -2)..<history.text!.endIndex
            var currentHistory = history.text!
            currentHistory.removeRange(range)
            history.text = currentHistory
            computed = false
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber = true
            display.text = digit
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
        computed = false
        display.text = "0"
        history.text = ""
        brain.clearStack()
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if count(display.text!) >= 2 {
                display.text = dropLast(display.text!)
            } else {
                display.text = "0"
            }
        }
    }
    
    
    @IBAction func plusMinus(sender: UIButton) {
        if computed {
            let range = advance(history.text!.endIndex, -2)..<history.text!.endIndex
            var currentHistory = history.text!
            currentHistory.removeRange(range)
            history.text = currentHistory
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = "\(-1.0 * displayValue)"
        } else {
            let operation = sender.currentTitle!
            history.text = history.text! +  " \(operation)"
            
            if let operation = sender.currentTitle {
                if let result = brain.performOperation(operation) {
                    displayValue = result
                } else {
                    displayValue = 0
                }
            }
        }
    }
    
    
    @IBAction func point() {
        if !userIsInTheMiddleOfTypingANumber{
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = true
        }
        if decimalPointNotUsed {
            display.text = display.text! + "."
            decimalPointNotUsed = false
        }

    }
    
    @IBAction func pi() {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if computed {
            let range = advance(history.text!.endIndex, -2)..<history.text!.endIndex
            var currentHistory = history.text!
            currentHistory.removeRange(range)
            history.text = currentHistory
        }
        display.text = "\(M_PI)"
        history.text = history.text! + " π"
        userIsInTheMiddleOfTypingANumber = false
        computed = false
        decimalPointNotUsed = true
        brain.pushOperand(M_PI)
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        let operation = sender.currentTitle!
        if computed {
            let range = advance(history.text!.endIndex, -2)..<history.text!.endIndex
            var currentHistory = history.text!
            currentHistory.removeRange(range)
            history.text = currentHistory
        }
        history.text = history.text! +  " \(operation) ="
        computed = true
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
        history.text = history.text! + " " + display.text!
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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

