# 👁️ ABSAR (أَبْصَار) — Next-Gen AI Vision for Classroom Attendance

<div align="center">

![ABSAR Release](https://img.shields.io/badge/Release-ABSAR--Face--Attendance.apk-00C853?style=for-the-badge&logo=android&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![InsightFace](https://img.shields.io/badge/InsightFace-ArcFace%20Buffalo__L-FF6F00?style=for-the-badge&logo=scikitlearn&logoColor=white)
![Google ML Kit](https://img.shields.io/badge/Google%20ML%20Kit-Live%20Vision-4285F4?style=for-the-badge&logo=google&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-WAL%20Mode-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

<p align="center">
  <h3><b>"Satu Jepretan Kelas Tanpa Titip Absen"</b></h3>
  <b>Solusi Mutakhir Presensi Kelas Cepat, Akurat, dan Berkeadilan Menggunakan Deep Learning Multi-Face Recognition, Live Sensor HUD (X, Y, Z), Auto-Capture Hands-Free, dan Gamifikasi Poin Disiplin Santri.</b>
</p>

</div>

---

## 📌 Daftar Isi
1. [Ringkasan Eksekutif & Filosofi Nama](#-ringkasan-eksekutif--filosofi-nama)
2. [Fitur-Fitur Unggulan ABSAR](#-fitur-fitur-unggulan-absar)
3. [Live Sensor HUD X, Y, Z & Auto-Capture](#-live-sensor-hud-x-y-z--auto-capture)
4. [Live Multi-Face Classroom Detection](#-live-multi-face-classroom-detection)
5. [Arsitektur Sistem & Alur Pengenalan Wajah](#-arsitektur-sistem--alur-pengenalan-wajah)
6. [Galeri Demo & Tampilan Antarmuka](#-galeri-demo--tampilan-antarmuka)
7. [Panduan Penggunaan (Ustadz & Santri)](#-panduan-penggunaan-ustadz--santri)
8. [Panduan Instalasi & Menjalankan Sistem](#-panduan-instalasi--menjalankan-sistem)
9. [Mode Konektivitas Jaringan (USB vs Wi-Fi LAN)](#-mode-konektivitas-jaringan-usb-vs-wi-fi-lan)
10. [Dokumentasi Endpoint RESTful API Backend](#-dokumentasi-endpoint-restful-api-backend)
11. [Struktur Repositori](#-struktur-repositori)
12. [Lisensi & Tim Pengembang](#-lisensi--tim-pengembang)

---

## 💡 Ringkasan Eksekutif & Filosofi Nama

Presensi konvensional secara manual di ruang halaqah, ma'had, madrasah, maupun perkuliahan seringkali memakan waktu berharga ustadz/pengajar (10–15 menit per sesi) serta rentan terhadap manipulasi "titip absen". 

**ABSAR** diangkat dari akar kata bahasa Arab ***Abshār* (أَبْصَار)** yang bermakna **"penglihatan mendalam / pandangan batin yang tajam"**, kemudian diintegrasikan dengan teknologi *Computer Vision* dan *Edge AI* mutakhir:
* 📸 **Hanya Butuh 1–2 Kali Jepret Foto Kelas**: Ustadz cukup mengarahkan kamera ke ruang kelas/halaqah.
* ⚡ **Batch Multi-Face AI Recognition**: Mesin deep learning *InsightFace Buffalo_L* mendeteksi puluhan wajah sekaligus dalam citra beresolusi tinggi, mengekstrak vektor *ArcFace* 512 dimensi, dan mencocokkannya ke database secara instan.
* 🎯 **Algoritma Hungarian Bipartite Matching**: Menjamin tidak ada santri ganda yang terabsensi pada dua wajah berdekatan (optimal global assignment).
* 🧭 **Live Sensor HUD X, Y, Z (Edge ML Kit)**: Memandu registrasi 5 pose wajah santri dengan visualisasi sudut kemiringan live, status akurasi *Dapat* vs *Target*, dan penjepretan otomatis (*Hands-Free Auto-Capture*).
* 🟢 **Lingkaran Wajah Live Kelas (*Live Face Circles*)**: Kamera kelas ustadz dilengkapi pelacakan multi-wajah live stream dengan indikator visual dinamis dan penghitung wajah otomatis.
* 🏆 **Sistem Poin Disiplin & Papan Peringkat**: Mengintegrasikan gamifikasi reward (+10 poin hadir, -10 poin jika alpa) yang terpantau pada Leaderboard kelas santri.
* 🛡️ **Kemandirian Infrastruktur Offline (Zero Internet Dependency)**: Dapat berjalan 100% lokal melalui kabel USB Reverse Tunnel atau jaringan Wi-Fi LAN tanpa khawatir kuota maupun firewall lembaga.

---

## 🚀 Fitur-Fitur Unggulan ABSAR

* 🔒 **Tampilan Bersih Siap Produksi (Production Ready)**: Antarmuka bersih tanpa kartu dummy atau bypass prototype. Seluruh autentikasi santri dan ustadz menggunakan hashing keamanan modern.
* 🧭 **Live Sensor HUD (Sumbu X, Y, Z)**:
  * **Sumbu X (Pitch)**: Evaluasi sudut menunduk / mendongak.
  * **Sumbu Y (Yaw)**: Evaluasi sudut menengok kiri / kanan.
  * **Sumbu Z (Roll & Jarak)**: Evaluasi kemiringan kepala dan jarak kedalaman wajah ke lensa kamera.
  * **Status Real-time**: Menampilkan nilai terbaca (*Dapat*) berdampingan dengan nilai target (*Target*) beserta badge `[PAS]` atau `[SESUAIKAN]`.
* ⚡ **Auto-Capture Hands-Free**: Saat ketiga sumbu X, Y, Z terpenuhi dan posisi wajah terkunci (`TERKUNCI`), sistem menjalankan countdown animasi ~0.8 detik dan menjepret foto otomatis tanpa harus menyentuh tombol. Shutter manual tetap tersedia kapan saja.
* 🔄 **Dukungan Kamera Depan & Belakang**: Tombol flip kamera instan pada pendaftaran selfie santri maupun pemotretan kelas oleh ustadz.
* 🟢 **Pelacakan Multi-Wajah Live Kelas (*Live Face Circles*)**: Kamera kelas ustadz secara langsung menampilkan lingkaran target neon emerald pada setiap santri yang terdeteksi di ruang kelas beserta chip penghitung live (`Live AI: X Wajah Terdeteksi`).
* 📸 **Batch Multi-Face InsightFace Engine**: Mampu mengenali puluhan wajah santri sekaligus dalam satu kali foto ruangan kelas.
* 🎯 **Algoritma Hungarian (Bipartite Graph Matching)**: Optimasi penugasan wajah global untuk akurasi pencocokan 1-to-1 yang adil tanpa duplikasi.
* 🔄 **Merge-Max Multi-Capture (Hingga 5 Sudut Foto)**: Ustadz dapat mengambil foto dari berbagai sudut (depan, kiri, kanan, tengah). Sistem secara otomatis menggabungkan skor kemiripan tertinggi (*highest similarity score*) dari tiap santri.
* 📶 **Konektivitas Fleksibel Ganda (USB & Wi-Fi)**:
  * **Mode USB Reverse Tunnel**: 100% offline tanpa internet, tahan blokir firewall kampus/ma'had.
  * **Mode Wi-Fi Direct LAN**: Komunikasi nirkabel penuh melalui jaringan lokal berkecepatan tinggi.

---

## 🧭 Live Sensor HUD X, Y, Z & Auto-Capture

Pada modul pendaftaran 5-pose santri (`capture_screen.dart`), pengguna dipandu oleh modul visual sensor cerdas:

```text
┌────────────────────────────────────────────────────────┐
│  ● LIVE SENSOR HUD (X, Y, Z)            [🔒 TERKUNCI]  │
├────────────────────────────────────────────────────────┤
│  ↕ X (Pitch)   Dapat: +2°    Target: ±15°      [ PAS ] │
│  ↔ Y (Yaw)     Dapat: -1°    Target: ±15°      [ PAS ] │
│  ⤢ Z (Roll/Jrk) Dapat: 0°|28% Target: Roll±18° [ PAS ] │
├────────────────────────────────────────────────────────┤
│  [=======================] 100%                        │
│  Posisi Sempurna! Otomatis mengambil foto dalam 0.8s...│
└────────────────────────────────────────────────────────┘
```

1. **Sumbu X (Pitch)**: Mendeteksi sudut elevasi kepala (menunduk/mendongak).
2. **Sumbu Y (Yaw)**: Mendeteksi sudut azimut kepala (menoleh kiri/kanan).
3. **Sumbu Z (Roll & Distance)**: Mendeteksi kemiringan lateral dan rasio jarak kedalaman wajah terhadap bidang tangkap kamera.
4. **Indikator Cincin Shutter**: Lingkaran luar tombol shutter berputar mengisi progres hijau saat posisi terkunci hingga capture tereksekusi otomatis.

---

## 👥 Live Multi-Face Classroom Detection

Pada kamera presensi kelas ustadz (`attendance_camera_screen.dart`), sistem mengalirkan *Live Camera Stream* dengan pemrosesan frame berkecepatan tinggi via Google ML Kit:
* Setiap wajah santri di kelas secara *real-time* diberi lingkaran target visual dinamis.
* Chip info live menampilkan jumlah santri yang tertangkap di bidang pandang: `Live AI: N Wajah Terdeteksi`.
* Ustadz dapat menekan tombol shutter saat komposisi kelas sudah optimal untuk dikirim ke backend InsightFace.

---

## 🏗️ Arsitektur Sistem & Alur Pengenalan Wajah

Sistem memadukan komputasi ringan di sisi perangkat bergerak (*Client-Side Edge AI*) dengan kecerdasan komputasi mendalam di sisi server (*Server-Side Deep Learning*):

```mermaid
flowchart TD
    subgraph MobileApp [Aplikasi Mobile Flutter (ABSAR Client)]
        A[Buka Sesi Presensi] --> B[Kamera Presensi Kelas]
        B -->|Live Frame Stream| B1[ML Kit Live Circles: Multi-Face Tracking]
        B --> C[Kompresi EXIF & SHA-256 Hashing]
        C --> D[Kirim POST /attendance/recognize]
        H[Terima Hasil JSON] --> I[Render Bounding Box & Label AI Santri]
        I --> J[Finalisasi Sesi Presensi]
    end

    subgraph BackendServer [Server AI FastAPI (ABSAR Engine)]
        D --> E[Decode Citra & InsightFace Detection]
        E --> F[Ekstraksi 512-D ArcFace Embeddings]
        F --> G[Hungarian Bipartite Matching vs Database]
        G --> H
        J --> K[Update Status Hadir & Perhitungan Poin Disiplin]
        K --> L[(Database SQLite: presensi.db)]
    end
```

---

## 📱 Galeri Demo & Tampilan Antarmuka

| 1. Login ABSAR | 2. Live Sensor HUD X,Y,Z | 3. Live Deteksi Kelas | 4. Hasil AI Recognition |
| :---: | :---: | :---: | :---: |
| <img src="docs/images/01_home_menu.png" width="210" alt="Login ABSAR"/> | <img src="docs/images/03_camera_viewfinder.png" width="210" alt="HUD Sensor"/> | <img src="docs/images/04_ai_recognition_result.png" width="210" alt="Kamera Kelas"/> | <img src="docs/images/04_ai_recognition_result.png" width="210" alt="Hasil AI"/> |
| *Antarmuka login resmi bertema ABSAR, aman & siap produksi.* | *Live Sensor HUD X,Y,Z memandu 5 pose wajah santri secara presisi.* | *Lingkaran pelacakan multi-wajah live stream pada ruang halaqah.* | *Kotak hijau identitas santri terverifikasi dengan confidence score.* |

---

## 📖 Panduan Penggunaan (Ustadz & Santri)

### A. Alur Ustadz / Pengajar (Presensi Kelas)
1. **Login Akun Ustadz**: Masukkan email lembaga dan kata sandi akun Anda.
2. **Pilih Sesi Kelas**:
   * Pilih mata pelajaran / halaqah dan nomor pertemuan.
   * Tekan **Mulai Sesi Presensi**.
3. **Ambil Foto Kelas**:
   * Arahkan kamera ke seluruh santri di ruangan belajar.
   * Perhatikan indikator lingkaran live pada wajah-wajah santri yang terdeteksi.
   * Tekan tombol kamera (atau balik ke kamera depan bila diperlukan).
   * *(Opsional)* Ambil hingga 5 sudut pemotretan untuk mencakup seluruh ruangan.
4. **Verifikasi & Finalisasi**:
   * Tinjau bounding box hijau pengenalan AI.
   * Tekan **Selesaikan & Kunci Presensi** untuk mengunci absensi dan mencatat poin santri secara otomatis (+10 Poin hadir / -10 Poin alpa).

### B. Alur Santri (Pendaftaran Wajah Baru)
1. **Buka Menu Registrasi Wajah**:
   * Masukkan **NIS (Nomor Induk Santri)** dan nama lengkap santri.
2. **Ikuti Bimbingan 5 Pose Wajah dengan Sensor HUD**:
   * **Pose 1 (Lurus)**: Wajah tegak lurus menghadap kamera.
   * **Pose 2 (Kiri)**: Tengokkan kepala sedikit ke kiri.
   * **Pose 3 (Kanan)**: Tengokkan kepala sedikit ke kanan.
   * **Pose 4 (Dongak)**: Angkat dagu sedikit ke atas.
   * **Pose 5 (Tunduk)**: Tundukkan kepala sedikit ke bawah.
3. **Auto-Capture Hands-Free**: Sistem akan otomatis menjepret foto begitu sensor X, Y, Z terkunci dan status dinyatakan `[PAS]`.
4. Setelah 5 pose selesai, vektor biometrik 512-dimensi tersimpan di server dan santri siap dideteksi otomatis saat sesi kelas berlangsung.

---

## 💻 Panduan Instalasi & Menjalankan Sistem

### Prasyarat Perangkat:
* **Python**: Versi 3.10 atau 3.11 (disertai virtual environment `.venv`).
* **Flutter SDK**: Versi 3.x (disertai Android SDK & Platform Tools ADB).
* **File APK Rilis Resmi**: `ABSAR-Face-Attendance.apk` (Tersedia langsung di root repositori).

---

### 1. Menjalankan Server Backend (FastAPI)

1. Buka terminal dan masuk ke folder `backend`:
   ```powershell
   cd d:\ABSAR-Face-Attendance\backend
   ```
2. Aktifkan Virtual Environment:
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```
3. Jalankan server:
   ```powershell
   uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```
4. Akses Swagger UI Dokumentasi API:
   👉 **`http://localhost:8000/docs`**

> [!TIP]
> **Cara 1-Klik Instan**: Cukup dobel klik file **`JALANKAN_SERVER.bat`** di direktori utama.

---

### 2. Memasang & Menjalankan Aplikasi Mobile (ABSAR)

* **Opsi A: Memasang APK Otomatis ke HP via Script (Paling Mudah)**
  Hubungkan HP dengan USB Debugging aktif, lalu dobel klik:
  👉 **`INSTALL_KE_HP.bat`**
  *(Skrip akan otomatis meng-install `ABSAR-Face-Attendance.apk`, mengaktifkan jalur USB 8000, dan langsung membuka aplikasi di HP).*

* **Opsi B: Membangun Ulang APK Sendiri (Build Release)**
  Dobel klik:
  👉 **`BUILD_APK.bat`**
  *(Skrip akan mengompilasi Flutter release, menyalin output APK resmi, memasangnya ke HP, dan menyalakan backend secara simultan).*

* **Opsi C: Menjalankan Mode Pengembangan (Debug Mode)**
  ```powershell
  cd d:\ABSAR-Face-Attendance\mobile
  flutter pub get
  flutter run
  ```

---

## 🔌 Mode Konektivitas Jaringan (USB vs Wi-Fi LAN)

Aplikasi memiliki menu konfigurasi alamat IP backend yang dapat diakses melalui ikon gerigi ⚙️ di pojok kanan atas layar login.

---

### ⚡ Opsi 1: Mode USB Kabel (Paling Stabil & 100% Offline)
Sangat ideal untuk ruangan kelas atau ma'had yang tidak memiliki akses internet, atau jaringan Wi-Fi yang menerapkan *AP Client Isolation*:

1. Jalankan server backend: dobel klik **`JALANKAN_SERVER.bat`**.
2. Hubungkan HP ke laptop dengan kabel data USB (USB Debugging aktif).
3. Sambungkan jalur port USB: dobel klik **`HUBUNGKAN_USB.bat`**.
4. Di aplikasi HP: Buka menu Pengaturan Server (⚙️) -> masukkan `http://127.0.0.1:8000` -> Tekan **Simpan & Tes Koneksi**.

---

### 📶 Opsi 2: Mode Wi-Fi Lokal / LAN (Nirkabel Penuh)
Cocok digunakan jika laptop dan HP terhubung pada satu jaringan Wi-Fi / Hotspot lokal yang sama:

1. Jalankan **`JALANKAN_SERVER.bat`**.
2. Jendela terminal secara otomatis mendeteksi dan menampilkan IP Wi-Fi laptop Anda, contoh:
   ```text
   Alamat URL Server untuk Aplikasi HP:
     [1] Mode USB Kabel : http://127.0.0.1:8000  (Statis)
     [2] Mode Wi-Fi     : http://192.168.1.15:8000 (Terdeteksi Otomatis!)
   ```
3. Di HP Anda: Buka Pengaturan Server (⚙️) -> masukkan URL Wi-Fi di atas -> Tekan **Simpan & Tes Koneksi**.

---

## 📡 Dokumentasi Endpoint RESTful API Backend

| Metode | Endpoint | Deskripsi | Status Sukses |
| :---: | :--- | :--- | :---: |
| `GET` | `/health` | Pemeriksaan kesehatan server & status model InsightFace | `200 OK` |
| `POST` | `/auth/login` | Autentikasi akun Ustadz / Santri (SHA-256 Auth) | `200 OK` |
| `POST` | `/auth/register` | Pendaftaran akun baru (Ustadz / Santri) | `201 Created` |
| `GET` | `/classes` | Mengambil daftar seluruh kelas / halaqah aktif | `200 OK` |
| `POST` | `/classes` | Membuat kelas baru dengan kode & jadwal | `201 Created` |
| `POST` | `/classes/{id}/roster/csv` | Impor data roster santri massal via file CSV | `200 OK` |
| `GET` | `/students/lookup` | Verifikasi keberadaan NIS santri di dalam database | `200 OK` |
| `POST` | `/students/{id}/faces` | Mendaftarkan 5 vektor biometrik pose wajah santri | `201 Created` |
| `POST` | `/sessions` | Membuka sesi presensi kelas baru | `201 Created` |
| `GET` | `/sessions/{id}` | Mengambil data kehadiran sesi real-time | `200 OK` |
| `POST` | `/attendance/recognize` | Ekstraksi InsightFace multi-wajah & pencocokan Hungarian | `200 OK` |
| `POST` | `/sessions/{id}/finalize` | Menutup sesi, mengunci kehadiran, dan kalkulasi poin | `200 OK` |
| `GET` | `/points?class_id={id}` | Leaderboard peringkat kedisiplinan santri per kelas | `200 OK` |

---

## 📁 Struktur Repositori

```text
ABSAR-Face-Attendance/
├── ABSAR-Face-Attendance.apk       # File APK Rilis Resmi Siap Pasang Android
├── BUILD_APK.bat                   # 1-Klik Build APK & Jalankan Sistem Terpadu
├── INSTALL_KE_HP.bat               # 1-Klik Pasang APK ke HP via USB ADB
├── JALANKAN_SERVER.bat             # 1-Klik Jalankan Backend FastAPI + Deteksi IP
├── HUBUNGKAN_USB.bat               # 1-Klik Hubungkan Port USB (ADB Reverse Tunnel)
├── backend/                        # Layanan Backend AI (Python / FastAPI)
│   ├── app/
│   │   ├── core/                   # Konfigurasi, Database Engine, & Keamanan
│   │   ├── models/                 # Model Tabel SQLAlchemy ORM
│   │   ├── routers/                # Endpoint API (Attendance, Auth, Classes, Points, Students)
│   │   ├── schemas/                # Skema Validasi Pydantic
│   │   ├── services/               # Mesin InsightFace AI ArcFace & Algoritma Hungarian
│   │   └── main.py                 # Titik Masuk Utama FastAPI
│   ├── .env                        # Hyperparameter Ambang Batas Deteksi Wajah
│   ├── presensi.db                 # Database SQLite Utama (Mode WAL)
│   ├── requirements.txt            # Dependensi Pustaka Python
│   └── reset_db.py                 # Utilitas Pembersih & Reset Database
├── docs/                           # Dokumentasi & Berkas Lomba Resmi
│   ├── images/                     # Tangkapan Layar Demo Antarmuka Aplikasi
│   ├── PROPOSAL_INOVASI_LOMBA_ABSAR.md # Dokumen Proposal & Pitch Deck Lomba
│   ├── DESIGN SPEC ... .md         # Spesifikasi Arsitektur Sistem Terpadu
│   └── MANUAL_BOOK_PANDUAN ... .md # Buku Panduan Penggunaan Resmi Ustadz & Santri
├── mobile/                         # Aplikasi Klien Android (Flutter / Dart)
│   ├── lib/
│   │   ├── app/                    # Routing, Tema Luxury, & State Riverpod
│   │   ├── core/                   # Utilitas Kualitas Citra, EXIF, & Client Dio
│   │   ├── features/
│   │   │   ├── attendance/         # Kamera Kelas Live Circles & Hasil Deteksi AI
│   │   │   ├── auth/               # Autentikasi Ustadz & Santri
│   │   │   ├── classes/            # Manajemen Halaqah, Roster, & Papan Peringkat
│   │   │   ├── dosen/              # Antarmuka Khusus Dashboard Ustadz
│   │   │   ├── mahasiswa/          # Antarmuka Khusus Portal Santri
│   │   │   ├── registration/       # Registrasi 5 Pose dengan Live Sensor HUD (X, Y, Z)
│   │   │   └── settings/           # Konfigurasi IP Backend & Pilihan Jaringan
│   │   └── main.dart               # Titik Masuk Utama Aplikasi Flutter
│   └── pubspec.yaml                # Dependensi Mobile Flutter
├── .gitignore                      # Konfigurasi Eksklusi File Git
└── README.md                       # Dokumentasi Resmi Proyek
```

---

## 📄 Lisensi & Tim Pengembang

Proyek inovasi ini dikembangkan dan dirancang sebagai platform presensi cerdas terpadu berbasis kecerdasan buatan (*Artificial Intelligence*) untuk meningkatkan transparansi dan kedisiplinan lembaga pendidikan:

* **Ketua Tim & Pengembang**: Asyam Sakhi Maulana (240535600363)
* **Anggota Tim & Pengembang**: Emil Mustafidul Walida Ismani
 (240342604456)
* **Institusi Asal**: S1 Teknik Informatika dan S1 Biologi Fakultas Teknik dan Fakultas MIPA, Universitas Negeri Malang (UM)
* **Lisensi**: Terdistribusi di bawah lisensi terbuka [MIT License](LICENSE).

<div align="center">
  <sub><b>ABSAR (أَبْصَار)</b> — <i>"Satu Jepretan Kelas Tanpa Titip Absen"</i> • Memajukan Efisiensi dan Kejujuran Akademik Berbasis Edge AI.</sub>
</div>
