import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';

// ─── Data soal per mata kuliah ───────────────────────────────────────────────

const List<String> subjects = [
  'Pemrograman Mobile',
  'Jaringan Komputer',
  'Kriptografi',
];

// Menggunakan IconData bukan emoji
const Map<String, IconData> subjectIcons = {
  'Pemrograman Mobile': Icons.smartphone_rounded,
  'Jaringan Komputer': Icons.lan_rounded,
  'Kriptografi': Icons.lock_rounded,
};

// Warna aksen per mata kuliah
const Map<String, Color> subjectColors = {
  'Pemrograman Mobile': Color(0xFF6C63FF),
  'Jaringan Komputer': Color(0xFF0097A7),
  'Kriptografi': Color(0xFF43A047),
};

const Map<String, String> subjectDescriptions = {
  'Pemrograman Mobile': '10 soal seputar Flutter & mobile dev',
  'Jaringan Komputer': '10 soal seputar protokol & arsitektur jaringan',
  'Kriptografi': '10 soal seputar enkripsi & keamanan data',
};

const Map<String, List<Question>> questionBank = {
  'Pemrograman Mobile': [
    Question(
      questionText: 'Widget Flutter yang tidak memiliki state internal disebut?',
      options: ['StatefulWidget', 'StatelessWidget', 'InheritedWidget', 'ProviderWidget'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Fungsi setState() pada StatefulWidget digunakan untuk?',
      options: [
        'Menghapus widget dari tree',
        'Memberitahu Flutter untuk rebuild UI',
        'Menginisialisasi state pertama kali',
        'Menavigasi ke halaman lain',
      ],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Package manager resmi yang digunakan Flutter adalah?',
      options: ['npm', 'gradle', 'pub', 'maven'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Bahasa pemrograman yang digunakan Flutter adalah?',
      options: ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Widget yang digunakan untuk menampilkan daftar item yang bisa di-scroll adalah?',
      options: ['Column', 'Row', 'ListView', 'Stack'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'MediaQuery.of(context).size digunakan untuk?',
      options: [
        'Mendapatkan ukuran font',
        'Mendapatkan ukuran layar perangkat',
        'Mengatur tema aplikasi',
        'Membaca data dari storage',
      ],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Navigator.push() pada Flutter digunakan untuk?',
      options: [
        'Kembali ke halaman sebelumnya',
        'Menutup aplikasi',
        'Berpindah ke halaman baru',
        'Menampilkan dialog',
      ],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Widget yang menjadi akar (root) dari semua widget Flutter adalah?',
      options: ['Scaffold', 'MaterialApp', 'Container', 'Center'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Hot reload pada Flutter berguna untuk?',
      options: [
        'Mereset state aplikasi sepenuhnya',
        'Merestart emulator',
        'Melihat perubahan UI tanpa kehilangan state',
        'Mengcompile ulang seluruh kode',
      ],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Widget Flutter yang digunakan untuk membuat tampilan kartu adalah?',
      options: ['Container', 'Card', 'Box', 'Panel'],
      correctIndex: 1,
    ),
  ],
  'Jaringan Komputer': [
    Question(
      questionText: 'OSI Model terdiri dari berapa layer?',
      options: ['5', '6', '7', '8'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Protokol yang digunakan untuk mengirim email adalah?',
      options: ['HTTP', 'FTP', 'SMTP', 'DNS'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Kepanjangan dari IP dalam jaringan komputer adalah?',
      options: ['Internet Protocol', 'Internal Process', 'Input Protocol', 'Interface Point'],
      correctIndex: 0,
    ),
    Question(
      questionText: 'Port default untuk protokol HTTPS adalah?',
      options: ['80', '21', '443', '22'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Perangkat yang menghubungkan dua jaringan berbeda dan meneruskan paket data disebut?',
      options: ['Switch', 'Hub', 'Router', 'Repeater'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Protokol TCP berbeda dengan UDP karena TCP bersifat?',
      options: ['Lebih cepat', 'Connection-oriented', 'Connectionless', 'Tidak reliable'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'DNS berfungsi untuk?',
      options: [
        'Mengamankan koneksi jaringan',
        'Mentranslasi nama domain menjadi IP address',
        'Mengalokasikan IP secara otomatis',
        'Mengirim paket data',
      ],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Layer ke-4 pada OSI model adalah?',
      options: ['Network', 'Session', 'Transport', 'Data Link'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Alamat IP versi 6 (IPv6) terdiri dari berapa bit?',
      options: ['32 bit', '64 bit', '128 bit', '256 bit'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Protokol yang digunakan untuk transfer file antar komputer adalah?',
      options: ['HTTP', 'FTP', 'SMTP', 'ICMP'],
      correctIndex: 1,
    ),
  ],
  'Kriptografi': [
    Question(
      questionText: 'Proses mengubah plaintext menjadi ciphertext disebut?',
      options: ['Dekripsi', 'Hashing', 'Enkripsi', 'Encoding'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Algoritma AES menggunakan ukuran blok sebesar?',
      options: ['64 bit', '128 bit', '256 bit', '512 bit'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Kriptografi kunci publik (asymmetric) menggunakan berapa kunci?',
      options: ['1', '2', '3', '4'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Algoritma RSA termasuk ke dalam jenis kriptografi?',
      options: ['Simetris', 'Hash', 'Asimetris', 'Stream cipher'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Fungsi hash yang menghasilkan output 256-bit adalah?',
      options: ['MD5', 'SHA-1', 'SHA-256', 'SHA-512'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Caesar cipher adalah contoh dari teknik kriptografi?',
      options: ['Transposisi', 'Substitusi', 'Permutasi', 'Difusi'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'SSL/TLS digunakan untuk?',
      options: [
        'Mempercepat koneksi internet',
        'Mengompres data',
        'Mengamankan komunikasi di internet',
        'Mengalokasikan IP address',
      ],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Serangan brute force pada kriptografi berarti?',
      options: [
        'Mencuri kunci enkripsi',
        'Mencoba semua kemungkinan kunci',
        'Memodifikasi pesan yang dikirim',
        'Menyadap komunikasi',
      ],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Digital signature digunakan untuk memastikan?',
      options: [
        'Kerahasiaan pesan',
        'Kecepatan pengiriman',
        'Otentikasi dan integritas pesan',
        'Kompresi data',
      ],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Kunci yang digunakan untuk enkripsi dan dekripsi sama pada kriptografi?',
      options: ['Asimetris', 'Simetris', 'Hibrida', 'Publik'],
      correctIndex: 1,
    ),
  ],
};

// ─── Data dummy riwayat awal ──────────────────────────────────────────────────

final List<QuizResult> dummyHistory = [
  QuizResult(
    userName: 'Budi Santoso',
    nim: '231402001',
    subject: 'Pemrograman Mobile',
    score: 80,
    totalQuestions: 10,
    correctAnswers: 8,
    wrongAnswers: 2,
    finishedAt: DateTime(2026, 10, 1, 10, 30),
  ),
  QuizResult(
    userName: 'Siti Rahayu',
    nim: '231402045',
    subject: 'Jaringan Komputer',
    score: 70,
    totalQuestions: 10,
    correctAnswers: 7,
    wrongAnswers: 3,
    finishedAt: DateTime(2026, 10, 2, 14, 15),
  ),
  QuizResult(
    userName: 'Andi Wijaya',
    nim: '231402078',
    subject: 'Kriptografi',
    score: 90,
    totalQuestions: 10,
    correctAnswers: 9,
    wrongAnswers: 1,
    finishedAt: DateTime(2026, 10, 3, 9, 0),
  ),
  QuizResult(
    userName: 'Dewi Lestari',
    nim: '231402112',
    subject: 'Pemrograman Mobile',
    score: 60,
    totalQuestions: 10,
    correctAnswers: 6,
    wrongAnswers: 4,
    finishedAt: DateTime(2026, 10, 5, 16, 45),
  ),
  QuizResult(
    userName: 'Rizky Pratama',
    nim: '231402055',
    subject: 'Jaringan Komputer',
    score: 100,
    totalQuestions: 10,
    correctAnswers: 10,
    wrongAnswers: 0,
    finishedAt: DateTime(2026, 10, 7, 11, 20),
  ),
];
