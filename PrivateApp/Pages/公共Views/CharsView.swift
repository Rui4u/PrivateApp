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
    var orginKey: String = ""
    var value: Int = 1
    var orginType: String
}

struct CharsView: View {
    var dataSource: [String:[CharsViewDataItem]]
    var waringTimes: Int
    @State var showError: [(String, String)] = []
    var body: some View {
        VStack(alignment: .leading) {
            CartesianChartView(showError: $showError,
                               waringTimes: waringTimes,
                               dataSource: dataSource)
                .frame(minHeight:300)
            if showError.count > 0 {
                VStack {
                    ForEach(showError, id:\.self.1.hashValue) { line in
                        CharsViewWarningItem(item: line)
                    }
                    .font(.system(size: 12))
                }
            }
        }
    }
}

struct CharsViewWarningItem: View {
    var item : (String, String)
    var body: some View {
        HStack {
            Image(systemName: "hand.raised.circle.fill")
                .foregroundColor(.red)
            Text(item.0)
            Spacer()
            Text(item.1)
        }
        .padding()
        .background(Color(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0))
        .cornerRadius(4)
    }
}

struct CharsViewWarningItem_Previews: PreviewProvider {
    static var previews: some View {
        CharsViewWarningItem(item:("位置信息","10.20"))
    }
}


struct CartesianChartView: UIViewRepresentable {
    @Binding var showError: [(String, String)]
    var waringTimes: Int
    var dataSource : [String:[CharsViewDataItem]]
    
    let lineChartView = LineChartView.init();
    
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

        var xValues = self.dataSource.values.flatMap { item in
            return item
        }.map{$0.key}
        
        xValues = xValues.filterDuplicates{$0}
        xValues.sort()
        
        if xValues.count == 0 {return}
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xValues);
        lineChartView.leftAxis.valueFormatter = IndexAxisValueFormatter.init();
        
        var errorString = [(String, String)]()
        var dataSets = [LineChartDataSet]()
        for key in dataSource.keys {
            let lineDataSource = dataSource[key] ?? [];
            var yDataArray1 = [ChartDataEntry]();
            let iconInfo = PrivateType.iconInfo(rawValue:key)
            
            for index in 0..<xValues.count {
                let timeKey = xValues[index]
                let valueList = lineDataSource.filter { item in
                    item.key == timeKey
                }
                if let value = valueList.first {
                    let maxValue = Double(value.value)
                    let entry = ChartDataEntry.init(x: Double(index), y: maxValue);
                    yDataArray1.append(entry);
                    
                    if Int(maxValue) >= waringTimes {
                        let string1 = "\(iconInfo.name!) " + "请求次数为" + "\(Int(maxValue))" + "次"
                        let string2 = timeKey;
                        errorString.append((string1, string2))
                    }
                }else {
                    let entry = ChartDataEntry.init(x: Double(index), y: 0);
                    yDataArray1.append(entry);
                }
            }
            
            let set1 = LineChartDataSet.init(entries: yDataArray1, label: iconInfo.name);
            set1.colors = [UIColor(iconInfo.lineColor)]
            set1.drawCirclesEnabled = false;//绘制转折点
            set1.lineCapType = .round
            set1.lineWidth = 1.0;
            dataSets.append(set1)
            
        }
                                          
        if errorString.count > 0 {
            DispatchQueue.main.async {
                self.showError = errorString
            }
        }
        let data = LineChartData.init(dataSets: dataSets);
        
        lineChartView.data = data;
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack);
        lineChartView.setVisibleXRange(minXRange: 1, maxXRange: 6)
        
    }
}



extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

