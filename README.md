# SoundCanvas 🎵

SwiftUI için geliştirilmiş, ses tınılarını görselleştiren modern bir kütüphane. Farklı ses tınıları farklı görsel efektler üretir ve gerçek zamanlı ses analizi yapabilir.

## 🌟 Özellikler

- **Çoklu Görselleştirme Tipleri**: Dalga formu, spektrum analizi, dairesel dalga, titreşim efekti
- **Gerçek Zamanlı Ses Analizi**: Mikrofon girişinden canlı ses verisi
- **Farklı Dalga Formları**: Sine, kare, testere dişi, üçgen dalga desteği
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
            // Kombine görselleştirici
            SoundCanvasView(
                audioData: audioData,
                visualizerType: .combined,
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

### Görselleştirme Tipleri

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
    frequency: 440.0,
    amplitude: 0.7,
    waveform: sineWave,
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

### SoundCanvasView.VisualizerType

- `.waveform`: Dalga formu görselleştirici
- `.spectrum`: Spektrum analizi
- `.circular`: Dairesel dalga efekti
- `.vibration`: Titreşim parçacık efekti
- `.combined`: Tüm görselleştiricileri birleştirir

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
    @Published var frequency: Double = 440.0
    @Published var amplitude: Double = 1.0
    @Published var waveform: [Double] = []
    @Published var isPlaying: Bool = false
    
    // Özel ses işleme mantığınızı buraya ekleyin
    func updateAudioData() {
        // Ses verisi güncelleme
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

- **GitHub**: [@yourusername](https://github.com/developersailor)
- **Email**: mehmetfiskindal@gmail.com

## 🙏 Teşekkürler

- SwiftUI ekibine modern UI framework için
- AVFoundation ekibine ses işleme API'leri için
- Tüm katkıda bulunanlara

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! 