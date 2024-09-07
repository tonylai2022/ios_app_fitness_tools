import SwiftUI

struct BMIView: View {
    @State private var heightFeet = 5
    @State private var heightInches = 7
    @State private var heightInCM = 170
    @State private var weightLbs = 132
    @State private var weightKgInteger = 60
    @State private var weightKgDecimal = 0
    @State private var selectedUnitHeight = 0
    @State private var selectedUnitWeight = 0
    @State private var bmi: Double = 0.0

    let heightsFeet = Array(4...7)
    let heightsInches = Array(0...11)
    let heightsCM = Array(130...300)
    let weightsLbs = Array(50...400)
    let weightsKgInteger = Array(30...200)
    let weightsKgDecimal = Array(0...9)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Height")) {
                    Picker("Height Unit", selection: $selectedUnitHeight) {
                        Text("Feet/Inches").tag(0)
                        Text("Centimeters").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedUnitHeight) { _ in
                        synchronizeHeight()
                    }

                    if selectedUnitHeight == 0 {
                        HStack {
                            Picker("Feet", selection: $heightFeet) {
                                ForEach(heightsFeet, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 80, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text("ft")
                                .padding(.horizontal)

                            Picker("Inches", selection: $heightInches) {
                                ForEach(heightsInches, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 80, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text("in")
                                .padding(.horizontal)
                        }
                        .onChange(of: heightFeet) { _ in
                            updateHeightInCM()
                        }
                        .onChange(of: heightInches) { _ in
                            updateHeightInCM()
                        }
                    } else {
                        HStack {
                            Picker("Centimeters", selection: $heightInCM) {
                                ForEach(heightsCM, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 150, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text("cm")
                                .padding(.horizontal)
                        }
                        .onChange(of: heightInCM) { _ in
                            updateHeightInFeetAndInches()
                        }
                    }
                }

                Section(header: Text("Weight")) {
                    Picker("Weight Unit", selection: $selectedUnitWeight) {
                        Text("Pounds").tag(0)
                        Text("Kilograms").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedUnitWeight) { _ in
                        synchronizeWeight()
                    }

                    if selectedUnitWeight == 0 {
                        HStack {
                            Picker("Pounds", selection: $weightLbs) {
                                ForEach(weightsLbs, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 150, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text("lbs")
                                .padding(.horizontal)
                        }
                        .onChange(of: weightLbs) { _ in
                            updateWeightInKg()
                        }
                    } else {
                        HStack {
                            Picker("Kilograms (Integer)", selection: $weightKgInteger) {
                                ForEach(weightsKgInteger, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 80, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text(".")

                            Picker("Kilograms (Decimal)", selection: $weightKgDecimal) {
                                ForEach(weightsKgDecimal, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .frame(width: 80, height: 150)
                            .clipped()
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())

                            Text("kg")
                                .padding(.horizontal)
                        }
                        .onChange(of: weightKgInteger) { _ in
                            updateWeightInLbs()
                        }
                        .onChange(of: weightKgDecimal) { _ in
                            updateWeightInLbs()
                        }
                    }
                }

                Section {
                    Button(action: calculateBMI) {
                        Text("Calculate BMI")
                    }
                }

                Section(header: Text("Your BMI")) {
                    Text("\(bmi, specifier: "%.2f")")
                        .foregroundColor(bmiColor)
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("BMI Calculator")
        }
    }

    func synchronizeHeight() {
        if selectedUnitHeight == 0 {
            updateHeightInFeetAndInches()
        } else {
            updateHeightInCM()
        }
    }

    func synchronizeWeight() {
        if selectedUnitWeight == 0 {
            updateWeightInLbs()
        } else {
            updateWeightInKg()
        }
    }

    func updateHeightInFeetAndInches() {
        let heightInInches = Double(heightInCM) / 2.54
        heightFeet = Int(floor(heightInInches / 12))
        heightInches = Int(round(heightInInches - Double(heightFeet * 12)))
    }

    func updateHeightInCM() {
        let heightInInches = Double(heightFeet * 12) + Double(heightInches)
        heightInCM = Int(round(heightInInches * 2.54))
    }

    func updateWeightInKg() {
        let weightInKg = Double(weightLbs) / 2.20462
        weightKgInteger = Int(weightInKg)
        let weightKgRounded = round((weightInKg - Double(weightKgInteger)) * 10) / 10
        weightKgDecimal = Int(weightKgRounded * 10)
    }

    func updateWeightInLbs() {
        let weightInKg = Double(weightKgInteger) + Double(weightKgDecimal) * 0.1
        weightLbs = Int(round(weightInKg * 2.20462))
    }

    var heightInMeters: Double {
        if selectedUnitHeight == 0 {
            let heightInInches = Double(heightFeet * 12 + heightInches)
            return heightInInches * 0.0254
        } else {
            return Double(heightInCM) / 100
        }
    }

    var weightInKg: Double {
        if selectedUnitWeight == 0 {
            return Double(weightLbs) * 0.45359237
        } else {
            return Double(weightKgInteger) + Double(weightKgDecimal) * 0.1
        }
    }

    var bmiColor: Color {
        if bmi < 18.5 {
            return .blue
        } else if bmi < 25 {
            return .green
        } else if bmi < 30 {
            return .yellow
        } else {
            return .red
        }
    }

    func calculateBMI() {
        if heightInMeters > 0 && weightInKg > 0 {
            bmi = weightInKg / (heightInMeters * heightInMeters)
        }
    }
}

struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView()
    }
}
