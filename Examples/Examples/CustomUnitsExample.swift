//
//  CustomUnitsExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 05/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class CustomUnitsExample: UIViewController {

    private var chart: Chart? // arc

    override func viewDidLoad() {
        super.viewDidLoad()

        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

        var readFormatter = NSDateFormatter()
        readFormatter.dateFormat = "dd.MM.yyyy"
        
        var displayFormatter = NSDateFormatter()
        displayFormatter.dateFormat = "dd.MM.yyyy"
        
        let date = {(str: String) -> NSDate in
            return readFormatter.dateFromString(str)!
        }
        
        let calendar = NSCalendar.currentCalendar()
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> NSDate in
            let components = NSDateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.dateFromComponents(components)!
        }
        
        func filler(date: NSDate) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        let chartPoints = [
            createChartPoint(dateStr: "01.10.2015", percent: 5, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.10.2015", percent: 10, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "05.10.2015", percent: 30, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "06.10.2015", percent: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "08.10.2015", percent: 79, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "10.10.2015", percent: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "12.10.2015", percent: 47, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "14.10.2015", percent: 60, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "15.10.2015", percent: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "16.10.2015", percent: 80, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "19.10.2015", percent: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "21.10.2015", percent: 100, readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        let yValues = 0.stride(through: 100, by: 10).map {ChartAxisValuePercent($0, labelSettings: labelSettings)}
        yValues.first?.hidden = true

        let xValues = [
            self.createDateAxisValue("01.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("03.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("05.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("07.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("09.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("11.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("13.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("15.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("17.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("19.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            self.createDateAxisValue("21.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(self.view.bounds)
        let chartSettings = ExamplesDefaults.chartSettings
        chartSettings.trailing = 80
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.redColor(), animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                coordsSpace.xAxis,
                coordsSpace.yAxis,
                guidelinesLayer,
                chartPointsLineLayer]
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    func createChartPoint(dateStr dateStr: String, percent: Double, readFormatter: NSDateFormatter, displayFormatter: NSDateFormatter) -> ChartPoint {
        return ChartPoint(x: self.createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValuePercent(percent))
    }
    
    func createDateAxisValue(dateStr: String, readFormatter: NSDateFormatter, displayFormatter: NSDateFormatter) -> ChartAxisValue {
        let date = readFormatter.dateFromString(dateStr)!
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .Top)
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var text: String {
            return "\(self.formatter.stringFromNumber(self.scalar)!)%"
        }
    }
}
