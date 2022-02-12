//
//  WordComparisonResult.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import UIKit

class WordComparisonResult: NSObject {
    enum LetterState {
        case exists
        case hit
        case none
    }
    
    private(set) var lettersState = [LetterState]()
    
    func append(letterState: LetterState) {
        lettersState.append(letterState)
    }
    
    func isAllHits() -> Bool {
        return lettersState.filter { $0 == .hit }.count == lettersState.count
    }
}
