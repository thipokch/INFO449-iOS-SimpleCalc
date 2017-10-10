//
//  main.swift
//  SimpleCalc
//
//  Created by Thipok Cholsaipant on 10/8/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

enum Operation {
    case binaryOperation((Int, Int) -> Int)
    case unaryOperation((Int) -> Int)
    case aggregateOperation(([Int]) -> Int)
}

// add, sub, mul, div, mod
private var operations: Dictionary<String,Operation> = [
    "+" : Operation.binaryOperation({ $0 + $1 }),
    "-" : Operation.binaryOperation({ $0 - $1 }),
    "*" : Operation.binaryOperation({ $0 * $1 }),
    "/" : Operation.binaryOperation({ $0 / $1 }),
    "%" : Operation.binaryOperation({ ($0 * $1) * (1 - $1) }),
    "count" : Operation.aggregateOperation({ $0.count }),
    "avg" : Operation.aggregateOperation({
        var sum = 0
        for num in $0 {
            sum += num
        }
        return sum / $0.count
    }),
    "fact" : Operation.unaryOperation({
        var accumulator = 1
        if $0 == 0 {
            return 0
        } else if $0 < 0 {
            accumulator = -1
        }
        
        for i in 1...abs($0) {
            accumulator *= i
        }
        return accumulator
    }),
]

private var alt: Dictionary<String, [String]> = [
    "+" : ["add"],
    "-" : ["sub", "subtract"],
    "*" : ["x", "multiply", "mul"],
    "/" : ["div", "divide"],
    "%" : ["mod"],
]


// Enters the program
print("Enter an expression separated by returns:")

// Begin taking in input

var inputEnded = false
var operands: [Int] = []
var mathOperator: Operation?

var result: Int?

func resetAndRaiseError(error:String) {
    print(error)
    operands = []
    mathOperator = nil
}

while !inputEnded {
    let response = readLine(strippingNewline: true)!
    
    // Input Number
    if  let value = Int(response){
        operands.append(value)
        switch mathOperator {
        case .binaryOperation?:
            inputEnded = true
        case .aggregateOperation?:
            resetAndRaiseError(error: "Unexpected Operand, Please try again.")
        default:
            break
        }


    // Verify & Input Operator
    // mathOperator not chosen, mathOperator input
    } else if mathOperator == nil, let thisOperation = operations[response]{
        switch thisOperation {
        case .binaryOperation:
            if operands.count != 1{
                resetAndRaiseError(error: "Unexpected Operation, Please try again.")
            }
        case .aggregateOperation:
            inputEnded = true
        case .unaryOperation:
            if operands.count != 1 {
                resetAndRaiseError(error: "Expected 1 operand, Please try again.")
            } else {
                inputEnded = true
            }
        }
        mathOperator = thisOperation
    } else {
        resetAndRaiseError(error: "Invalid Input, Please try again.")
    }
}


if let operation = mathOperator {
    switch operation {
    case .binaryOperation(let function):
        result = function(operands[0], operands[1])
    case .aggregateOperation(let function):
        result = function(operands)
    case .unaryOperation(let function):
        result = function(operands[0])
    }
}

print("Result: \(result!)")




