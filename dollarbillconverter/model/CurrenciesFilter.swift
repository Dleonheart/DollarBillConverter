//
//  CurrenciesFilter.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 10/3/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import Foundation

class CurrenciesFilter {

    private var currenciesToShow = ["GBP", "BRL", "JPY", "EUR"]
    
    /**
     Filters an array of ExchangeRate with whitelist currency ids
     
     - Parameter rates: The ExchangeRate array
     - Returns filtered array
    
     */
    func filterCurrencies(rates: [ExchangeRate] ) -> [ExchangeRate]  {
        
       return rates.filter { rate in
            
            return currenciesToShow.contains(rate.id)
        }
        
    }
}
