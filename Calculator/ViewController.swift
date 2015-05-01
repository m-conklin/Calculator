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
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
            history.text = history.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber = true
            display.text = digit
            history.text = history.text! + " " + digit
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
        display.text = "0"
        history.text = ""
        brain.clearStack()
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
        brain.pushOperand(M_PI)
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
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
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointNotUsed = true
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

