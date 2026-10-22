# QuizMate – Aplikasi Kuis Pilihan Ganda

---

## 👤 Identitas Mahasiswa

| | |
|---|---|
| **Nama** | Fadly Hudaya Simanjuntak |
| **NIM** | 241401017 |
| **Lab** | LAB 3 Pemrograman Mobile |

---

## 📱 Informasi Aplikasi

### Nama Aplikasi
**QuizMate** – Kuis Pilihan Ganda

### Deskripsi Singkat
QuizMate adalah aplikasi kuis pilihan ganda berbasis Flutter yang dirancang untuk mahasiswa Fasilkom-TI USU. Aplikasi ini memungkinkan pengguna mengerjakan soal dari tiga mata kuliah dengan timer per soal, menampilkan hasil akhir beserta statistik, dan menyimpan riwayat kuis yang telah diselesaikan. Aplikasi mendukung tampilan responsif di berbagai ukuran layar (mobile, tablet, dan web/desktop) serta mendukung dark mode.

### Fitur-Fitur yang Tersedia

#### Fitur Wajib
- **Input Identitas Peserta** — Pengguna mengisi nama lengkap dan NIM sebelum memulai kuis
- **Pilih Mata Kuliah** — Tersedia 3 mata kuliah: Pemrograman Mobile, Jaringan Komputer, dan Kriptografi
- **Kuis Pilihan Ganda** — Setiap mata kuliah memiliki 10 soal pilihan ganda (A–D)
- **Timer per Soal** — Setiap soal diberi waktu 30 detik; jika habis, soal dihitung salah otomatis
- **Feedback Jawaban** — Jawaban benar/salah ditampilkan langsung setelah memilih opsi
- **Hasil Akhir** — Menampilkan skor, jumlah benar/salah, akurasi, dan informasi peserta
- **Riwayat Kuis** — Semua hasil kuis tersimpan dan dapat dilihat di halaman Histori

#### Fitur Tambahan
- **Mata Kuliah Favorit** — Pengguna dapat menandai mata kuliah favorit dengan ikon bintang di halaman Beranda, lalu mengakses dan langsung memulai kuis dari halaman Favorit
- **Dark Mode** — Toggle tema terang/gelap tersedia di semua halaman via tombol di header
- **Responsif Multi-Platform** — Layout adaptif untuk portrait, landscape, tablet, dan web/desktop menggunakan `NavigationRail` sebagai sidebar di layar lebar
- **Animasi Splash Screen** — Animasi logo, teks, dan loading dots saat aplikasi pertama kali dibuka
- **Animasi Transisi** — Setiap perpindahan halaman dan perubahan state menggunakan animasi halus

---

## 📂 Struktur Proyek

```
lib/
├── data/
│   └── quiz_data.dart          # Bank soal & data mata kuliah
├── models/
│   ├── question.dart           # Model soal
│   └── quiz_result.dart        # Model hasil kuis
├── providers/
│   └── quiz_provider.dart      # State management (InheritedWidget + ChangeNotifier)
├── screens/
│   ├── splash_screen.dart      # Halaman splash animasi
│   ├── main_screen.dart        # Bottom nav / NavigationRail utama
│   ├── home_screen.dart        # Beranda: input identitas & pilih matkul
│   ├── quiz_screen.dart        # Halaman kuis & timer
│   ├── result_screen.dart      # Halaman hasil kuis
│   ├── favorites_screen.dart   # Halaman mata kuliah favorit
│   └── history_screen.dart     # Halaman riwayat kuis
├── utils/
│   └── responsive.dart         # Helper responsivitas (cw, ch, constrain, dll.)
└── widgets/
    ├── answer_option_card.dart  # Kartu pilihan jawaban
    ├── custom_button.dart       # Tombol reusable
    ├── progress_indicator_bar.dart # Progress bar soal
    ├── subject_card.dart        # Kartu pemilihan mata kuliah + tombol favorit
    └── theme_toggle_button.dart # Tombol toggle dark/light mode
```

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK `^3.13.3`
- Dart SDK yang sesuai
- Emulator Android / iOS, browser Chrome, atau Windows desktop

### Langkah

```bash
# 1. Clone repository
git clone <url-repository>
cd testuts

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator mobile
flutter run

# 4. Jalankan di browser (web)
flutter run -d chrome

# 5. Jalankan di Windows desktop
flutter run -d windows
```

---

## 🖼️ Screenshot Aplikasi

### Splash Screen
> *Tambahkan screenshot splash screen*

### Beranda (Home)
> *Tambahkan screenshot halaman beranda (portrait & landscape)*

### Kuis
> *Tambahkan screenshot halaman kuis berjalan*

### Hasil Kuis
> *Tambahkan screenshot halaman hasil*

### Favorit
> *Tambahkan screenshot halaman favorit (berisi & kosong)*

### Riwayat
> *Tambahkan screenshot halaman riwayat*

### Tampilan Tablet / Web
> *Tambahkan screenshot tampilan di layar lebar (NavigationRail)*

---

## 🎨 Dokumentasi

### Credit Aset
| Aset | Sumber |
|---|---|
| Icon aplikasi (`app_logo.png`) | Dibuat sendiri / [sesuaikan dengan sumber asli] |
| Font **Poppins** | [Google Fonts](https://fonts.google.com/specimen/Poppins) – SIL Open Font License |
| Ikon Material | [Material Symbols](https://fonts.google.com/icons) – Apache License 2.0 |
| Framework | [Flutter](https://flutter.dev) – BSD 3-Clause License |

### Link Mockup / Prototype
> [Tambahkan link Figma / Adobe XD / mockup aplikasi]

### Link Video Presentasi
> [Tambahkan link Google Drive video presentasi (maks. 10 menit)]

---

## 🔄 Alur Kerja Aplikasi

```
Splash Screen
    └──► Beranda
            ├── Isi Nama & NIM
            ├── Pilih Mata Kuliah (tap bintang untuk favorit)
            └── Mulai Kuis
                    └──► Halaman Kuis (10 soal, timer 30 detik/soal)
                                └──► Hasil Kuis
                                        ├── Lihat Riwayat ──► Tab Histori
                                        └── Kembali ke Beranda

Tab Favorit
    └──► Tap kartu matkul ──► Langsung mulai kuis

Tab Histori
    └──► Tabel riwayat semua sesi kuis
```

---

## 🧰 Teknologi yang Digunakan

| Teknologi | Keterangan |
|---|---|
| **Flutter** | Framework UI cross-platform |
| **Dart** | Bahasa pemrograman |
| **InheritedWidget + ChangeNotifier** | State management tanpa library eksternal |
| **Material Design 3** | Sistem desain UI |
| **MediaQuery** | Deteksi ukuran layar untuk responsivitas |

---

*UTS Pemrograman Mobile – Fasilkom-TI USU – 2026*
