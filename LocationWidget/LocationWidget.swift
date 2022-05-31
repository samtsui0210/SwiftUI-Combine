//
//  LocationWidget.swift
//  LocationWidget
//
//  Created by TsuiWingLok on 12/11/2020.
//

import Foundation
import WidgetKit
import SwiftUI
import MapKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: LocalStorage.getImageFromUserDefaults(), mapImage: LocalStorage.getMapSnapshot())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: LocalStorage.getImageFromUserDefaults(), mapImage: LocalStorage.getMapSnapshot())
//        let entry = SimpleEntry(date: Date(), image: LocalStorage.getMapSnapshot())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let currentHr = Calendar.current.component(.hour, from: currentDate)
        let currentMin = Calendar.current.component(.minute, from: currentDate)
        let currentSecond = Calendar.current.component(.second, from: currentDate)
        
        let image = LocalStorage.getImageFromUserDefaults()
        let mapImage = LocalStorage.getMapSnapshot()
        
        let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, image: image, mapImage: mapImage)
        entries.append(entry)
        
//        for minuteOffset in 0 ..< remainMin {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, image: image, mapImage: mapImage)
//            entries.append(entry)
//        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image:UIImage
    let mapImage:UIImage
}

struct AlbumWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        default:
            ZStack{
                VStack{
                    Spacer()
                    HStack{
                        Text("\(entry.date, style: .date)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding([.leading, .bottom], 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .background(
                    Image(uiImage: entry.image)
                        .resizable()
                        .scaledToFill()
                )
            }
            
        }
    }
}

struct AlbumWidget: Widget {
    let kind: String = "AlbumWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AlbumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Album Widget")
        .description("This is an example widget.")
    }
}

struct MapWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        default:
            ZStack{
                VStack{
                    Spacer()
                    HStack{
                        Text("\(entry.date, style: .date)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding([.leading, .bottom], 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .background(
                    Image(uiImage: entry.mapImage)
                        .resizable()
                        .scaledToFill()
                )
            }
            
        }
    }
}

struct MapWidget: Widget {
    let kind: String = "MapWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Location Widget")
        .description("This is an example widget.")
    }
}

@main
struct LocationWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        AlbumWidget()
        MapWidget()
    }
}

struct LocationWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MapWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "image_placehold")!, mapImage: UIImage(named: "image_placehold")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            MapWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "image_placehold")!, mapImage: UIImage(named: "image_placehold")!))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MapWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "image_placehold")!, mapImage: UIImage(named: "image_placehold")!))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
