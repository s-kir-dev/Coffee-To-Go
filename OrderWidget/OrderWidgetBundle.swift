//
//  OrderWidgetBundle.swift
//  OrderWidget
//
//  Created by Кирилл Сысоев on 23.11.2024.
//

import WidgetKit
import SwiftUI

@main
struct OrderWidgetBundle: WidgetBundle {
    var body: some Widget {
        OrderWidget()
        OrderWidgetControl()
        OrderWidgetLiveActivity()
    }
}
