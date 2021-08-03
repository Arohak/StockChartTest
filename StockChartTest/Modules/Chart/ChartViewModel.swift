//
//  ChartViewModel.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation

typealias Completion<T> = (T) -> Void

protocol ChartViewModelType {
    func fetchData(completion: Completion<[[QuoteSymbol]]>?)
}

class ChartViewModel: ChartViewModelType {
    private var fileReader: FileReaderProtocol

    init(fileReader: FileReaderProtocol) {
        self.fileReader = fileReader
    }

    func fetchData(completion: Completion<[[QuoteSymbol]]>?) {
        var temp: [[QuoteSymbol]] = []
        let group = DispatchGroup()
        
        ChartIntervalType.allCases.forEach { type in
            group.enter()
            let name = "responseQuotes\(type.name)"
            if let model: ChartModel = fileReader.load(name: name) {
                temp.append(model.content.quoteSymbols)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(temp)
        }
    }
}
