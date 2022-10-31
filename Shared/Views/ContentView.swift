//
//  ContentView.swift
//  Shared
//
//  Created by endeavour42 on 11/05/2022.
//

import SwiftUI

private struct SectionView: View {
    let title: String
    let value: String
    
    var body: some View {
        
        var text = value
        if text.count > 10000 {
            text = String(text.dropLast(text.count - 10000))
        }
        
        return NavigationLink {
            ScrollView {
                VStack {
                    Text(text)
                    Spacer()
                }
            }.navigationTitle(title)
        } label: {
            Text(text)
                .lineLimit(10)
        }
    }
}

struct ContentView: View {
    @StateObject var model = IckModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Section {
                        Link(model.endpointUrl.absoluteString, destination: model.endpointUrl)
                    }
                    ForEach(model.state.items) { item in
                        Section {
                            SectionView(title: item.title, value: item.value)
                        } header: {
                            Text(item.title)
                        }
                    }
                }.listStyle(.insetGrouped)
                Button(StringKey.query.localized) {
                    model.query()
                }.padding()
            }
            .navigationTitle(StringKey.appName.localized)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
