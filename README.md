## APLIKASI KUIS PILIHAN GANDA ##
QuizMate — Aplikasi Kuis Pilihan Ganda
QuizMate adalah aplikasi kuis pilihan ganda berbasis Flutter dan Dart untuk membantu mahasiswa berlatih soal dari beberapa mata kuliah. Aplikasi menyediakan pengerjaan kuis dengan batas waktu, penilaian otomatis, ringkasan hasil, serta halaman favorit dan riwayat kuis.
👨‍🎓 Identitas Mahasiswa
Informasi	Detail
Nama	Fadly Hudaya Simanjuntak
NIM	241401017
Laboratorium	LAB 3 Pemrograman Mobile
Program Studi	S1 Ilmu Komputer
Universitas	Universitas Sumatera Utara (USU)


📱 Informasi Aplikasi
Deskripsi
QuizMate dirancang dengan antarmuka yang sederhana dan responsif. Pengguna dapat memasukkan identitas, memilih mata kuliah, menjawab soal pilihan ganda, lalu melihat nilai dan statistik pengerjaan. Aplikasi juga menyediakan tema terang dan gelap serta tata letak yang menyesuaikan ukuran layar.
Mata Kuliah
Saat ini tersedia tiga kategori kuis:
1. Pemrograman Mobile — dasar Flutter dan pengembangan aplikasi mobile.
2. Jaringan Komputer — konsep protokol dan arsitektur jaringan.
3. Kriptografi — konsep enkripsi dan keamanan data.
Setiap kategori berisi 10 soal pilihan ganda dengan empat pilihan jawaban.
Fitur Utama
- Input identitas peserta — memasukkan nama dan NIM sebelum mengerjakan kuis.
- Pilihan mata kuliah — memilih salah satu dari tiga kategori kuis.
- Kuis pilihan ganda — menjawab soal dengan pilihan A–D.
- Timer soal — setiap soal memiliki batas waktu 30 detik; soal yang kehabisan waktu dihitung salah.
- Umpan balik jawaban — aplikasi memberikan indikasi jawaban setelah pengguna memilih opsi.
- Hasil kuis — menampilkan skor, jumlah jawaban benar dan salah, akurasi, serta identitas peserta.
- Favorit — menandai mata kuliah dengan ikon bintang dan mengaksesnya melalui halaman Favorit.
- Riwayat kuis — melihat hasil pengerjaan kuis sebelumnya selama aplikasi berjalan.
- Dark mode — beralih antara tema terang dan gelap.
- Tampilan responsif — menyesuaikan tata letak untuk layar kecil maupun lebar; layar lebar dapat menggunakan NavigationRail.
- Splash screen dan transisi — animasi pembuka dan transisi antartampilan.
Catatan penyimpanan: berdasarkan implementasi saat ini, data riwayat dan favorit dikelola di memori aplikasi. Data tersebut belum disimpan secara permanen ke database atau penyimpanan lokal.

🧭 Alur Penggunaan
1. Buka aplikasi dan tunggu Splash Screen.
2. Pada halaman Beranda, masukkan nama dan NIM.
3. Pilih mata kuliah yang ingin dikerjakan.
4. Jawab setiap soal sebelum timer 30 detik berakhir.
5. Setelah kuis selesai, periksa skor dan statistik pada halaman Hasil.
6. Buka tab Favorit untuk mengakses mata kuliah yang ditandai.
7. Buka tab Riwayat untuk melihat hasil kuis yang tercatat selama aplikasi berjalan.
🛠️ Teknologi yang Digunakan
Teknologi	Kegunaan
Flutter	Framework untuk membangun antarmuka aplikasi
Dart	Bahasa pemrograman
Material Design 3	Sistem desain komponen UI
InheritedWidget	Menyediakan state kuis ke widget turunannya
ChangeNotifier	Memberi tahu UI ketika state berubah
MediaQuery / helper responsif	Membantu menyesuaikan layout dengan ukuran layar


Aplikasi tidak menggunakan layanan backend atau database eksternal pada implementasi saat ini.
