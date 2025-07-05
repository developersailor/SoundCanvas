// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import AVFoundation
import Combine

// MARK: - Core Protocols

/// Ses verisi için temel protokol
@MainActor
public protocol AudioDataProvider {
    var frequency: Double { get }
    var amplitude: Double { get }
    var waveform: [Double] { get }
    var isPlaying: Bool { get }
}

/// Ses görselleştirme için temel protokol
public protocol AudioVisualizer {
    associatedtype Content: View
    func makeView(audioData: AudioDataProvider) -> Content
}

// MARK: - Audio Data Models

/// Temel ses verisi modeli
public struct AudioData: AudioDataProvider {
    public let frequency: Double
    public let amplitude: Double
    public let waveform: [Double]
    public let isPlaying: Bool
    
    public init(frequency: Double = 440.0, amplitude: Double = 1.0, waveform: [Double] = [], isPlaying: Bool = false) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.waveform = waveform
        self.isPlaying = isPlaying
    }
}

/// Gerçek zamanlı ses verisi
@MainActor
public class LiveAudioData: ObservableObject, AudioDataProvider {
    @Published public var frequency: Double = 440.0
    @Published public var amplitude: Double = 1.0
    @Published public var waveform: [Double] = []
    @Published public var isPlaying: Bool = false
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var timer: Timer?
    
    public init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            Task { @MainActor in
                self?.processAudioBuffer(buffer)
            }
        }
    }
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        
        var samples: [Double] = []
        for i in 0..<frameLength {
            samples.append(Double(channelData[i]))
        }
        
        self.waveform = samples
        self.amplitude = samples.map { abs($0) }.max() ?? 0.0
        self.isPlaying = self.amplitude > 0.01
    }
    
    public func startRecording() {
        do {
            try audioEngine?.start()
        } catch {
            print("Audio engine start failed: \(error)")
        }
    }
    
    public func stopRecording() {
        audioEngine?.stop()
        isPlaying = false
    }
    
    deinit {
        // Cleanup will be handled by ARC
    }
}

// MARK: - Waveform Generators

/// Farklı dalga formları oluşturmak için yardımcı sınıf
public class WaveformGenerator {
    public static func sineWave(frequency: Double, amplitude: Double, sampleRate: Double = 44100, duration: Double = 1.0) -> [Double] {
        let samples = Int(sampleRate * duration)
        var waveform: [Double] = []
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            let value = amplitude * sin(2 * .pi * frequency * time)
            waveform.append(value)
        }
        
        return waveform
    }
    
    public static func squareWave(frequency: Double, amplitude: Double, sampleRate: Double = 44100, duration: Double = 1.0) -> [Double] {
        let samples = Int(sampleRate * duration)
        var waveform: [Double] = []
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            let value = amplitude * (sin(2 * .pi * frequency * time) > 0 ? 1.0 : -1.0)
            waveform.append(value)
        }
        
        return waveform
    }
    
    public static func sawtoothWave(frequency: Double, amplitude: Double, sampleRate: Double = 44100, duration: Double = 1.0) -> [Double] {
        let samples = Int(sampleRate * duration)
        var waveform: [Double] = []
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            let value = amplitude * (2.0 * (time * frequency - floor(time * frequency + 0.5)))
            waveform.append(value)
        }
        
        return waveform
    }
    
    public static func triangleWave(frequency: Double, amplitude: Double, sampleRate: Double = 44100, duration: Double = 1.0) -> [Double] {
        let samples = Int(sampleRate * duration)
        var waveform: [Double] = []
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            let phase = time * frequency
            let value = amplitude * (2.0 * abs(2.0 * (phase - floor(phase + 0.5))) - 1.0)
            waveform.append(value)
        }
        
        return waveform
    }
}

// MARK: - Audio Visualizer Views

/// Dalga formu görselleştirici
public struct WaveformVisualizer: View {
    let audioData: AudioDataProvider
    let color: Color
    let lineWidth: CGFloat
    
    public init(audioData: AudioDataProvider, color: Color = .blue, lineWidth: CGFloat = 2.0) {
        self.audioData = audioData
        self.color = color
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let centerY = height / 2
                
                guard !audioData.waveform.isEmpty else { return }
                
                let stepX = width / CGFloat(audioData.waveform.count - 1)
                
                path.move(to: CGPoint(x: 0, y: centerY + CGFloat(audioData.waveform[0]) * centerY))
                
                for i in 1..<audioData.waveform.count {
                    let x = CGFloat(i) * stepX
                    let y = centerY + CGFloat(audioData.waveform[i]) * centerY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(color, lineWidth: lineWidth)
            .animation(.easeInOut(duration: 0.1), value: audioData.waveform)
        }
    }
}

/// Spektrum analizörü
public struct SpectrumAnalyzer: View {
    let audioData: AudioDataProvider
    let barCount: Int
    let color: Color
    
    public init(audioData: AudioDataProvider, barCount: Int = 32, color: Color = .green) {
        self.audioData = audioData
        self.barCount = barCount
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 2) {
                ForEach(0..<barCount, id: \.self) { index in
                    let amplitude = getBarAmplitude(for: index)
                    Rectangle()
                        .fill(color)
                        .frame(width: (geometry.size.width - CGFloat(barCount - 1) * 2) / CGFloat(barCount),
                               height: geometry.size.height * amplitude)
                        .animation(.easeInOut(duration: 0.1), value: amplitude)
                }
            }
        }
    }
    
    private func getBarAmplitude(for index: Int) -> Double {
        guard !audioData.waveform.isEmpty else { return 0.0 }
        
        let startIndex = index * audioData.waveform.count / barCount
        let endIndex = min((index + 1) * audioData.waveform.count / barCount, audioData.waveform.count)
        let range = startIndex..<endIndex
        
        let maxAmplitude = range.map { abs(audioData.waveform[$0]) }.max() ?? 0.0
        return min(maxAmplitude, 1.0)
    }
}

/// Dairesel dalga görselleştirici
public struct CircularWaveVisualizer: View {
    let audioData: AudioDataProvider
    let color: Color
    let maxRadius: CGFloat
    
    public init(audioData: AudioDataProvider, color: Color = .purple, maxRadius: CGFloat = 100) {
        self.audioData = audioData
        self.color = color
        self.maxRadius = maxRadius
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<3, id: \.self) { waveIndex in
                    Circle()
                        .stroke(color.opacity(0.3), lineWidth: 2)
                        .scaleEffect(getWaveScale(for: waveIndex))
                        .animation(.easeInOut(duration: 0.5), value: audioData.amplitude)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func getWaveScale(for index: Int) -> CGFloat {
        let baseScale = 1.0 + CGFloat(audioData.amplitude) * 0.5
        let waveOffset = CGFloat(index) * 0.2
        return baseScale + waveOffset
    }
}

/// Titreşim efekti görselleştirici
public struct VibrationVisualizer: View {
    let audioData: AudioDataProvider
    let color: Color
    
    public init(audioData: AudioDataProvider, color: Color = .orange) {
        self.audioData = audioData
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5, id: \.self) { particleIndex in
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                        .offset(getParticleOffset(for: particleIndex, in: geometry.size))
                        .animation(.easeInOut(duration: 0.2), value: audioData.amplitude)
                }
            }
        }
    }
    
    private func getParticleOffset(for index: Int, in size: CGSize) -> CGSize {
        let angle = Double(index) * 2 * .pi / 5
        let radius = CGFloat(audioData.amplitude) * 50
        let x = cos(angle) * radius
        let y = sin(angle) * radius
        return CGSize(width: x, height: y)
    }
}

// MARK: - Composite Visualizers

/// Ana ses görselleştirici view
public struct SoundCanvasView: View {
    let audioData: AudioDataProvider
    let visualizerType: VisualizerType
    let backgroundColor: Color
    
    public enum VisualizerType {
        case waveform
        case spectrum
        case circular
        case vibration
        case combined
    }
    
    public init(audioData: AudioDataProvider, visualizerType: VisualizerType = .combined, backgroundColor: Color = .black) {
        self.audioData = audioData
        self.visualizerType = visualizerType
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            backgroundColor
            
            switch visualizerType {
            case .waveform:
                WaveformVisualizer(audioData: audioData, color: .blue)
                    .padding()
            case .spectrum:
                SpectrumAnalyzer(audioData: audioData, color: .green)
                    .padding()
            case .circular:
                CircularWaveVisualizer(audioData: audioData, color: .purple)
                    .padding()
            case .vibration:
                VibrationVisualizer(audioData: audioData, color: .orange)
                    .padding()
            case .combined:
                VStack(spacing: 20) {
                    WaveformVisualizer(audioData: audioData, color: .blue)
                        .frame(height: 100)
                    
                    SpectrumAnalyzer(audioData: audioData, color: .green)
                        .frame(height: 80)
                    
                    HStack {
                        CircularWaveVisualizer(audioData: audioData, color: .purple)
                            .frame(width: 120, height: 120)
                        
                        VibrationVisualizer(audioData: audioData, color: .orange)
                            .frame(width: 120, height: 120)
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview Helpers

/// Önizleme için test verisi
@MainActor
public class PreviewAudioData: ObservableObject, AudioDataProvider {
    @Published public var frequency: Double = 440.0
    @Published public var amplitude: Double = 0.5
    @Published public var waveform: [Double] = []
    @Published public var isPlaying: Bool = true
    
    private var timer: Timer?
    
    public init() {
        startSimulation()
    }
    
    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateWaveform()
            }
        }
    }
    
    private func updateWaveform() {
        let samples = 100
        var newWaveform: [Double] = []
        
        for i in 0..<samples {
            let time = Double(i) / Double(samples)
            let value = amplitude * sin(2 * .pi * frequency * time + Date().timeIntervalSince1970)
            newWaveform.append(value)
        }
        
        waveform = newWaveform
    }
    
    deinit {
        // Cleanup will be handled by ARC
    }
}
