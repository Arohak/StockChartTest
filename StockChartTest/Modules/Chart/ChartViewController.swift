//
//  ChartViewController.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    private let rootView = ChartView()
    private var viewModel: ChartViewModelType?

    public init(viewModel: ChartViewModelType?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        fetchData()
    }
}

// MARK: - Private Methods
extension ChartViewController {
    private func makeUI() {
        title = "Charts"
        view = rootView
    }
    
    private func fetchData() {
        viewModel?.fetchData{ [weak self] items in
            self?.rootView.update(with: items)
        }
    }
}

