//
//  GameViewController.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import UIKit

fileprivate let LetterCellIdentifier = "LetterCellIdentifier"

class GameViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    
    private var columns = 5
    private var rows = 6
    
    private var results = [(word: String, result: WordComparisonResult)]()
    private var guess = ""
    
    lazy var presenter = {
        return GamePresenter(view: self,
                             wordsService: WordsService())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsCollectionView.delegate = self
        wordsCollectionView.dataSource = self
        
        inputTextField.delegate = self
        
        self.presenter.viewDidLoad()
    }
    
    func cleanGameBoard() {
        wordsCollectionView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameViewController: GameViewProtocol {
    func restartGame(letters: Int, tries: Int) {
        columns = letters
        rows = tries
        guess = ""
        inputTextField.text = ""
        results.removeAll()
        cleanGameBoard()
        inputTextField.becomeFirstResponder()
    }
    
    func displayResults(_ results: [(String, WordComparisonResult)]) {
        self.results = results
        wordsCollectionView.reloadData()
    }
    
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error._domain, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.wordsCollectionView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func finishGame(_ status: GameEndState) {
        inputTextField.resignFirstResponder()
        
        var title = ""
        var message = ""
        
        switch status {
        case .win:
            title = "WIN"
            message = "You've discovered the word!"
        case let .lose(selectedWord):
            title = "LOST"
            message = "You lost! The word was: \(selectedWord)"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Again!", style: .default, handler: { _ in
            self.presenter.readyToStart()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension GameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text ?? ""
        text = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        if text.count > columns {
            return false
        }
        
        guess = text
        wordsCollectionView.reloadData()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.guessWord(guess: guess)
        guess = ""
        inputTextField.text = ""
        return true
    }
}

extension GameViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCellIdentifier, for: indexPath) as! LetterCollectionViewCell
        
        var displayHints = false
        var word = ""
        if indexPath.section == results.count {
            word = guess
        }
        else if indexPath.section < results.count {
            word = results[indexPath.section].word
            displayHints = true
        }
        
        let wordAsArray = word.map{ String($0) }
        if wordAsArray.indices.contains(indexPath.item) {
            cell .setLetter(wordAsArray[indexPath.item],
                            state: displayHints ? results[indexPath.section].result.lettersState[indexPath.item] : nil)
        }
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0)
    }
}
