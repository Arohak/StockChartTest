//
//  ChartView.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation
import UIKit
import Charts

class ChartView: UIView {
    private var items: [[QuoteSymbol]] = []
    private let offset: CGFloat = 20
    private let chartHeight: CGFloat = 300

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ChartIntervalType.allCases.map(\.name))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(didTapSegmentControl), for: .valueChanged)
        return view
    }()
    
    private let lineChartView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAxis.enabled = false
        view.rightAxis.drawAxisLineEnabled = false
        view.xAxis.drawAxisLineEnabled = false
        view.drawBordersEnabled = false
        view.setScaleEnabled(true)
        view.legend.horizontalAlignment = .right
        view.legend.verticalAlignment = .top
        view.legend.orientation = .vertical
        view.legend.drawInside = false
        return view
    }()
    
    private var stickChartViews: [BaseCandleStickChartView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension ChartView {
    public func update(with items: [[QuoteSymbol]]) {
        self.items = items
        updateUI()
    }
}

// MARK: - Actions
extension ChartView {
    @objc private func didTapSegmentControl() {
        updateUI()
    }
}

// MARK: - Private Methods
extension ChartView {
    private func buildUI() {
        backgroundColor = .white
        
        addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: offset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -offset).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                
        stackView.addArrangedSubview(lineChartView)
        lineChartView.heightAnchor.constraint(equalToConstant: chartHeight).isActive = true
    }
    
    private func buildStickChartViewsIfNeeded(with qoutes: [QuoteSymbol]) {
        guard stickChartViews.isEmpty else { return }
        
        qoutes.forEach { q in
            let view = BaseCandleStickChartView()
            stackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: chartHeight).isActive = true
            stickChartViews.append(view)
        }
    }
    
    private func updateUI() {
        let quotes = items[segmentedControl.selectedSegmentIndex]
        buildStickChartViewsIfNeeded(with: quotes)
        upadetLineChartView(with: quotes)
        updateCandleChartView(with: quotes)
    }
    
    private func upadetLineChartView(with quotes: [QuoteSymbol]) {
        let colors = ChartColorTemplates.vordiplom()
        var dataSets: [LineChartDataSet] = []
        quotes.enumerated().forEach { (index, quote) in
            let color = colors[index % colors.count]
            let dataEntry = quote.performance.map {  ChartDataEntry(x: Double($0.timestamp), y: $0.value) }
            let set = LineChartDataSet(entries: dataEntry, label: quote.symbol)
            set.lineWidth = 2.5
            set.circleRadius = 4
            set.circleHoleRadius = 2
            set.setColor(color)
            set.setCircleColor(color)
            dataSets.append(set)
        }
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChartView.data = data
    }
    
    private func updateCandleChartView(with quotes: [QuoteSymbol]) {
        quotes.enumerated().forEach { (index, quote) in
            var dataEntries: [CandleChartDataEntry] = []
            for (index, _) in quote.timestamps.enumerated() {
                let high = quote.highs[index]
                let low = quote.lows[index]
                let open = quote.opens[index]
                let close = quote.closures[index]
                let chartDataEntry = CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close, icon: nil)
                dataEntries.append(chartDataEntry)
            }
            let set = CandleChartDataSet(entries: dataEntries, label: quote.symbol)
            set.axisDependency = .left
            set.setColor(UIColor(white: 80/255, alpha: 1))
            set.drawIconsEnabled = false
            set.shadowColor = .darkGray
            set.shadowWidth = 0.7
            set.decreasingColor = .red
            set.decreasingFilled = true
            set.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
            set.increasingFilled = true
            set.neutralColor = .blue
            let data = CandleChartData(dataSet: set)
            stickChartViews[index].data = data
        }
    }
}
