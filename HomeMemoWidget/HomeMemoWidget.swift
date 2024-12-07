//
//  HomeMemoWidget.swift
//  HomeMemoWidget
//
//  Created by KAWASHIMA Yoshiyuki on 2024/12/05.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  private let appGroupId = "group.io.github.ykws.example.HomeMemo"
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), name: "漢字", ruby: "かんじ")
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let name = getString(forKey: "name")
    let ruby = getString(forKey: "ruby")
    let entry = SimpleEntry(date: Date(), name: name, ruby: ruby)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let name = getString(forKey: "name")
      let ruby = getString(forKey: "ruby")
      let entry = SimpleEntry(date: entryDate, name: name, ruby: ruby)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

private extension Provider {
  func getString(forKey key: String) -> String {
    return UserDefaults(suiteName: appGroupId)?.string(forKey: key) ?? ""
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let name: String
  let ruby: String
}

struct HomeMemoWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Text(entry.ruby).font(.title3).foregroundColor(.gray)
      Text(entry.name).font(.largeTitle).bold()
    }
  }
}

struct HomeMemoWidget: Widget {
  let kind: String = "HomeMemoWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        HomeMemoWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        HomeMemoWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemMedium) {
  HomeMemoWidget()
} timeline: {
  SimpleEntry(date: .now, name: "漢字", ruby: "かんじ")
}
