//
//  WordsServiceProtocol.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import Foundation

protocol WordsServiceProtocol: NSObject {
    func getNextWord() -> String
    func isWordExists(_ word: String) -> Bool
}
