//
//  CharsView.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/21.
//

import SwiftUI
import Charts

struct CharsViewDataItem:Equatable {
    var key: String
    var value: Int
}

struct CharsView: View {
    var dataSource: [CharsViewDataItem]
    var body: some View {
        CartesianChartView(dataSource: dataSource)
    }
}

struct CharsView_Previews: PreviewProvider {
    static var previews: some View {
        CharsView(dataSource:  [CharsViewDataItem(key: "8:00", value: 1),
                                CharsViewDataItem(key: "9:00", value: 2),
                                CharsViewDataItem(key: "10:00", value: 3),
                                CharsViewDataItem(key: "11:00", value: 4),
                                CharsViewDataItem(key: "12:00", value: 5),
                                CharsViewDataItem(key: "13:00", value: 6),
                               ])
    }
}


struct CartesianChartView: UIViewRepresentable {
    let lineChartView = LineChartView.init();
    var dataSource : [CharsViewDataItem]
    class Cordinator : NSObject, ChartViewDelegate {
        
    }
    
    func makeCoordinator() -> CartesianChartView.Cordinator {
        return Cordinator()
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        lineChartView.backgroundColor = UIColor.init(red: 230/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1.0);
        lineChartView.doubleTapToZoomEnabled = false;
        lineChartView.scaleXEnabled = false;
        lineChartView.scaleYEnabled = false;
        lineChartView.chartDescription?.text = "";//设置为""隐藏描述文字
        
        lineChartView.noDataText = "暂无数据";
        lineChartView.noDataTextColor = UIColor.gray;
        lineChartView.noDataFont = UIFont.boldSystemFont(ofSize: 14);
        
        //y轴
        lineChartView.rightAxis.enabled = false;
        let leftAxis = lineChartView.leftAxis;
        leftAxis.labelCount = 10;
        leftAxis.forceLabelsEnabled = false;
        leftAxis.axisLineColor = UIColor.black;
        leftAxis.labelTextColor = UIColor.black;
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10);
        leftAxis.labelPosition = .outsideChart;
        leftAxis.gridColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0);//网格
        leftAxis.gridAntialiasEnabled = false;//抗锯齿
        leftAxis.axisMaximum = 20;//最大值
        leftAxis.axisMinimum = 0;
        leftAxis.labelCount = 11;//多少等分
        
        //x轴
        let xAxis = lineChartView.xAxis;
        xAxis.granularityEnabled = true;
        xAxis.labelTextColor = UIColor.black;
        xAxis.labelFont = UIFont.systemFont(ofSize: 10.0);
        xAxis.labelPosition = .bottom;
        xAxis.gridColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0);
        xAxis.axisLineColor = UIColor.black;
        xAxis.labelCount = 12;
        lineChartView.delegate = context.coordinator
        
        drawLineChart()
        return lineChartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func drawLineChart(){
        //            lineChartView.addLimitLine(250, "限制线");
        let xValues = self.dataSource.map({ item in
            return item.key
        })
        if xValues.count == 0 {return}
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xValues);
        lineChartView.leftAxis.valueFormatter = IndexAxisValueFormatter.init();
        
        var yDataArray1 = [ChartDataEntry]();
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(dataSource[i].value));
            yDataArray1.append(entry);
        }
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "每分钟调用次数");
        set1.colors = [UIColor.orange];
        set1.drawCirclesEnabled = false;//绘制转折点
        set1.lineWidth = 1.0;
        
        let data = LineChartData.init(dataSets: [set1]);
        
        lineChartView.data = data;
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack);
        lineChartView.setVisibleXRange(minXRange: 1, maxXRange: 6)
        
    }
}


