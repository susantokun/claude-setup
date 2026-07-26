---
name: changelog-generator
description: 'Menyusun changelog dan catatan rilis dari riwayat git. Baca sebelum menulis atau memperbarui CHANGELOG.md, membuat catatan rilis, menjawab apa saja yang berubah sejak tag/versi/tanggal tertentu, atau menyiapkan rilis versi baru. Pemicu bahasa Indonesia: "buatkan changelog", "catatan rilis", "apa saja yang berubah", "ringkasan perubahan", "update changelog", "mau rilis versi".'
metadata:
  inspired-by: 'changelog-generator, ComposioHQ/awesome-claude-skills (Apache-2.0)'
---

# Changelog

Sumbernya `git log`, tapi isinya ditulis untuk pengguna. Jangan pernah menyalin
subject commit apa adanya.

## 1. Tentukan rentang

Pakai urutan ini, jangan bertanya kalau sudah jelas:

```bash
git describe --tags --abbrev=0     # tag rilis terakhir
git log --oneline <tag>..HEAD
```

Kalau tidak ada tag:

1. Ada `CHANGELOG.md` → batasnya commit terakhir yang menyentuhnya:
   `git log -1 --format=%H -- CHANGELOG.md`
2. Tidak ada tag dan tidak ada changelog → rilis pertama, pakai seluruh riwayat
3. User menyebut tanggal → `git log --since="2026-06-01" --until="2026-07-01"`

Sebutkan rentang yang dipakai sebelum menulis: *"Mencakup v1.2.0..HEAD, 34 commit."*

## 2. Baca isinya, bukan cuma judulnya

Subject commit tidak cukup untuk menilai dampak. Untuk yang tidak jelas, lihat
file yang disentuh dengan `git show --stat <sha>`.

Path menentukan siapa yang terdampak:

- `app/`, `routes/`, `database/migrations/` → perubahan yang dirasakan pengguna
- `resources/js/`, `resources/css/` → perubahan tampilan
- `config/`, `.env.example` → kemungkinan perlu tindakan saat upgrade
- `tests/`, `.github/`, `*.md`, lockfile → hampir selalu internal

## 3. Kategori

Tulis hanya bagian yang ada isinya, jangan buat heading kosong.

| Bagian | Isinya |
|---|---|
| Ditambahkan | Kemampuan baru yang sebelumnya tidak ada |
| Diubah | Perilaku lama yang sekarang berbeda |
| Diperbaiki | Bug yang mungkin dialami pengguna |
| Keamanan | Perbaikan celah, pengetatan auth dan perizinan |
| Usang | Masih jalan, akan dihapus |
| Dihapus | Sudah tidak ada di versi ini |

Yang butuh tindakan manual ditaruh paling atas di bawah heading
**Breaking change**, lengkap dengan langkah migrasinya.

## 4. Aturan penulisan

1. Mulai dari apa yang bisa dilakukan pengguna, bukan apa yang dilakukan kode.
   Commit: `Fix(auth): guard null token di TwoFactorChallenge`
   Changelog: `Memperbaiki error saat mengirim kode 2FA setelah sesi kedaluwarsa.`
2. Kalimat utuh, tanpa hash commit, tanpa prefix `Feat:`/`Fix:`, tanpa nomor tiket.
3. Satu baris per perubahan yang terlihat pengguna. Beberapa commit untuk satu
   bug digabung jadi satu; satu commit yang menyentuh tiga fitur dipecah tiga.
4. Buang: merge commit, perapian format dan lint, bump dependency tanpa efek,
   perubahan test, konfigurasi CI, refactor internal, typo di komentar.
5. Bump dependency hanya ditulis kalau mengubah syarat (versi PHP, versi Node)
   atau menambal celah keamanan.
6. Dilarang mengarang entri untuk mengisi bagian yang kosong. Commit yang
   maksudnya tidak jelas dari diff-nya ditaruh di heading
   "Perlu ditinjau" di bagian akhir, bukan ditebak.

## 5. Output

Default format [Keep a Changelog](https://keepachangelog.com/) di `CHANGELOG.md`
pada root repo, versi terbaru di atas:

```markdown
## [1.3.0] - 2026-07-26

### Ditambahkan

- Autentikasi dua faktor lewat aplikasi authenticator dan kode pemulihan.

### Diperbaiki

- Tautan reset password tidak lagi kedaluwarsa lebih cepat ketika aplikasi dan
  queue berjalan di zona waktu berbeda.
```

Aturan file:

- Versi baru ditambahkan di atas. Jangan menulis ulang atau mengurutkan ulang
  bagian yang sudah dirilis.
- Pakai `## [Belum dirilis]` kalau nomor versinya belum ditentukan.
- Format tanggal `YYYY-MM-DD`.
- Kalau `CHANGELOG.md` sudah ada, ikuti struktur, kedalaman heading, dan gaya
  bahasa yang dipakai di sana, jangan memaksakan format ini. Berlaku juga kalau
  ada `CHANGELOG_STYLE.md` atau panduan kontribusi.

Tampilkan draf di balasan sebelum menulis file. Jangan membuat tag, menaikkan
versi di `package.json` atau `composer.json`, atau melakukan commit kecuali
diminta — itu tindakan rilis, bukan menyusun changelog.

Cek sebelum selesai: rentang sudah disebutkan, tidak ada subject commit yang
tersalin mentah, tidak ada heading kosong, tidak ada entri karangan.
