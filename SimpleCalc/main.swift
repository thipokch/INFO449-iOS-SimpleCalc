//
//  main.swift
//  SimpleCalc
//
//  Created by Thipok Cholsaipant on 10/8/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

// Enumeration of possible types of operation
enum Operation {
    // User type one operand, operation, followed by operand. Operation is then performed
    case binaryOperation((Int, Int) -> Int)
    // User type one operand, followed by operation. Operation is then performed
    case unaryOperation((Int) -> Int)
    // User type the operands, then operation is then typed and performed
    case aggregateOperation(([Int]) -> Int)
}

// Dictionary of possible operations
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

// Dictionary of alternative string for operations
private var alt: Dictionary<String, Set<String>> = [
    "+" : ["add"],
    "-" : ["sub", "subtract"],
    "*" : ["x", "multiply", "mul"],
    "/" : ["div", "divide"],
    "%" : ["mod"],
    "fact" : ["factorial"],
    "avg" : ["average"]
]

var inputEnded = false
var operands: [Int] = []
var mathOperator: Operation?
var result: Int?

func resetAndRaiseError(error:String) {
    print(error)
    operands = []
    mathOperator = nil
}

func lookUpAlt(lookup:String) -> String {
    if operations[lookup] == nil {
        for currentAlt in alt {
            if currentAlt.value.contains(lookup) {
                return currentAlt.key
            }
        }
    }
    return lookup
}

// Prints the introduction
print("Enter an expression separated by returns:")

// Run loop of reading and validate input
while !inputEnded {
    // Reads input from the console
    let response = readLine(strippingNewline: true)!
    
    // Verify the given operand
    if  let value = Int(response){
        operands.append(value)
        switch mathOperator {
        case .binaryOperation?:
            inputEnded = true
        case .aggregateOperation?:
            resetAndRaiseError(error: "Unexpected Operand. Please try again.")
        default:
            break
        }
        
    // Verify the given operator
    } else if mathOperator == nil, let thisOperation = operations[lookUpAlt(lookup: response)]{
        
        switch thisOperation {
        case .binaryOperation:
            if operands.count != 1{
                resetAndRaiseError(error: "Unexpected Operation. Please try again.")
            } else {
                mathOperator = thisOperation
            }
        case .aggregateOperation:
            if operands.count < 1{
                resetAndRaiseError(error: "Required at least one operand. please try again.")
            } else {
                inputEnded = true
                mathOperator = thisOperation
            }
        case .unaryOperation:
            if operands.count != 1 {
                resetAndRaiseError(error: "Expected one operand. Please try again.")
            } else {
                inputEnded = true
            }
        }
    } else {
        resetAndRaiseError(error: "Invalid Input. Please try again.")
    }
}

// Performs the operation
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

// Prints the result of the operand
print("Result: \(result!)")




