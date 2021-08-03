//
//  FileReader.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation

protocol FileReaderProtocol {
    func load<T: Codable>(name: String) -> T?
}

class FileReader: FileReaderProtocol {
    func load<T: Codable>(name: String) -> T? {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                return jsonData
            } catch {
                print(error)
            }
        }
        return nil
    }
}

