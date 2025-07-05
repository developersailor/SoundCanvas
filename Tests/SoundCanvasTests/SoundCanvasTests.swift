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
}
