import SwiftUI
import AudioToolbox

struct BreathingExerciseView: View {
    @State private var inhaleBeats: Int = 4
    @State private var holdBeats: Int = 7
    @State private var exhaleBeats: Int = 8
    @State private var breathCount: Int = 0
    @State private var totalCycles: Int = 8
    @State private var currentCycle: Int = 0
    @State private var isBreathing: Bool = false
    @State private var instructionText: String = "Ready to start?"
    @State private var phaseTimer: Timer?
    @State private var metronomeTimer: Timer?
    @State private var scale: CGFloat = 1.0
    @State private var pace: Double = 1.0

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 4)
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .animation(.linear(duration: currentPhaseDuration), value: scale)

                    Text(instructionText)
                        .font(.title)
                        .padding()
                }
                .padding(.vertical, 50) // Add vertical padding to avoid overlap

                HStack {
                    Text("Inhale: \(inhaleBeats) beats")
                    Slider(value: Binding(
                        get: { Double(inhaleBeats) },
                        set: { inhaleBeats = Int($0) }
                    ), in: 1...20, step: 1)
                }.padding()

                HStack {
                    Text("Hold: \(holdBeats) beats")
                    Slider(value: Binding(
                        get: { Double(holdBeats) },
                        set: { holdBeats = Int($0) }
                    ), in: 1...20, step: 1)
                }.padding()

                HStack {
                    Text("Exhale: \(exhaleBeats) beats")
                    Slider(value: Binding(
                        get: { Double(exhaleBeats) },
                        set: { exhaleBeats = Int($0) }
                    ), in: 1...20, step: 1)
                }.padding()

                HStack {
                    Text("Pace: \(String(format: "%.2f", pace)) sec/beat")
                    Slider(value: $pace, in: 0.5...1.75, step: 0.25)
                }.padding()

                HStack {
                    Text("Cycles: \(totalCycles)")
                    Slider(value: Binding(
                        get: { Double(totalCycles) },
                        set: { totalCycles = Int($0) }
                    ), in: 1...20, step: 1)
                }.padding()

                Button(action: {
                    isBreathing.toggle()
                    if isBreathing {
                        startBreathing()
                    } else {
                        stopBreathing()
                    }
                }) {
                    Text(isBreathing ? "Stop" : "Start")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("Breathing Exercise", displayMode: .inline)
        }
    }

    var currentPhaseDuration: Double {
        switch instructionText {
        case "Inhale":
            return Double(inhaleBeats) * pace
        case "Exhale":
            return Double(exhaleBeats) * pace
        default:
            return 0.0
        }
    }

    func startBreathing() {
        instructionText = "Inhale"
        withAnimation(.linear(duration: currentPhaseDuration)) {
            scale = 1.5
        }
        playStrongBeat()
        startMetronome()
        phaseTimer = Timer.scheduledTimer(withTimeInterval: currentPhaseDuration, repeats: false) { _ in
            self.instructionText = "Hold"
            self.scale = 1.5 // Keep the circle size constant during hold
            self.playStrongBeat()
            self.phaseTimer = Timer.scheduledTimer(withTimeInterval: Double(self.holdBeats) * self.pace, repeats: false) { _ in
                self.instructionText = "Exhale"
                withAnimation(.linear(duration: self.currentPhaseDuration)) {
                    self.scale = 1.0
                }
                self.playStrongBeat()
                self.phaseTimer = Timer.scheduledTimer(withTimeInterval: self.currentPhaseDuration, repeats: false) { _ in
                    if self.currentCycle < self.totalCycles {
                        self.currentCycle += 1
                        self.startBreathing()
                    } else {
                        self.stopBreathing()
                    }
                }
            }
        }
    }

    func stopBreathing() {
        phaseTimer?.invalidate()
        metronomeTimer?.invalidate()
        instructionText = "Ready to start?"
        scale = 1.0
        currentCycle = 0
    }

    func startMetronome() {
        metronomeTimer?.invalidate()
        AudioServicesPlaySystemSound(1105) // Play immediately
        metronomeTimer = Timer.scheduledTimer(withTimeInterval: pace, repeats: true) { _ in
            AudioServicesPlaySystemSound(1104)
        }
    }

    func playStrongBeat() {
        AudioServicesPlaySystemSound(1105) // Example stronger beat sound
    }
}

struct BreathingExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingExerciseView()
    }
}
