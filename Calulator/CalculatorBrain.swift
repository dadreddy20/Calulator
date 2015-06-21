//
//  CalculatorBrain.swift
//  Calulator
//
//  Created by Anudeep Reddy Dwaram on 21/06/15.
//  Copyright (c) 2015 iDev. All rights reserved.
//

import Foundation

class CalculatorBrain {
	
	private var knownOps = [String : Op]() // or Dictionary<String, Ops>()
	private var opStack = [Op]() // or Array<Op>()
	
	private enum Op {
		case Operand(Double)
		case UnaryOperation(String, Double -> Double)
		case BinaryOperation(String, (Double, Double) -> Double)
	}
	
	init() {
		knownOps["⨯"] = Op.BinaryOperation("⨯", *)
		knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
		knownOps["+"] = Op.BinaryOperation("+", +)
		knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
		knownOps["√"] = Op.UnaryOperation("√", sqrt)
 	}
	
	func pushOperand(operand: Double) {
		opStack.append(Op.Operand(operand))
	}
	
	func performOperation(symbol: String) {
		if let operation = knownOps[symbol] {
			opStack.append(operation)
		}
	}
	
	private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
		if !ops.isEmpty {
			var remainingOps = ops
			let op = remainingOps.removeLast()
			switch op {
			case .Operand(let operand):
				return (operand, remainingOps)
			case .UnaryOperation(_, let operation):
				let operandEvaluation = evaluate(remainingOps)
				if let operand = operandEvaluation.result {
					return (operation(operand), operandEvaluation.remainingOps)
				}
			case .BinaryOperation(_, let operation):
				let op1Evaluation = evaluate(remainingOps)
				if let operand1 = op1Evaluation.result {
					let op2Evaluation = evaluate(remainingOps)
					if let operand2 = op2Evaluation.result {
						return (operation(operand1, operand2), remainingOps)
					}
				}
			}
		}
		return (nil, ops)
	}
	
	func evaluate() -> Double? {
		let (result, _) = evaluate(opStack)
		return result
	}
}