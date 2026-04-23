# 🤖 Gundam Store — Flutter App

### UAS Mobile Lanjutan | Nama: [ivan darma saputra]

### UAS Mobile Lanjutan | NIM: [1123150135]

# Link Video : [https://youtu.be/9SrefppUjG8]

**Gundam Store** adalah aplikasi e-commerce berbasis Flutter yang dirancang khusus untuk kolektor Model Kit (Gunpla). Proyek ini menerapkan **Clean Architecture** (Domain, Data, Presentation) untuk memastikan kode yang modular, mudah diuji, dan skalabel.

Aplikasi ini menggunakan **Golang** sebagai mesin _backend_ untuk mengelola transaksi dan data katalog, serta mengintegrasikan **Firebase Authentication** untuk sistem keamanan login yang praktis dan handal.

---

## ✨ Fitur Utama

- **Autentikasi Ganda:** Login menggunakan akun email (Firebase Auth) atau integrasi sekali klik dengan **Google Sign-In**.
- **Arsitektur Bersih:** Pemisahan logika bisnis yang ketat menggunakan pola _Clean Architecture_, memudahkan pengembangan fitur di masa depan.
- **Katalog Produk Dinamis:** Dashboard yang menampilkan berbagai grade Gundam (HG, RG, MG, PG) dengan data yang diambil langsung dari API Golang.
- **State Management:** Menggunakan library `provider` untuk sinkronisasi data antar halaman yang responsif.
- **Secure Session:** Penyimpanan token JWT hasil verifikasi backend secara aman di dalam _secure storage_ perangkat.

---

## 🛠️ Tech Stack & Dependencies

**Frontend:**

- **Framework:** Flutter
- **State Management:** `provider`
- **Authentication:** `firebase_auth`, `google_sign_in`
- **Networking:** `dio` (Custom client dengan interceptor)
- **Storage:** `flutter_secure_storage`

**Backend:**

- **Language:** Golang
- **API Style:** REST API
- **Database:** [Isi Database Kamu, misal: MySQL/PostgreSQL]

---

## 📁 Struktur Arsitektur Proyek

Struktur folder diatur sedemikian rupa untuk mengikuti prinsip _Separation of Concerns_:

```text
lib/
├── main.dart                          # Entry point aplikasi
├── firebase_options.dart              # Konfigurasi Firebase
│
├── core/                              # Utilitas & komponen global
│   ├── constants/                     # Warna, string, & endpoint API
│   ├── services/                      # Dio Client & Secure Storage
│   └── widgets/                       # Reusable UI (Button, TextField, dll)
│
└── features/                          # Modul fitur (Clean Architecture)
    ├── auth/                          # Fitur Login & Register
    │   ├── data/                      # Model & Repository Implementation
    │   ├── domain/                    # Entity & Repository Contract
    │   └── presentation/              # Provider & UI (Pages)
    │
    └── dashboard/                     # Fitur Katalog Produk
        ├── data/                      # Data source dari Backend Golang
        ├── domain/                    # Logic bisnis produk
        └── presentation/              # Grid view & Product detail
```
