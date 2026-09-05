//
//  AppDesign.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import SwiftUI

enum AppDesign {
    
    //MARK: - Color
    
    static let largeTitle = Color.brandBlack
    
    static let caption = Color.brandGray
    static let captionInvalid = Color.brandRed
    
    static let placeholder = Color.brandGray
    
    static let buttonTitle = Color.brandWhite
    static let buttonTitleDisabled = Color.brandGray
    static let buttonBG = Color.brandBlue
    static let buttonBGDisabled = Color.brandLightGray
    
    
    //MARK: - Font
    
    enum Fonts {
        static let largeTitleBold = Font.system(size: 28, weight: .bold)
        static let largeTitleSemiBold = Font.system(size: 28, weight: .semibold)
        
        static let largeBody = Font.system(size: 18, weight: .medium)
        static let body = Font.system(size: 16, weight: .medium)
        
        static let caption = Font.system(size: 14, weight: .medium)
        
        static let buttonTitle = Font.system(size: 18, weight: .semibold)
    }
}
