//
//  ViewController.swift
//  Calulator
//
//  Created by Anudeep Reddy Dwaram on 04/06/15.
//  Copyright (c) 2015 iDev. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController
{
	var typing = false
	var float = true
	var π = M_PI
	
	//UILabel is implicitly unwrapped, you can use UILabel? and then unwrap diplay each time you use it
	@IBOutlet weak var display: UILabel!
	
	// Use se the sender: UIButton in the arguments instead of no arguments because we want to use the methods of the UIButton
	@IBAction func appendDigit(sender: UIButton)
	{
		// Let a constant is swift
		let digit = sender.currentTitle!
		if digit == "π" {
			if(typing) {
				enter()
			}
			display.text! =  "\(M_PI)"
			enter()
		}
		else if digit == "." {
			if float == false {
				return
			}
			float = false
			display.text! = display.text! + digit
		}
		else if typing {
			// you need to unwrap display.text because it is initially an optional
			display.text! = display.text! + digit
		}
		else {
			display.text! = digit
			typing = true
		}
	}
	
	// you can also say operandStack: Array<Double> = Array<Double>()
	var operandStack = Array<Double>()
	
	@IBAction func operate(sender: UIButton) {
		var operation = sender.currentTitle!
		if typing {
			enter()
		}
		switch operation {
		case "⨯" : performOperation { $0 * $1 }
		case "÷" : performOperation { $1 / $0 }
		case "-" : performOperation { $0 - $1 }
		case "+" : performOperation { $0 + $1 }
		case "√" : performOperation { sqrt($0) }
		case "sin" : performOperation { sin($0) }
		case "cos" : performOperation { cos($0) }
			default : break
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
	
	@IBAction func enter() {
		typing = false
		float = true
		operandStack.append(displayValue)
		println("operandStack = \(operandStack)")
	}
	
	var displayValue: Double {
		get{
			// the keyword as is use to cast the data types
			return (display.text! as NSString).doubleValue
		}
		set{
			display.text! = "\(newValue)"
			typing = false
		}
	}
}

