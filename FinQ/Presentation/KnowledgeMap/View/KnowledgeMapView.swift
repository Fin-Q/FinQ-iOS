//
//  KnowledgeMapView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct KnowledgeMapView: View {
    let store: StoreOf<KnowledgeMapFeature>
    
    var body: some View {
        Text("Hello, KnowledgeMap!")
    }
}

#Preview {
    KnowledgeMapView(store: .init(initialState: KnowledgeMapFeature.State(), reducer: {
        KnowledgeMapFeature()
    }))
}
