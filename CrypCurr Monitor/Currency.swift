//
//  Currency.swift
//  CrypCurr Monitor
//
//  Created by kozlojak-home on 19.02.2018.
//  Copyright © 2018 Kozlojak-dev. All rights reserved.
//

import Foundation

class Currency {
    
    var name: String?
    var symbol: String?
    var price: Float = 0
    var change24h: Float = 0
    
    init(name: String, symbol: String, price: Float, change24h: Float) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.change24h = change24h
    }
}
