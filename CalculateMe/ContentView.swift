//
//  ContentView.swift
//  CalculateMe
//
//  Created by Xavier Stern on 5/13/24.
//

import SwiftUI

enum CalcButton: String {
    case one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", zero = "0"
    case add = "+", subtract = "-", divide = "÷", mutliply = "x", equal = "=", clear = "AC", decimal = ".", percent = "%", negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State var value = "0"
    @State var runningNumber: Decimal = 0
    @State var currentOperation: Operation = .none

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    HStack {
                        Spacer()
                        Text(value)
                            .bold()
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                    }
                    .padding()

                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    self.didTap(button: item)
                                }, label: {
                                    Text(item.rawValue)
                                        .font(.system(size: 32))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: self.buttonHeight()
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(self.buttonWidth(item: item)/2)
                                })
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .padding()
                }
            )
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Decimal(string: self.value) ?? 0
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Decimal(string: self.value) ?? 0
            }
            else if button == .mutliply {
                self.currentOperation = .multiply
                self.runningNumber = Decimal(string: self.value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Decimal(string: self.value) ?? 0
            }
            else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Decimal(string: self.value) ?? 0
                switch self.currentOperation {
                case .add: self.value = formatNumber(runningValue + currentValue)
                case .subtract: self.value = formatNumber(runningValue - currentValue)
                case .multiply: self.value = formatNumber(runningValue * currentValue)
                case .divide:
                    if currentValue != 0 {
                        self.value = formatNumber(runningValue / currentValue)
                    } else {
                        self.value = "Error"
                    }
                case .none:
                    break
                }
            }

            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
        case .decimal, .negative, .percent:
            break
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }

    func formatNumber(_ number: Decimal) -> String {
        let numberFormatter = NumberFormatter()
        if NSDecimalNumber(decimal: number).doubleValue > 9999999999 || NSDecimalNumber(decimal: number).doubleValue < -9999999999 {
            numberFormatter.numberStyle = .scientific
            numberFormatter.maximumSignificantDigits = 4
        } else {
            numberFormatter.numberStyle = .decimal
        }
        return numberFormatter.string(from: NSDecimalNumber(decimal: number)) ?? ""
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
