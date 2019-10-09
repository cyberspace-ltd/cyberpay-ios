//
//  CardParser.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation
import UIKit

//MARK: - CardType
//from: https://github.com/Raizlabs/CardParser
enum CardType {
    
    case masterCard
    case visa
    
    static let allValues: [CardType] = [.visa, .masterCard]
    
    private var validationRequirements: ValidationRequirement {
        let prefix: [PrefixContainable], length: [Int]
        
        switch self {
            /* // IIN prefixes and length requriements retreived from https://en.wikipedia.org/wiki/Bank_card_number on June 28, 2016 */
            
  
        case .masterCard:   prefix = ["51"..."55", "2221"..."2720"]
        length = [16]
            
        case .visa:         prefix = ["4"]
        length = [13, 16, 19]
            
        }
        
        return ValidationRequirement(prefixes: prefix, lengths: length)
    }
    
    var segmentGroupings: [Int] {
        switch self {

        default:         return [4, 4, 4, 7]
        }
    }
    
    var maxLength: Int {
        return validationRequirements.lengths.max() ?? 16
    }
    
    var cvvLength: Int {
     
         return 3
        
    }
    
    func isValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isValid(accountNumber) && CardType.luhnCheck(accountNumber)
    }
    
    func isPrefixValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isPrefixValid(accountNumber)
    }
    
}

fileprivate extension CardType {
    
    struct ValidationRequirement {
        let prefixes: [PrefixContainable]
        let lengths: [Int]
        
        func isValid(_ accountNumber: String) -> Bool {
            return isLengthValid(accountNumber) && isPrefixValid(accountNumber)
        }
        
        func isPrefixValid(_ accountNumber: String) -> Bool {
            guard prefixes.count > 0 else { return true }
            return prefixes.contains { $0.hasCommonPrefix(with: accountNumber) }
        }
        
        func isLengthValid(_ accountNumber: String) -> Bool {
            guard lengths.count > 0 else { return true }
            return lengths.contains { accountNumber.length == $0 }
        }
    }
    
    // from: https://gist.github.com/cwagdev/635ce973e8e86da0403a
    static func luhnCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    func cardImage(forState cardState:CardState) -> UIImage? {
        switch cardState {
        case .identified(let cardType):
            switch cardType{
            case .visa:         return #imageLiteral(resourceName: "visa-icon")
            case .masterCard:   return #imageLiteral(resourceName: "mastacard-icon")
            }
        case .indeterminate: return #imageLiteral(resourceName: "credit-card-icon")
        case .invalid:      return #imageLiteral(resourceName: "credit-card-icon")
        }
    }

    
}

//MARK: - CardState
enum CardState {
    case identified(CardType)
    case indeterminate([CardType])
    case invalid
}

extension CardState: Equatable {}
func ==(lhs: CardState, rhs: CardState) -> Bool {
    switch (lhs, rhs) {
    case (.invalid, .invalid): return true
    case (let .indeterminate(cards1), let .indeterminate(cards2)): return cards1 == cards2
    case (let .identified(card1), let .identified(card2)): return card1 == card2
    default: return false
    }
}

extension CardState {
    
    init(fromNumber number: String) {
        if let card = CardType.allValues.first(where: { $0.isValid(number) }) {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }
    
    init(fromPrefix prefix: String) {
        let possibleTypes = CardType.allValues.filter { $0.isPrefixValid(prefix) }
        if possibleTypes.count >= 2 {
            self = .indeterminate(possibleTypes)
        }
        else if possibleTypes.count == 1, let card = possibleTypes.first {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }
    
}

//MARK: - PrefixContainable
fileprivate protocol PrefixContainable {
    
    func hasCommonPrefix(with text: String) -> Bool
    
}

extension ClosedRange: PrefixContainable {
    
    func hasCommonPrefix(with text: String) -> Bool {
        //cannot include Where clause in protocol conformance, so have to ensure Bound == String :(
        guard let lower = lowerBound as? String, let upper = upperBound as? String else { return false }
        
        let trimmedRange: ClosedRange<String> = {
            let length = text.length
            let trimmedStart = lower.prefix(length)
            let trimmedEnd = upper.prefix(length)
            return trimmedStart...trimmedEnd
        }()
        
        let trimmedText = text.prefix(trimmedRange.lowerBound.count)
        return trimmedRange ~= trimmedText
    }
    
}

extension String: PrefixContainable {
    
    func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }
    
}

fileprivate extension String {
    
    func prefix(_ maxLength: Int) -> String {
        return String((maxLength))
    }
    
    var length: Int {
        return count
    }
    
}
