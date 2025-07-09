# SoundCanvas 🎵

SwiftUI için geliştirilmiş, ses tınılarını görselleştiren modern bir kütüphane. Özellikle meditasyon uygulamaları için tasarlanmış, farklı ses tınıları farklı geometrik desenler (mandala, fraktal, simetrik) üretir ve gerçek zamanlı ses analizi yapabilir.

## 🌟 Özellikler

- **Meditasyon Odaklı Görselleştirmeler**: Mandala, fraktal, simetrik desenler
- **Özel Renk Paletleri**: Zen, gün batımı, okyanus, lavanta, altın, kozmik temalar
- **Harmonik Dalga Formları**: Meditasyon için özel harmonik seriler
- **Çoklu Görselleştirme Tipleri**: Dalga formu, spektrum analizi, dairesel dalga, titreşim efekti
- **Gerçek Zamanlı Ses Analizi**: Mikrofon girişinden canlı ses verisi
- **Farklı Dalga Formları**: Sine, kare, testere dişi, üçgen, harmonik dalga desteği
- **Özelleştirilebilir Görünüm**: Renk, boyut, animasyon ayarları
- **SwiftUI Uyumlu**: Modern SwiftUI API'leri ile tam entegrasyon
- **Cross-Platform**: macOS, iOS, tvOS, watchOS desteği

## 📋 Gereksinimler

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 15.0+

## 🚀 Kurulum

### Swift Package Manager

1. Xcode'da projenizi açın
2. **File** → **Add Package Dependencies**
3. URL'yi girin: `https://github.com/developersailor/SoundCanvas.git`
4. **Add Package** butonuna tıklayın

### Manuel Kurulum

```bash
git clone https://github.com/developersailor/SoundCanvas.git
cd SoundCanvas
swift build
```

## 📖 Kullanım

### Temel Kullanım

```swift
import SwiftUI
import SoundCanvas

struct ContentView: View {
    @StateObject private var audioData = LiveAudioData()
    
    var body: some View {
        VStack {
            // Meditasyon görselleştirici
            MeditationSoundCanvasView(
                audioData: audioData,
                visualizerType: .mandala,
                palette: .zen,
                backgroundColor: .black
            )
            .frame(height: 300)
            
            // Kontrol butonları
            HStack {
                Button("Başlat") {
                    audioData.startRecording()
                }
                .disabled(audioData.isPlaying)
                
                Button("Durdur") {
                    audioData.stopRecording()
                }
                .disabled(!audioData.isPlaying)
            }
        }
        .padding()
    }
}
```

### Meditasyon Görselleştirme Tipleri

#### 1. Mandala Görselleştirici
```swift
MandalaVisualizer(
    audioData: audioData,
    palette: .zen,
    layerCount: 8
)
.frame(width: 300, height: 300)
```

#### 2. Fraktal Görselleştirici
```swift
FractalVisualizer(
    audioData: audioData,
    palette: .cosmic,
    depth: 4
)
.frame(width: 250, height: 250)
```

#### 3. Simetrik Desen Görselleştirici
```swift
SymmetricPatternVisualizer(
    audioData: audioData,
    palette: .golden,
    symmetryOrder: 8
)
.frame(width: 200, height: 200)
```

#### 4. Zen Kombinasyonu
```swift
MeditationSoundCanvasView(
    audioData: audioData,
    visualizerType: .zen,
    palette: .zen
)
.frame(height: 400)
```

### Klasik Görselleştirme Tipleri

#### 1. Dalga Formu (Waveform)
```swift
WaveformVisualizer(
    audioData: audioData,
    color: .blue,
    lineWidth: 2.0
)
.frame(height: 100)
```

#### 2. Spektrum Analizi
```swift
SpectrumAnalyzer(
    audioData: audioData,
    barCount: 32,
    color: .green
)
.frame(height: 80)
```

#### 3. Dairesel Dalga
```swift
CircularWaveVisualizer(
    audioData: audioData,
    color: .purple,
    maxRadius: 100
)
.frame(width: 120, height: 120)
```

#### 4. Titreşim Efekti
```swift
VibrationVisualizer(
    audioData: audioData,
    color: .orange
)
.frame(width: 120, height: 120)
```

### Özel Ses Verisi Oluşturma

```swift
// Meditasyon için harmonik dalga oluşturma (432 Hz - doğal frekans)
let harmonicWave = WaveformGenerator.harmonicWave(
    frequency: 432.0,  // Doğal A4 notası
    amplitude: 1.0,
    harmonics: 5,
    sampleRate: 44100,
    duration: 1.0
)

// Sine dalga oluşturma
let sineWave = WaveformGenerator.sineWave(
    frequency: 440.0,  // A4 notası
    amplitude: 1.0,
    sampleRate: 44100,
    duration: 1.0
)

// Kare dalga oluşturma
let squareWave = WaveformGenerator.squareWave(
    frequency: 880.0,  // A5 notası
    amplitude: 0.8
)

// Özel ses verisi
let customAudioData = AudioData(
    frequency: 432.0,
    amplitude: 0.7,
    waveform: harmonicWave,
    isPlaying: true
)
```

### Önizleme için Test Verisi

```swift
struct PreviewView: View {
    @StateObject private var previewData = PreviewAudioData()
    
    var body: some View {
        SoundCanvasView(
            audioData: previewData,
            visualizerType: .waveform
        )
    }
}
```

## 🎨 Görselleştirme Seçenekleri

### MeditationSoundCanvasView.MeditationVisualizerType

- `.mandala`: Mandala görselleştirici
- `.fractal`: Fraktal desen görselleştirici
- `.symmetric`: Simetrik desen görselleştirici
- `.zen`: Zen kombinasyonu (mandala + simetrik)
- `.cosmic`: Kozmik kombinasyonu (fraktal + mandala)

### SoundCanvasView.VisualizerType

- `.waveform`: Dalga formu görselleştirici
- `.spectrum`: Spektrum analizi
- `.circular`: Dairesel dalga efekti
- `.vibration`: Titreşim parçacık efekti
- `.mandala`: Mandala görselleştirici
- `.fractal`: Fraktal görselleştirici
- `.symmetric`: Simetrik desen görselleştirici
- `.combined`: Tüm görselleştiricileri birleştirir

### Meditasyon Renk Paletleri

```swift
// Farklı meditasyon temaları
MeditationColorPalette.zen      // Yeşil tonları - sakinlik
MeditationColorPalette.sunset   // Turuncu-kırmızı - enerji
MeditationColorPalette.ocean    // Mavi tonları - derinlik
MeditationColorPalette.lavender // Mor tonları - ruhsallık
MeditationColorPalette.golden   // Altın tonları - aydınlanma
MeditationColorPalette.cosmic   // Uzay tonları - sonsuzluk
```

### Renk Özelleştirme

```swift
// Farklı renkler ile görselleştirme
WaveformVisualizer(audioData: audioData, color: .red)
SpectrumAnalyzer(audioData: audioData, color: .cyan)
CircularWaveVisualizer(audioData: audioData, color: .yellow)
VibrationVisualizer(audioData: audioData, color: .pink)
```

## 🔧 Gelişmiş Kullanım

### Özel AudioDataProvider

```swift
class CustomAudioProvider: ObservableObject, AudioDataProvider {
    @Published var frequency: Double = 432.0  // Doğal frekans
    @Published var amplitude: Double = 1.0
    @Published var waveform: [Double] = []
    @Published var isPlaying: Bool = false
    
    // Özel ses işleme mantığınızı buraya ekleyin
    func updateAudioData() {
        // Ses verisi güncelleme
    }
}
```

### Meditasyon Uygulaması Örneği

```swift
struct MeditationApp: View {
    @StateObject private var audioData = LiveAudioData()
    @State private var selectedPalette: MeditationColorPalette = .zen
    @State private var selectedVisualizer: MeditationSoundCanvasView.MeditationVisualizerType = .mandala
    
    var body: some View {
        ZStack {
            // Arka plan gradyanı
            LinearGradient(
                colors: [selectedPalette.secondary, selectedPalette.primary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Meditasyon görselleştirici
                MeditationSoundCanvasView(
                    audioData: audioData,
                    visualizerType: selectedVisualizer,
                    palette: selectedPalette,
                    backgroundColor: .clear
                )
                .frame(height: 400)
                
                // Kontrol paneli
                HStack(spacing: 20) {
                    Button("Başlat") {
                        audioData.startRecording()
                    }
                    .disabled(audioData.isPlaying)
                    .buttonStyle(.borderedProminent)
                    
                    Button("Durdur") {
                        audioData.stopRecording()
                    }
                    .disabled(!audioData.isPlaying)
                    .buttonStyle(.bordered)
                }
                
                // Görselleştirici seçici
                Picker("Görselleştirici", selection: $selectedVisualizer) {
                    Text("Mandala").tag(MeditationSoundCanvasView.MeditationVisualizerType.mandala)
                    Text("Fraktal").tag(MeditationSoundCanvasView.MeditationVisualizerType.fractal)
                    Text("Simetrik").tag(MeditationSoundCanvasView.MeditationVisualizerType.symmetric)
                    Text("Zen").tag(MeditationSoundCanvasView.MeditationVisualizerType.zen)
                    Text("Kozmik").tag(MeditationSoundCanvasView.MeditationVisualizerType.cosmic)
                }
                .pickerStyle(.segmented)
                
                // Renk paleti seçici
                Picker("Tema", selection: $selectedPalette) {
                    Text("Zen").tag(MeditationColorPalette.zen)
                    Text("Gün Batımı").tag(MeditationColorPalette.sunset)
                    Text("Okyanus").tag(MeditationColorPalette.ocean)
                    Text("Lavanta").tag(MeditationColorPalette.lavender)
                    Text("Altın").tag(MeditationColorPalette.golden)
                    Text("Kozmik").tag(MeditationColorPalette.cosmic)
                }
                .pickerStyle(.wheel)
            }
            .padding()
        }
    }
}
```

### Animasyon Özelleştirme

```swift
WaveformVisualizer(audioData: audioData)
    .animation(.easeInOut(duration: 0.2), value: audioData.waveform)
```

## 📱 Platform Desteği

| Platform | Minimum Sürüm | Durum |
|----------|---------------|-------|
| iOS | 13.0+ | ✅ Destekleniyor |
| macOS | 10.15+ | ✅ Destekleniyor |
| tvOS | 13.0+ | ✅ Destekleniyor |
| watchOS | 6.0+ | ✅ Destekleniyor |

## 🔒 İzinler

### iOS/macOS Mikrofon İzni

`Info.plist` dosyanıza aşağıdaki izinleri ekleyin:

```xml
<!-- iOS -->
<key>NSMicrophoneUsageDescription</key>
<string>Ses görselleştirmesi için mikrofon erişimi gereklidir.</string>

<!-- macOS -->
<key>NSMicrophoneUsageDescription</key>
<string>Ses görselleştirmesi için mikrofon erişimi gereklidir.</string>
```

## 🧪 Test

Kütüphaneyi test etmek için:

```bash
swift test
```

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## 📞 İletişim

- **GitHub**: [@developersailor](https://github.com/developersailor)
- **Email**: mehmetfiskindal@gmail.com

## 🙏 Teşekkürler

- SwiftUI ekibine modern UI framework için
- AVFoundation ekibine ses işleme API'leri için
- Tüm katkıda bulunanlara

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! 