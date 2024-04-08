//
//  StatisticsView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 08/09/23.
//

import SwiftUI
import Charts


struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CompletedForStats.doneDate, ascending: true)],
        animation: .default)
    private var dones: FetchedResults<CompletedForStats>
    
    @StateObject var sh = StatisticsHelper(today: Date(), practices: [])
    
    @State var showOmcNumbersIn = 1
    @State var showPfcNumbersIn = 1
    
    let model = StatisticsModel()
    
    var body: some View {
        ScrollView {
            VStack {
                lastNthGroupCell()
                omcGraphCell()
                pfcGraphCell()
                avgTimesCell()
                
            }
            .padding()
        }
        .onAppear() {
            sh.practices = PersistenceService.convertToCompletedType(content: dones)
            sh.generateStatistics()
        }
    }
    
    // MARK: lastNthGroupCell
    func lastNthGroupCell() -> some View {
        HStack(alignment: .top, spacing: 20) {
            CustomShadowCell {
                Text("weeklyPracticeLbl").multilineTextAlignment(.center)
                
                Text("\(sh.last7DaysCount)/7")
                    .font(.largeTitle)
                    .padding(5)
            }
            
            CustomShadowCell {
                Text("monthlyLbl").multilineTextAlignment(.center)
                
                Text("\(sh.last30DaysCount)/30")
                    .font(.largeTitle)
                    .padding(5)
            }
        }

    }
    
    // MARK: segmentedButton
    func segmentedButton(_ title: String, show: Int, omc: Bool) -> some View {
        Button(action: {
            withAnimation {
                if omc { showOmcNumbersIn = show }
                else { showPfcNumbersIn = show }
            }
        }, label: {
            if show < 4 {
                Circle()
                    .fill(model.setCircleColor(show))
                    .frame(width: 8)
            }
            
            Text(title)
        })
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            model.segButtonBackground(omc ? showOmcNumbersIn == show : showPfcNumbersIn == show)
        )
        .cornerRadius(20)
        .font(.footnote)
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
    
    // MARK: shouldShowItems
    func shouldShowItems(isOmc: Bool, line: Int, isAnn: Bool) -> CGFloat {
        if isOmc {
            if showOmcNumbersIn == line { return 1 }
            else if showOmcNumbersIn == 4 && !isAnn { return 1 }
            else if isAnn { return 0 }
            else { return 0.2 }
        } else {
            if showPfcNumbersIn == line { return 1 }
            else if showPfcNumbersIn == 4 && !isAnn { return 1 }
            else if isAnn { return 0 }
            else { return 0.2 }
        }
    }
    
    // MARK: chartButtons
    func chartButtons(isOmc: Bool) -> some View {
        HStack(spacing: 10) {
            segmentedButton("All", show: 4, omc: isOmc)
            segmentedButton("General", show: 1, omc: isOmc)
            segmentedButton("ao5", show: 2, omc: isOmc)
            segmentedButton("ao10", show: 3, omc: isOmc)
            
        }
    }
    
    // MARK: generateAnnotation
    func generateAnnotation(_ c: Int, line: Int, ann: Bool, omc: Bool) -> some View {
        Text("\(c)")
            .font(.caption2)
            .fontWeight(.bold)
            .opacity(shouldShowItems(isOmc: omc, line: line, isAnn: ann))
    }
    
    // MARK: omcGraphCell
    func omcGraphCell() -> some View {
        CustomShadowCell {
            HStack {
                Text("omcTitle").font(.subheadline)
                
                Spacer()
                
                Picker("a", selection: $sh.omcSelectedValue) {
                    ForEach(sh.omcProgressByChords.keys.sorted(), id: \.self) { coisa in
                        Text(coisa).tag(coisa)
                    }
                }
            }
            
            Divider()
            
            chartButtons(isOmc: true)
            
            Chart {
                ForEach(sh.omcSelected, id: \.self) { i in
                    let x = i.day, y = i.changes
                    LineMark(
                        x: .value("categoryLbl", x),
                        y: .value("valueLbl", y),
                        series: .value("Company", "A")
                    ).foregroundStyle(.blue)
                        .opacity(shouldShowItems(isOmc: true, line: 1, isAnn: false))
                }
                
                ForEach(sh.omcSelected, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.blue)
                        .opacity(shouldShowItems(isOmc: true, line: 1, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 1, ann: true, omc: true)
                        }
                }
                
                ForEach(sh.omcAo5, id: \.self) { i in
                    LineMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes),
                        series: .value("Company", "B")
                    ).foregroundStyle(.orange)
                        .opacity(shouldShowItems(isOmc: true, line: 2, isAnn: false))
                }
                
                ForEach(sh.omcAo5, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.orange)
                        .opacity(shouldShowItems(isOmc: true, line: 2, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 2, ann: true, omc: true)
                        }
                }
                
                ForEach(sh.omcAo10, id: \.self) { i in
                    LineMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes),
                        series: .value("Company", "C")
                    ).foregroundStyle(.green)
                        .opacity(shouldShowItems(isOmc: true, line: 3, isAnn: false))
                }
                
                ForEach(sh.omcAo10, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.green)
                        .opacity(shouldShowItems(isOmc: true, line: 3, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 3, ann: true, omc: true)
                        }
                }
                
            }
            .chartLegend(.visible)
            .frame(height: 200)
            
        }
    }
    
    
    
    func pfcGraphCell() -> some View {
        CustomShadowCell {
            HStack {
                Text("pfcTitle").font(.subheadline)
                
                Spacer()
                
                Picker("a", selection: $sh.pfcSelectedValue) {
                    ForEach(sh.pfcProgress.keys.sorted(), id: \.self) { coisa in
                        Text(coisa).tag(coisa)
                    }
                }
            }
            
            Divider()
            
            chartButtons(isOmc: false)
            
            
            Chart {
                ForEach(sh.pfcSelected, id: \.self) { i in
                    let x = i.day, y = i.changes
                    LineMark(
                        x: .value("categoryLbl", x),
                        y: .value("valueLbl", y),
                        series: .value("Company", "A")
                    ).foregroundStyle(.blue)
                        .opacity(shouldShowItems(isOmc: false, line: 1, isAnn: false))
                }
                
                ForEach(sh.pfcSelected, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.blue)
                        .opacity(shouldShowItems(isOmc: false, line: 1, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 1, ann: true, omc: false)
                        }
                }
                
                ForEach(sh.pfcAo5, id: \.self) { i in
                    LineMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes),
                        series: .value("Company", "B")
                    ).foregroundStyle(.orange)
                        .opacity(shouldShowItems(isOmc: false, line: 2, isAnn: false))
                }
                
                ForEach(sh.pfcAo5, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.orange)
                        .opacity(shouldShowItems(isOmc: false, line: 2, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 2, ann: true, omc: false)
                        }
                }
                
                ForEach(sh.pfcAo10, id: \.self) { i in
                    LineMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes),
                        series: .value("Company", "C")
                    ).foregroundStyle(.green)
                        .opacity(shouldShowItems(isOmc: false, line: 3, isAnn: false))
                }
                
                ForEach(sh.pfcAo10, id: \.self) { i in
                    PointMark(
                        x: .value("categoryLbl", i.day),
                        y: .value("valueLbl", i.changes)
                    ).foregroundStyle(.green)
                        .opacity(shouldShowItems(isOmc: false, line: 3, isAnn: false))
                        .annotation(position: .top, spacing: 0) {
                            generateAnnotation(i.changes, line: 3, ann: true, omc: false)
                        }
                }
                
            }
            .chartLegend(.visible)
            .frame(height: 200)
            
        }
        
    }
    
    func avgTimesCell() -> some View {
        CustomShadowCell {
            Text("avgPracticeMonth").padding()
            Text(Utils.convertSecondsToString(sh.avgTimeMonth)).font(.title)
            
            Divider()
            
            Text("avgByModule").font(.callout).padding()
            
            ForEach(sh.avgTimeByModule.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text("\(Utils.convertSecondsToString(sh.avgTimeByModule[key] ?? 0))")
                }
                
            }
            .padding(.bottom)
            
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
