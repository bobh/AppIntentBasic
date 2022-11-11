//
//  ContentView.swift
//  BasicAppIntent
//
//  Created by bobh on 11/7/22.
//

/*
 
 Original Dev Forum post:
 
 I have scaled down one of the Apps I am working on to use to learn how to
 program App Intents and utilize Siri in my apps. I will post the scaled
 down version of my code below to its simplest form. This is a simple App
 that merely keeps a total in an @State var named counter. The App shows
 the current total along with 2 buttons, one button being labeled "minus"
 the other labeled "add".
 When someone taps the minus button, 1 is subtracted from the counter
 if the counter is greater than 0. When someone taps the plus button,
 1 is added to the counter as long as it is not greater than 10,000.
 The buttons actually call functions called decrementCounter and incrementCounter
 which does the math and updates the value of the state variable counter.
 The App works just fine as is. Minus and plus buttons work and the view is
 updated to reflect the current value of counter as buttons are pushed.
 
 The problem is when I try to use an App Intent to add or subtract from the
 counter. In this example, I only put in two App Intents, one to add to the
 counter and the other to have siri tell you what the current value of the counter is.
 The app intent called SiriAddOne calls the same function as is used when a
 button is pressed, however, the counter does not get incremented.
 Also the app intent SiriHowMany will always tell you the counter is zero.
 It's like the App Intents are not able to access the counter variable used in the view.
 I do know that the functions are being called because in my main program where
 I extracted this from, the incrementCounter and decrementCounter functions do
 others things as well. Those other things all work when I use the App Intent
 to call the function, but the counter variable remains unchanged.
 Hopefully someone can tell me what I am doing wrong here or how I need to
 go about doing this correctly.

 */


//The counter variable you are referring to is not the instance you see
//displayed on screen when running the app => ContentView().counter
//One solution would be to have ContentView observe a singleton which
// you can call from your AppIntent. For example:

import SwiftUI
import AppIntents

//@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(counter: Counter.shared)
        }
    }
}
struct ContentView: View {
    @ObservedObject var counter: Counter
        var body: some View {
        VStack {
            Text("Counter")
                .font(.title)
            Text(String(counter.value))
                .font(.title)
                .padding()
            
            HStack {
                Button(action: {
                    counter.decrementCounter()
                }, label: {
                    Image(systemName: "minus")
                        .font(.title.bold())
                        .frame(minHeight: 30)
                })
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.trailing)
                
                Button(action: {
                    counter.incrementCounter()
                }, label: {
                    Image(systemName: "plus")
                        .font(.title.bold())
                        .frame(minHeight: 30)
                })
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding(.trailing)
               
                Button(action: {
                    counter.squareRoot()
                }, label: {
                    Image(systemName: "x.squareroot")
                        .font(.title.bold())
                        .frame(minHeight: 30)
                })
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
            }
            .padding()
        }
    }
}

class Counter: ObservableObject {
    static let shared = Counter()
    //@Published var value: Int = 0
    @Published var value: Float = 0
    
    func decrementCounter() {
        if value > 0 {
            value -= 1
        }
    }
    
    func incrementCounter() {
        if value <= 9999 {
            value += 1
        }
    }
    
    func squareRoot() {
        if value > 0 {
            value = value.squareRoot()
        }
    }
    
}

@available(iOS 16, *)
struct SiriAddOne: AppIntent {
    
    static var title: LocalizedStringResource = "Add 1"
    static var description = IntentDescription("Adds 1 to the counter")
    
    static var openAppWhenRun: Bool = true
    static var parameterSummary: some ParameterSummary {
        Summary("Adds 1 to the counter")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Counter.shared.incrementCounter()
        return .result(dialog: "Okay, added 1 to counter.")
    }
}

@available(iOS 16, *)
struct SiriSquareRoot: AppIntent {
    
    static var title: LocalizedStringResource = "root"
    static var description = IntentDescription("root of the counter")
    
    static var openAppWhenRun: Bool = true
    static var parameterSummary: some ParameterSummary {
        Summary("root of the counter")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Counter.shared.squareRoot()
        return .result(dialog: "You have  \(  Counter.shared.value).")
    }
}

// Set up App Intent, perform action when matched
 // and have siri state the current value of the counter.

 @available(iOS 16, *)
 struct SiriHowMany: AppIntent {
     static var title: LocalizedStringResource = "How Many"
     static var description = IntentDescription("How Many?")
     
     
     static var openAppWhenRun: Bool = true
     static var parameterSummary: some ParameterSummary {
         Summary("Returns counter")
     }
     
     
     @MainActor
     func perform() async throws -> some IntentResult {
         return .result(dialog: "You have  \(  Counter.shared.value).")
         }
     }


 // Defines the two shortcut phrases to be used to call the two AppIntents
 @available(iOS 16, *)
 struct SiriAppShortcuts: AppShortcutsProvider {
     static var appShortcuts: [AppShortcut] {
         AppShortcut(
             intent: SiriAddOne(),
             phrases: ["Add one to \(.applicationName)"]
         )
         AppShortcut(
             intent: SiriHowMany(),
             phrases: ["How many \(.applicationName)"]
         )
         
         AppShortcut(
             intent: SiriSquareRoot(),
             phrases: ["square root \(.applicationName)"]
         )
     }
 }




struct ContentView_Previews: PreviewProvider {

 static var previews: some View {

     ContentView(counter: Counter.shared)

 }

}

     
