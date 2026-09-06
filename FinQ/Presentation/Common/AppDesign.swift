//
//  AppDesign.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import SwiftUI

enum AppDesign {
    
    //MARK: - Color
    
    enum Colors {
        static let largeTitle = Color.brandBlack
        static let title = Color.brandBlack
        
        static let caption = Color.brandGray
        static let captionInvalid = Color.brandRed
        
        static let placeholder = Color.brandGray
        
        static let buttonTitle = Color.brandWhite
        static let buttonTitleBlack = Color.brandBlack
        static let buttonTitleDarkGray = Color.brandDarkGray
        static let buttonTitleDisabled = Color.brandGray
        static let buttonBG = Color.brandBlue
        static let buttonBGDisabled = Color.brandLightGray
        
        static let divider = Color.brandLightGray
        static let chevron = Color.brandGray300
    }
    
    //MARK: - Font
    
    enum Fonts {
        static let largeTitleBold = Font.system(size: 28, weight: .bold)
        static let largeTitleSemiBold = Font.system(size: 28, weight: .semibold)
        
        static let largeBody = Font.system(size: 18, weight: .medium)
        static let body = Font.system(size: 16, weight: .medium)
        
        static let caption = Font.system(size: 14, weight: .medium)
        
        static let buttonTitle18 = Font.system(size: 18, weight: .semibold)
        static let buttonTitle16SemiBold = Font.system(size: 16, weight: .semibold)
        static let buttonTitle16 = Font.system(size: 16, weight: .medium)
        
        static let textField = Font.system(size: 18, weight: .semibold)
    }
}
