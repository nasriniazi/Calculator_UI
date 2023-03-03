//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-15.
//

import Foundation
import CalculatorCore
import UIKit

extension CalculatorViewModel{
    
    @objc func basicOperaorTapped(_ sender: UIButton) {
        setNewNumber()
        defer{  displayResult()}
        if let opStr = sender.currentTitle {
            if let binaryOperation = Operations.BinaryOperations(rawValue:opStr){
                do {
                    try coreCalculator.calculate(opStr: opStr)
                }
                catch let error{
                    self.handleError(error)
                    return
                }
            }
            else {
                
                try? coreCalculator.calculateUnary(opStr: opStr)
            }
        }
    }
    
    public func numberButtonTapped(_ sender: UIButton) {
        let digitStr = sender.currentTitle
        ///if decimall pressed
        if digitStr == "." {
            if setClear {
                displayText.accept("0.")
                inputNumberStr = "0."
                setClear = false
            }
            else{
                if displayText.value != nil && !hasDecimal(str: inputNumberStr){
                    inputNumberStr = inputNumberStr + digitStr!
                    displayFormattedString(inputNumberStr)
                    return
                }
            }
            guard let input = Int(digitStr!) else {return}
            if input == 0 && displayText.value == "0" {return}
            
        }
        ///if zero selected and input decimalvalue is zero , check for . to decide ignore/add zero
        if digitStr == "0" && Decimal(string:inputNumberStr) == 0{
            if hasDecimal(str: inputNumberStr){
                inputNumberStr = inputNumberStr+digitStr!
                displayText.accept(inputNumberStr)
            }
            return
        }
        if setClear {
            inputNumberStr = digitStr!
            displayFormattedString (inputNumberStr)
            setClear = false
        }
        else{
            if inputNumberStr.count == maximumInputLength {return}
            inputNumberStr = inputNumberStr+digitStr!
            displayFormattedString(inputNumberStr)
        }
    }
    func setNewNumber(){
        if setClear == false {
            coreCalculator.setNumber(digit: Decimal(string:inputNumberStr)!)
            setClear = true
        }
        /// handle operation  at first
        else if inputNumberStr == "0"{
            coreCalculator.setNumber(digit: 0.0)
        }
        
        showAC.accept(coreCalculator.showAllClear)
    }
    func displayResult(){
        ///get result of core calculation,
        if let result = coreCalculator.result {
            self.inputNumberStr = "\(result)"
            displayText.accept(String(result.withCommas))
        }
        
        showAC.accept(coreCalculator.showAllClear)
        
    }
    func evaluate(){
        setNewNumber()
        do {
            try coreCalculator.evaluate()
            displayResult()
            
        }catch let error  {
            self.handleError(error)
        }
    }
    /// Checks if  buttonType is Active
    func isActiveButton(button:CalculatorButtons)->Bool{
        return coreCalculator.isActiveOperation(opStr: button.description)
    }
    func clearAll(){
        coreCalculator.clearAll()
        setClear = true
        displayText.accept("0")
        showAC.accept(coreCalculator.showAllClear)
    }
    func clear(){
        coreCalculator.clear()
        //        setClear.accept(true)
        showAC.accept(coreCalculator.showAllClear)
    }
    private func hasDecimal(str:String)->Bool{
        let dotChar = CharacterSet(charactersIn: ".")
        return str.rangeOfCharacter(from: dotChar) != nil
    }
    private func displayFormattedString(_ string:String){
        guard let value = Decimal(string:inputNumberStr) else{
            return
        }
        
        displayText.accept(value.withCommas)
    }
    private func handleError(_ error:Error){
        if let error = error as? OperationError{
            displayText.accept(error.description)
        }
        else{
            displayText.accept(OperationError.Unknown.description)
        }
    }
    
}
