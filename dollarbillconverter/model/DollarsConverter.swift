//
//  DollarsConverter.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 8/31/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import Foundation

/// Retrieves exchange rates for various currencies and mapts it to an integer amount of us dollars
class DollarsConverter {
    
    /// stores the las requested exchange rates
    private var currentRates : [String:ExchangeRate]?
    
    /// if the current exchange rates should be refreshed
    private var refreshRates = false
    
    private var ratesDate: NSDate?
    
    // MARK: public interface
    
    /**
     Converts a set amount of us dollars to various currencies
     
     - Parameter amount: the amount of us dollars.
     - Parameter callback: to be executed upon conversion completion
     */
    func convertDollars(amount: Int, callback: (ExchangeRates) -> Void)  {
        
        if(currentRates != nil && !refreshRates) {
            callback(ratesToDollars(amount))
            
            return
        }
        
        obtainCurrentRates({ (data: HttpReq.JSONObject, error: String?) -> Void  in
            
            guard let rates = data["rates"] as? NSDictionary else {
                return
            }
            self.currentRates = self.mapRates(rates)
            
            guard let dateString = data["date"] as? String else {
                return
            }
            
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            self.ratesDate = dateFormater.dateFromString(dateString)
                         callback(self.ratesToDollars(amount))
        })
    }
    
    // MARK: private interface
    
    /**
     Obtains current rates of exchange from external endpoint
     
     - Parameter callback: to be executed upon api response
     */
    private func obtainCurrentRates(callback : (HttpReq.JSONObject, String?) -> Void) {
        
        HttpReq.getJSON(EndPoints.CurrentRates.rawValue, callback: callback)
    }
    
    /**
     Maps the return from api to a manageable structure
     
     - Parameter apiRates: the returned rates dictionary from api endpoint
     
     - Returns: A dictionary which key is the currency code and value the exchange rate info
     */
    private func mapRates(apiRates:NSDictionary) -> Dictionary<String, ExchangeRate> {
        
        var exchangeRates: Dictionary<String, ExchangeRate> = [:];
        
        for(identifier, rate) in apiRates {
            let id = identifier as! String
            let rate = rate as! Double
            exchangeRates[identifier as! String] = ExchangeRate(id: id, rate: rate)
        }
        
        return exchangeRates
    }
    
    /**
     Converts an amount of dollars to various currencies based on current exchange rates
     
     - Parameter dollarsAmount: amount of dollars
     
     - Return: A dictionary identifiyng the currency code and the amount of dollars in that currency
     */
    private func ratesToDollars(dollarsAmount: Int) -> ExchangeRates {
        let date  = ratesDate ?? NSDate()
       
        var exchange : ExchangeRates  = ExchangeRates(rates: [], date: date)
        
        for(_, exchangeRate) in currentRates! {
            
            exchange.rates.append(exchangeRate)
            
        }

        return exchange
    }
    
    /**
     Performs base computation to convert dollars to another currency
     
     - Parameter rate: the exchange rate for a currency
     - Parameter dollarsAmount: amount of dollars
     
     - Returns: the amount of dollars based on the rate parameter
     */
    private func convertToDollars(rate: Double, dollarsAmount: Int) -> Double {
        
        return Double(dollarsAmount) * rate
    }
    
}

/**
 List of endpoints
 
 - CurrentRates: current exchange rates for us dollars.
 */
private enum EndPoints: String {
    case CurrentRates = "https://api.fixer.io/latest?base=USD"
}


struct ExchangeRates {
    var rates : [ExchangeRate]
    var date : NSDate
}

/// represents the reate of exchange of a currency to us dollars
struct ExchangeRate {
    /// currency code
    var id: String
    /// currency rate of exchange
    var rate: Double
}

