//
//  ChartModel.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation

typealias Performance = (timestamp: Int, value: Double)

struct ChartModel: Codable {
    let content: Content
    let status: String
}

struct Content: Codable {
    let quoteSymbols: [QuoteSymbol]
}

struct QuoteSymbol: Codable {
    let symbol: String
    let timestamps: [Int]
    let opens, closures, highs, lows: [Double]
    let volumes: [Int]
    
    var performance: [Performance] {
        let basePrice = opens.first ?? 0
        return zip(timestamps, opens)
            .map { hourlyData -> Performance in
                let value = 100 * hourlyData.1 / basePrice - 100
                return (hourlyData.0, value)
            }
    }
}

