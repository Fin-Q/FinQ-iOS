//
//  StudyView.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import SwiftUI
import ComposableArchitecture

struct StudyView: View {
    let store: StoreOf<StudyFeature>
    
    var body: some View {
        NavigationStack {
            Color.brandWhite
        }
    }
}

#Preview {
    StudyView(store: .init(initialState: StudyFeature.State(), reducer: {
        StudyFeature()
    }))
}
