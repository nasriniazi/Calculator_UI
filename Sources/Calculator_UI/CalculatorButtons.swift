//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-14.
//

import Foundation
import UIKit
import CalculatorCore
import Theme

public enum CalculatorButtons:  CustomStringConvertible {
    case digit(_ digit: Digit)
    case operation(_ operation:Operations.BinaryOperations.RawValue)
    case allClear
    case unaryOperation(_ operation: Operations.UnaryOperatotions.RawValue)
    case clear
    case equal
    
    public  var description: String {
        switch self {
        case .digit(let digit):
            return digit.description
        case .operation(let operation):
            return operation
        case .unaryOperation(let operation):
            return operation
        case .allClear:
            return "AC"
        case .clear:
            return "C"
        case .equal:
            return "="
        }
    }
    public var themeClasseForType:UIButton{
        switch self {
        case .digit(_ ):
            return  DigitButton()
        case .operation(_):
            return DarkButton()
        case .allClear,.clear:
            return LightButton()
        case .unaryOperation(_):
            return LightButton()
        case .equal:
            return DarkButton()
        }
    }
    
    
}
public enum Digit: Int, CaseIterable, CustomStringConvertible {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    public var description: String {
        "\(rawValue)"
    }
}


