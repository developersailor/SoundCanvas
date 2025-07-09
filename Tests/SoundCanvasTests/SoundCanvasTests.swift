import XCTest
@testable import SoundCanvas

@MainActor
final class SoundCanvasTests: XCTestCase {
    
    func testAudioDataInitialization() {
        let audioData = AudioData(frequency: 440.0, amplitude: 0.5, waveform: [1.0, 0.5, -0.5, -1.0], isPlaying: true)
        
        XCTAssertEqual(audioData.frequency, 440.0)
        XCTAssertEqual(audioData.amplitude, 0.5)
        XCTAssertEqual(audioData.waveform.count, 4)
        XCTAssertTrue(audioData.isPlaying)
    }
    
    func testWaveformGeneratorSineWave() {
        let waveform = WaveformGenerator.sineWave(frequency: 440.0, amplitude: 1.0, sampleRate: 1000, duration: 0.1)
        
        XCTAssertEqual(waveform.count, 100) // 1000 * 0.1 = 100 samples
        XCTAssertGreaterThan(waveform.max() ?? 0, 0.9)
        XCTAssertLessThan(waveform.min() ?? 0, -0.9)
    }
    
    func testWaveformGeneratorSquareWave() {
        let waveform = WaveformGenerator.squareWave(frequency: 440.0, amplitude: 1.0, sampleRate: 1000, duration: 0.1)
        
        XCTAssertEqual(waveform.count, 100)
        XCTAssertEqual(waveform.max(), 1.0)
        XCTAssertEqual(waveform.min(), -1.0)
    }
    
    func testWaveformGeneratorSawtoothWave() {
        let waveform = WaveformGenerator.sawtoothWave(frequency: 440.0, amplitude: 1.0, sampleRate: 1000, duration: 0.1)
        
        XCTAssertEqual(waveform.count, 100)
        XCTAssertGreaterThan(waveform.max() ?? 0, 0.9)
        XCTAssertLessThan(waveform.min() ?? 0, -0.9)
    }
    
    func testWaveformGeneratorTriangleWave() {
        let waveform = WaveformGenerator.triangleWave(frequency: 440.0, amplitude: 1.0, sampleRate: 1000, duration: 0.1)
        
        XCTAssertEqual(waveform.count, 100)
        XCTAssertGreaterThan(waveform.max() ?? 0, 0.9)
        XCTAssertLessThan(waveform.min() ?? 0, -0.9)
    }
    
    func testWaveformGeneratorHarmonicWave() {
        let waveform = WaveformGenerator.harmonicWave(frequency: 440.0, amplitude: 1.0, harmonics: 3, sampleRate: 1000, duration: 0.1)
        
        XCTAssertEqual(waveform.count, 100)
        XCTAssertGreaterThan(waveform.max() ?? 0, 0.5)
        XCTAssertLessThan(waveform.min() ?? 0, -0.5)
    }
    
    func testPreviewAudioData() {
        let previewData = PreviewAudioData()
        
        // Wait a bit for the timer to update the waveform
        let expectation = XCTestExpectation(description: "Waveform update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertGreaterThan(previewData.waveform.count, 0)
            XCTAssertTrue(previewData.isPlaying)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAudioDataProviderProtocol() {
        let audioData = AudioData(frequency: 880.0, amplitude: 0.8, waveform: [0.5, -0.5], isPlaying: false)
        
        // Test that AudioData conforms to AudioDataProvider
        let provider: AudioDataProvider = audioData
        
        XCTAssertEqual(provider.frequency, 880.0)
        XCTAssertEqual(provider.amplitude, 0.8)
        XCTAssertEqual(provider.waveform.count, 2)
        XCTAssertFalse(provider.isPlaying)
    }
    
    func testMeditationColorPalette() {
        let zenPalette = MeditationColorPalette.zen
        let cosmicPalette = MeditationColorPalette.cosmic
        
        // Test that palettes have different colors
        XCTAssertNotEqual(zenPalette.primary, cosmicPalette.primary)
        XCTAssertNotEqual(zenPalette.secondary, cosmicPalette.secondary)
        XCTAssertNotEqual(zenPalette.accent, cosmicPalette.accent)
        
        // Test that each palette has valid colors
        XCTAssertNotEqual(zenPalette.primary, zenPalette.secondary)
        XCTAssertNotEqual(zenPalette.primary, zenPalette.accent)
        XCTAssertNotEqual(zenPalette.secondary, zenPalette.accent)
    }
    
    func testMeditationVisualizers() {
        let audioData = AudioData(frequency: 432.0, amplitude: 0.7, waveform: WaveformGenerator.harmonicWave(frequency: 432.0, amplitude: 0.7), isPlaying: true)
        
        // Test that meditation visualizers can be created
        let mandala = MandalaVisualizer(audioData: audioData, palette: .zen)
        let fractal = FractalVisualizer(audioData: audioData, palette: .cosmic)
        let symmetric = SymmetricPatternVisualizer(audioData: audioData, palette: .golden)
        
        // These should not crash when created
        XCTAssertNotNil(mandala)
        XCTAssertNotNil(fractal)
        XCTAssertNotNil(symmetric)
    }
    
    func testMeditationSoundCanvasView() {
        let audioData = AudioData(frequency: 432.0, amplitude: 0.6, waveform: WaveformGenerator.sineWave(frequency: 432.0, amplitude: 0.6), isPlaying: true)
        
        // Test different meditation visualizer types
        let mandalaView = MeditationSoundCanvasView(audioData: audioData, visualizerType: .mandala, palette: .zen)
        let fractalView = MeditationSoundCanvasView(audioData: audioData, visualizerType: .fractal, palette: .cosmic)
        let zenView = MeditationSoundCanvasView(audioData: audioData, visualizerType: .zen, palette: .zen)
        
        XCTAssertNotNil(mandalaView)
        XCTAssertNotNil(fractalView)
        XCTAssertNotNil(zenView)
    }
}
