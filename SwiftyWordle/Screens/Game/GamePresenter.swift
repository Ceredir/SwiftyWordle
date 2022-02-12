//
//  GamePresenter.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import Foundation

enum GameEndState {
    case win
    case lose(selectedWord: String)
}

protocol GameViewProtocol: NSObject {
    func restartGame(letters: Int, tries: Int)
    func displayResults(_ results: [(String, WordComparisonResult)])
    func displayError(error: Error)
    func finishGame(_ status: GameEndState)
}

class GamePresenter: NSObject {
    weak var view: GameViewProtocol?
    let wordsService: WordsServiceProtocol
    
    var selectedWord: String
    var results = [(word: String, result: WordComparisonResult)]()
    
    private static let numberOfLetters = 5
    private static let numberOfTries = 6
    
    init(view: GameViewProtocol,
         wordsService: WordsServiceProtocol) {
        self.view = view
        self.wordsService = wordsService
        self.selectedWord = wordsService.getNextWord()
    }
}

extension GamePresenter: BasePresenter {
    func viewDidLoad() {
        readyToStart()
    }
}

extension GamePresenter {
    func guessWord(guess: String) {
        guard wordsService.isWordExists(guess) else {
            let error = NSError(domain: "word does not exist", code: 0, userInfo: nil)
            view?.displayError(error: error)
            return
        }
        
        guard let result = selectedWord.compare(toString: guess) else {
            let error = NSError(domain: "invalid guess", code: 1, userInfo: nil)
            view?.displayError(error: error)
            return
        }
        
        results.append((word:guess, result: result))
        view?.displayResults(results)
        
        if result.isAllHits() {
            view?.finishGame(.win)
            return
        }
        
        if results.count >= GamePresenter.numberOfTries {
            view?.finishGame(.lose(selectedWord: selectedWord))
            return
        }
    }
    
    func readyToStart() {
        self.results.removeAll()
        self.selectedWord = wordsService.getNextWord()
        self.view?.restartGame(letters: GamePresenter.numberOfLetters,
                               tries: GamePresenter.numberOfTries)
    }
}
