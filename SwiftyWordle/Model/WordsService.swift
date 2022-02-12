//
//  WordsModel.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import Foundation

class WordsService: NSObject {
    private static let wordsFileName = "five-letter-words"
    private static let wordsFileType = "txt"
    
    private static let defaultWord = "aaaaa"
    
    private var words = [String]()
    
    override init() {
        super.init()
        loadWords()
    }
    
    func loadWords() {
        guard let filePath = Bundle.main.path(forResource: WordsService.wordsFileName,
                                           ofType: WordsService.wordsFileType) else {
            return
        }
        
        let contents = try? String(contentsOfFile: filePath)
        words = contents?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) ?? []
    }
}

extension WordsService: WordsServiceProtocol {
    func getNextWord() -> String {
        let word = words.randomElement() ?? WordsService.defaultWord
        return word.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isWordExists(_ word: String) -> Bool {
        return words.contains(word)
    }
}
