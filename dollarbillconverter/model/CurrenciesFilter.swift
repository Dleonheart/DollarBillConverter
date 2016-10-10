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
    
    
    func filterCurrencies(rates: [ExchangeRate] ) -> [ExchangeRate]  {
        
       return rates.filter { rate in
            
            return currenciesToShow.contains(rate.id)
        }
        
    }
}
