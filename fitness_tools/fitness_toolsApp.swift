import SwiftUI

@main
struct fitness_toolsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        List {
            NavigationLink(destination: BMIView()) {
                Text("BMI Calculator")
            }
            NavigationLink(destination: BreathingExerciseView()) {
                Text("Breathing Exercise")
            }
        }
        .navigationTitle("Fitness Tools")
    }
}
