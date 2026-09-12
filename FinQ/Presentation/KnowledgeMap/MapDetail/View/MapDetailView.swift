//
//  MapDetailView.swift
//  FinQ
//
//  Created by 권대윤 on 9/13/26.
//

import SwiftUI
import ComposableArchitecture

struct MapDetailView: View {
    let store: StoreOf<MapDetailFeature>
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    MapDetailView(store: .init(initialState: MapDetailFeature.State(category: .init(categoryID: 1, topic: .investmentBasics, categoryName: "asd", completedContentCount: 1, totalContentCount: 10, progressRate: 2, categoryCompleted: false)), reducer: {
        MapDetailFeature()
    }))
}
