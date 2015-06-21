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
	var brain = CalculatorBrain()
	
	//UILabel is implicitly unwrapped, you can use UILabel? and then unwrap diplay each time you use it
	@IBOutlet weak var display: UILabel!
	
	// Use se the sender: UIButton in the arguments instead of no arguments because we want to use the methods of the UIButton
	@IBAction func appendDigit(sender: UIButton)
	{
		// Let is a constant is swift
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
	
	@IBAction func operate(sender: UIButton) {
		if typing {
			enter()
		}
		if let operation = sender.currentTitle {
			if let result = brain.performOperation(operation) {
				displayValue = result
			}
		} else {
			displayValue = 0
		}
	 }
	
	@IBAction func enter() {
		typing = false
		float = true
		if let result = brain.pushOperand(displayValue) {
			displayValue = result
		} else {
			displayValue = 0
		}
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

