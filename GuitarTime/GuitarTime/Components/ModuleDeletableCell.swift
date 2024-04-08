//
//  moduleDeletableCell.swift
//  GuitarTime
//
//  Created by Caroline Viana on 25/08/23.
//

import SwiftUI

struct ModuleDeletableCell: View {
    
    @Binding var moduleClass: GuitarClassType
    @Binding var canOpenTogle: EditMode
    @State var isToggleOpen = false
    
    let chordList: [String]
    let deleteHandler: (() -> Void)
    
//    let lazyGridConfig = [
//        GridItem(.flexible(minimum: 30)),
//        GridItem(.flexible(minimum: 30)),
//        GridItem(.flexible(minimum: 30)),
//        GridItem(.flexible(minimum: 30)),
//        GridItem(.flexible(minimum: 30))
//    ]
//
    @State var minField = "0"
    @State var secField = "00"
//
    @State var titleText = ""
    @State var decision1 = ""
    @State var decision2 = ""
    
    @StateObject var vm = ModuleDeletableCellViewModel()
    
    
    var body: some View {
        let bindingTitle = Binding<String>(get: {
            self.titleText
        }, set: {
            self.titleText = $0
            self.moduleClass.classTitle = $0
        })
        
        return VStack(alignment: .leading) {
            HStack {
                setupDeleteButton()
                
                switch moduleClass.classType {
                case .generic:
                    TextField("\(moduleClass.classType.classTitle)", text: bindingTitle)
                default:
                    Text(titleText)
                }
                
                Spacer()
                
                setupToggleButton()
            }
            
            if isToggleOpen { toggleContent().padding(.top) }
        }
        
    }
    
    func setupDeleteButton() -> some View {
        ZStack {
            Image(systemName: AppStrings.sysimgRemoveList)
                .foregroundColor(.red)
                .padding(.leading, 8)
                .font(.system(size: 18))
        }
        .onTapGesture {
            withAnimation {
                deleteHandler()
            }
        }
    }
    
    func setupToggleButton() -> some View {
        Image(systemName: isToggleOpen ? AppStrings.sysimgToggleOpened : AppStrings.sysimgToggleClosed)
            .foregroundColor(Color.accentColor)
            .onTapGesture {
                if canOpenTogle == .inactive {
                    withAnimation {
                        isToggleOpen.toggle()
                    }
                }
            }
            .onChange(of: canOpenTogle) {newValue in
                if newValue == .active {
                    withAnimation {
                        isToggleOpen = false
                    }
                }
            }
    }
    
    func toggleContent() -> some View {
        VStack {
            switch moduleClass.classType {
            case .PFC, .oneMinChanges:  quickChangesCell()
            case .generic:              placeholderCell()
            case .singleCPP:            chordPerfectPracticeCell()
            case .multipleCPP:          exploringChordsCell()
            default:                    placeholderCell()
            }
        }
        
    }
    
    // MARK: - Perfect Fast Changes & 1 Min Changes
    
    func pickerChangeHandler(old: String, new: String) {
        let i = moduleClass.classChords.firstIndex(where: {
            $0 == old }) ?? 0
        
        moduleClass.classChords.remove(at: i)
        moduleClass.classChords.append(new)
    }
    
    func chordPicker(for picker: Int = 1) -> some View {
        if picker == 1 {
            return Group {
                Picker("chordLbl",
                       selection: $vm.pickedChord1) {
                    ForEach(chordList, id:\.self) { str in
                        Text(str).tag(str)
                    }
                }.onChange(of: vm.pickedChord1) {
                    [p = vm.pickedChord1] newVal in
                    pickerChangeHandler(old: p, new: newVal)
                }
            }
        } else {
            return Group {
                Picker("chordLbl",
                       selection: $vm.pickedChord2) {
                    ForEach(chordList, id:\.self) { str in
                        Text(str).tag(str)
                    }
                }.onChange(of: vm.pickedChord2) {
                    [p = vm.pickedChord2] newVal in
                    pickerChangeHandler(old: p, new: newVal)
                }
            }
        }
    }
    
    func quickChangesCell() -> some View {
        VStack {
            chordPicker(for: 1)
            chordPicker(for: 2)
        }
    }
    
    // MARK: - durationPicker
    
    func durationPicker() -> some View {
        VStack {
            HStack {
                Text("classDuration")
                
                Spacer()
                
                Picker("", selection: $vm.minPicked) {
                    ForEach(0..<31, id: \.self) { n in
                        Text("\(n)").tag(n)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 80)
                .clipped()
                
                Text(":")
                
                Picker("", selection: $vm.secPicked) {
                    ForEach(0..<60, id: \.self) { n in
                        Text("\(n < 10 ? "0" : "")\(n)").tag(n)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 80)
                .clipped()
            }
        }
    }
    
    func chordSelector() -> some View {
        let containsChord: ((_ forChord: String) -> Bool) = { forChord in
            moduleClass.classChords.contains(forChord)
        }
        
        return Group {
            LazyVGrid(columns: vm.lazyGridConfig) {
                ForEach(chordList, id: \.self) { chord in
                    Text(chord)
                        .onTapGesture {
                            if containsChord(chord) {
                                let i = moduleClass.classChords.firstIndex(where: { $0 == chord }) ?? 0
                                moduleClass.classChords.remove(at: i)
                            }
                            else {
                                moduleClass.classChords.append(chord)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 0.5)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(containsChord(chord)
                                      ? AppColors.brandPrimary
                                      : .clear)
                        )
                }
            }
        }
    }
    
    // MARK: - Chord Perfect Practice
    
    func chordPerfectPracticeCell() -> some View {
        VStack {
            chordPicker()
            durationPicker()
        }
    }
    
    // MARK: - Exploring New Chords
    
    func exploringChordsCell() -> some View {
        VStack {
            durationPicker()
            Text("chordsInClass")
            chordSelector()
        }
    }
    
    
    
    
    
    // MARK: - placeholderCell
    
    func placeholderCell() -> some View {
        Text("Placeholder")
    }
    
    
    
//    var body: some View {
//        let bindingTitle = Binding<String>(get: {
//            self.titleText
//        }, set: {
//            self.titleText = $0
//            self.moduleClass.classTitle = $0
//        })
//
//        return VStack(alignment: .leading) {
//            HStack {
//                ZStack {
//                    Image(systemName: AppStrings.sysimgRemoveList)
//                        .foregroundColor(.red)
//                        .padding(.leading, 8)
//                        .font(.system(size: 18))
//                }
//                .onTapGesture {
//                    withAnimation {
//                        deleteHandler()
//                    }
//                }
//
//                switch moduleClass.classType {
//                case .generic:
//                    TextField("\(moduleClass.classType.classTitle)", text: bindingTitle)
//
//                default:
//                    Text(moduleClass.classTitle).padding(.leading, 8)
//                }
//
//                Spacer()
//
//                Image(systemName: isToggleOpen ? AppStrings.sysimgToggleOpened : AppStrings.sysimgToggleClosed)
//                    .foregroundColor(Color.accentColor)
//                    .onTapGesture {
//                        if canOpenTogle == .inactive {
//                            withAnimation {
//                                isToggleOpen.toggle()
//                            }
//                        }
//                    }
//                    .onChange(of: canOpenTogle) {newValue in
//                        if newValue == .active {
//                            withAnimation {
//                                isToggleOpen = false
//                            }
//                        }
//                    }
//            }
//
//            if isToggleOpen {
//                switch moduleClass.classType {
//                case .PFC, .oneMinChanges:
//                    pfcView()
//                case.generic:
//                    genericView()
//                case .singleCPP:
//                    cppView()
//                case .multipleCPP:
//                    exploringChordsView()
//                default:
//                    onlyDescriptionView()
//                }
//            }
//
//        }
//    }
//
//    func timerPicker() -> some View {
//        let bindingMin = Binding<String>(get: {
//            self.minField
//        }, set: {
//            self.minField = $0
//            self.moduleClass.duration = convStr($0) * 60 + convStr(self.secField)
//        })
//
//        let bindingSec = Binding<String>(get: {
//            self.secField
//        }, set: {
//            self.secField = $0
//            self.moduleClass.duration = convStr(self.minField) * 60 + convStr($0)
//        })
//
//        func convStr(_ str: String) -> Int16 {
//            return Int16(str) ?? 0
//        }
//
//        return HStack {
//            Text(AppStrings.classDuration)
//            Spacer()
//            TextField("0", text: bindingMin)
//                .textFieldStyle(.roundedBorder)
//                .frame(width: 45)
//                .keyboardType(.numberPad)
//
//
//            Text(":")
//
//            TextField("00", text: bindingSec)
//                .textFieldStyle(.roundedBorder)
//                .frame(width: 45)
//                .keyboardType(.numberPad)
//        }
//
//    }
//
//    // Perfect Fast Changes / One Minute Changes
//
//    func pfcView() -> some View {
//        VStack {
//            Picker(AppStrings.chord, selection: $decision1) {
//                ForEach(chordList, id:\.self) { str in
//                    Text(str).tag(str)
//                }
//            }
//            .onChange(of: decision1) { [decision1] newValue in
//                changeHandler(old: decision1, new: newValue)
//            }
//
//            Picker(AppStrings.chord, selection: $decision2) {
//                ForEach(chordList, id:\.self) { str in
//                    Text(str).tag(str)
//                }
//            }
//            .onChange(of: decision2) { [decision2] newValue in
//                changeHandler(old: decision2, new: newValue)
//            }
//        }
//    }
//
//    func changeHandler(old: String, new: String) {
//        let i = moduleClass.classChords.firstIndex(where: { $0 == old }) ?? 0
//        moduleClass.classChords.remove(at: i)
//
//        moduleClass.classChords.append(new)
//        print(moduleClass.classChords)
//    }
//
//    // Chord Perfect Practice
//
//    func cppView() -> some View {
//        VStack {
//            Divider()
//            timerPicker()
//            Divider()
//
//            Picker(AppStrings.chord, selection: $decision1) {
//                ForEach(chordList, id:\.self) { str in
//                    Text(str).tag(str)
//                }
//            }
//            .onChange(of: decision1) { [decision1] newValue in
//                moduleClass.classChords.remove(at: 0)
//                changeHandler(old: decision1, new: newValue)
//            }
//        }
//    }
//
//    func exploringChordsView() -> some View {
//        VStack {
//            Divider()
//            timerPicker()
//            Divider()
//
//            Text(AppStrings.chordsInClass)
//
//            LazyVGrid(columns: lazyGridConfig) {
//                ForEach(chordList, id: \.self) { chord in
//                    Text(chord)
//                        .onTapGesture {
//                            if moduleClass.classChords.contains(chord) {
//                                let i = moduleClass.classChords.firstIndex(where: { $0 == chord }) ?? 0
//                                moduleClass.classChords.remove(at: i)
//                            }
//                            else {
//                                moduleClass.classChords.append(chord)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 6)
//                        .background(moduleClass.classChords.contains(chord) ? .orange : .white)
//                }
//
//            }
//        }
//    }
//
//    func countRows() -> Int {
//        let count = chordList.count
//        return count / 6
//    }
//
//    func onlyDescriptionView() -> some View {
//        VStack {
//            Divider()
//            timerPicker()
//            Divider()
//
//            TextField("descriptionLabel", text: $decision1, axis: .vertical)
//                .textFieldStyle(.roundedBorder)
//        }
//    }
//
//    func genericView() -> some View {
//        VStack {
//            Divider()
//            timerPicker()
//            Divider()
//
//            TextField(AppStrings.descriptionLabel, text: $decision1, axis: .vertical)
//                .textFieldStyle(.roundedBorder)
//
//            Divider()
//
//            Text(AppStrings.chordsInClass)
//
//            LazyVGrid(columns: lazyGridConfig) {
//                ForEach(chordList, id: \.self) { chord in
//                    Text(chord)
//                        .onTapGesture {
//                            if moduleClass.classChords.contains(chord) {
//                                let i = moduleClass.classChords.firstIndex(where: { $0 == chord }) ?? 0
//                                moduleClass.classChords.remove(at: i)
//                            }
//                            else {
//                                moduleClass.classChords.append(chord)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 6)
//                        .background(moduleClass.classChords.contains(chord) ? .orange : .white)
//                }
//
//            }
//        }
//    }
}


// MARK: - Preview

struct ModuleDeletableCell_PreviewProvider: View {
    @State var selectedClasses: [GuitarClassType] = [classType1, classType2]
    
    var body: some View {
        NewModuleClassListView(selectedClasses: $selectedClasses, chordList: ["A", "B", "C", "D", "E", "F", "G", "T", "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H", "U", "V"]
        )
    }
}

struct ModuleDeletableCell_Previews: PreviewProvider {
    static var previews: some View {
        ModuleDeletableCell_PreviewProvider()
    }
}


class ModuleDeletableCellViewModel: ObservableObject {
    @Published var pickedChord1 = "A"
    @Published var pickedChord2 = "A"
    
    @Published var minPicked = 0
    @Published var secPicked = 0
    
        let lazyGridConfig = [
            GridItem(.flexible(minimum: 30)),
            GridItem(.flexible(minimum: 30)),
            GridItem(.flexible(minimum: 30)),
            GridItem(.flexible(minimum: 30)),
            GridItem(.flexible(minimum: 30))
        ]
}
