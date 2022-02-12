//
//  BasePresenter.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import Foundation

protocol BasePresenter {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

extension BasePresenter {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
}
