//
//  BaseCandleStickChartView.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import Foundation
import UIKit
import Charts

class BaseCandleStickChartView: CandleStickChartView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        dragEnabled = true
        setScaleEnabled(true)
        maxVisibleCount = 500
        pinchZoomEnabled = true
        rightAxis.enabled = false
        xAxis.labelPosition = .bottom
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
