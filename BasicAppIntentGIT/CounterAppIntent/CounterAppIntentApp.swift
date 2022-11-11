//
//  CounterAppIntentApp.swift
//  CounterAppIntent
//
//  Created by bobh on 11/7/22.
//

import SwiftUI


@main
struct AppIntentOriginalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(counter: Counter.shared)
        }
    }
}

