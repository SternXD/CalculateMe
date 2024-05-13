//
//  SettingsView.swift
//  CalculateMe
//
//  Created by Xavier Stern on 5/13/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("accentColor") private var accentColorData = Data()
    @State private var accentColor = Color.blue
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("Accent Color")) {
                    ColorPicker("Accent Color", selection: $accentColor)
                        .accentColor(accentColor)
                }
            }
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Load accentColor when view appears
            if let savedColorData = UserDefaults.standard.data(forKey: "accentColor") {
                do {
                    if let loadedColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? Color {
                        accentColor = loadedColor
                    }
                } catch {
                    print("Error loading accent color: \(error)")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
