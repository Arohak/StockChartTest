//
//  ChartIntervalType.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation

enum ChartIntervalType: Int, CaseIterable {
    case week
    case month

    var name: String {
        switch self {
        case .week:     return "week".capitalized
        case .month:    return "month".capitalized
        }
    }
}
