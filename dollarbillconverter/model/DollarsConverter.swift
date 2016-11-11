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
    private var currentRates : [ExchangeRate]?
    
    private var currenciesToShow = ["GBP", "BRL", "JPY", "EUR"]
    
    // MARK: public interface
    
    /**
     Converts a set amount of us dollars to various currencies
     
     - Parameter amount: the amount of us dollars.
     - Parameter completion: to be executed upon conversion completion
     */
    func convertDollars(amount: Int, completion: ([ConvertedCurrency]?, String?) -> Void)  {
        
        if let currentRates = currentRates {
            completion(ratesToDollars(amount, rates: currentRates), nil)
            return
        } else {
            obtainCurrentRates({ rates, error in
                
                if let error = error {
                    completion(nil, error);
                    return
                }
                
                if let rates = rates {
                    self.currentRates = rates
                    completion(self.ratesToDollars(amount, rates: rates), nil)
                    return
                } else {
                    completion(nil, "No rates were brought up");
                    return
                }
            })
            
        }
    
    }
    
    // MARK: private interface
    
    /**
     Obtains current rates of exchange from external endpoint
     
     - Parameter completion: to be executed upon api response
     */
    private func obtainCurrentRates(completion : ([ExchangeRate]?, String?) -> Void) {
        
        let endpoint = EndPoints.currentRatesEndpointForCurrencies(currenciesToShow)
        HttpReq.getJSON(endpoint) { data, error in
            
            if let error = error {
                completion(nil, error);
                return
            }
            
            guard let rawRates = data["rates"] else {
                
                completion(nil, "Could not get rates")
                return
            }
            
            guard let rates = rawRates as? HttpReq.JSONObject else {
                completion(nil, "Could not get rates")
                return
            }
            
            completion(self.mapRates(rates), nil)
            
        }
    }
    
    /**
     Maps the return from api to a manageable structure
     
     - Parameter apiRates: the returned rates dictionary from api endpoint
     
     - Returns: an array of exchange rates
     */
    private func mapRates(apiRates: HttpReq.JSONObject) -> [ExchangeRate] {
        
        var rates: [ExchangeRate] = [];
        
        for(identifier, rate) in apiRates {
            let id = identifier
            let rate = rate as! Double
            rates.append(ExchangeRate(id: id, rate: rate))
        }
        
        return rates
    }
    
    /**
     Converts an amount of dollars to various currencies based on current exchange rates
     
     - Parameter dollarsAmount: amount of dollars
     
     - Parameter rates: an array of exchange rates
     
     - Return: An array of converted currencies
     */
    private func ratesToDollars(dollarsAmount: Int, rates: [ExchangeRate]) -> [ConvertedCurrency] {
    
        var results : [ConvertedCurrency] = []
        
        for exchangeRate in rates {
            
            results.append(
                ConvertedCurrency(
                    currencyId: exchangeRate.id,
                    dollarsWorth: convertToDollars(exchangeRate.rate, dollarsAmount: dollarsAmount)
                )
            )
            
        }

        return results
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
    
    static func currentRatesEndpointForCurrencies(currencies: [String]) -> String {
    
        var currentRatesUrl = EndPoints.CurrentRates.rawValue + "&symbols="
        
        currencies.forEach() {
            currentRatesUrl += "\($0),"
        }
        
        return currentRatesUrl
    }
}


struct ConvertedCurrency {
    var currencyId : String
    var dollarsWorth : Double
}


struct ExchangeRate {
    var id: String
    var rate: Double
}

