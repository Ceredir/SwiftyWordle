//
//  String+Compare.swift
//  SwiftyWordle
//
//  Created by Ceredir on 11/02/2022.
//

import Foundation

extension String {
    func compare(toString: String) -> WordComparisonResult? {
        if count != toString.count {
            return nil
        }
        
        let lettersState = WordComparisonResult()
        for i in 0...toString.count-1 {
            
            let wordIndex = index(self.startIndex, offsetBy: i)
            let stringIndex = toString.index(toString.startIndex, offsetBy: i)
            if toString[wordIndex] == self[stringIndex] {
                lettersState.append(letterState: .hit)
            }
            else if contains(toString[wordIndex]){
                lettersState.append(letterState: .exists)
            }
            else {
                lettersState.append(letterState: .none)
            }
        }
        
        return lettersState
    }
}
