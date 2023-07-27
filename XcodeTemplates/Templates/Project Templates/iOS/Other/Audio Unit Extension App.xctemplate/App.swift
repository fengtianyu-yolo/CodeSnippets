//___FILEHEADER___

import CoreMIDI
import SwiftUI

@main
class ___PACKAGENAMEASIDENTIFIER___App: App {
    @ObservedObject private var hostModel = AudioUnitHostModel()

    required init() {}

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
