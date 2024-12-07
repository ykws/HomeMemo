//
//  ContentView.swift
//  HomeMemo
//
//  Created by KAWASHIMA Yoshiyuki on 2024/12/05.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  private let appGroupId = "group.io.github.ykws.example.HomeMemo"
  
  @State private var name: String = ""
  @State private var ruby: String = ""

  var body: some View {
    VStack {
      VStack {
        Text(ruby).font(.title3).foregroundColor(.gray)
        Text(name).font(.largeTitle).bold()
      }
      .padding()
      
      TextField("Entr name", text: $name)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      TextField("Entr ruby", text: $ruby)
        .textFieldStyle(RoundedBorderTextFieldStyle())

      Button("Save to Widget") {
        UserDefaults(suiteName: appGroupId)?.set(name, forKey: "name")
        UserDefaults(suiteName: appGroupId)?.set(ruby, forKey: "ruby")
        WidgetCenter.shared.reloadAllTimelines()
      }
      .padding()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
