# Claude Code Setup

Kumpulan skill dan konfigurasi Claude Code supaya semua project baru langsung
punya gaya penulisan kode yang sama. Tinggal salin, tidak perlu mengulang
instruksi tiap kali membuka sesi.

## Isi

```
.claude/
├── skills/
│   ├── changelog-generator/SKILL.md
│   ├── git-commit/SKILL.md
│   ├── shadcnui-alert-dialog/SKILL.md
│   ├── shadcnui-data-table/SKILL.md
│   ├── shadcnui-dialog/SKILL.md
│   └── shadcnui-form/SKILL.md
├── settings.local.json          # dipakai repo ini, di-gitignore
└── settings.local.example.json  # template yang ikut ter-commit
.mcp.json
CLAUDE.snippet.md
install.ps1
```

### Skill

| Skill | Fungsi | Aktif ketika |
|---|---|---|
| `shadcnui-form` | Semua form wajib pakai shadcn/ui `Field`, dilarang `<Label>`+`<Input>` polos | Membuat atau mengubah form, input, halaman create/edit, file `.tsx` |
| `shadcnui-dialog` | Modal pakai `Dialog` lengkap (header, title, description, footer), dilarang overlay buatan sendiri | Diminta membuat modal, dialog, popup, form di dalam modal |
| `shadcnui-alert-dialog` | Konfirmasi pakai `AlertDialog` lengkap dengan Cancel + Action, dilarang `confirm()` | Diminta membuat konfirmasi hapus, logout, reset, aksi tak bisa dibatalkan |
| `shadcnui-data-table` | Tabel pakai `DataTable` + TanStack Table, pagination dan search wajib ada | Diminta membuat tabel, daftar data, halaman index/list |
| `git-commit` | Format commit `Prefix(scope): deskripsi` | Sebelum `git commit` atau menulis pesan commit |
| `changelog-generator` | Menyusun `CHANGELOG.md` dari riwayat git dengan bahasa pengguna | Diminta membuat changelog atau catatan rilis |

Skill dimuat otomatis saat `description`-nya cocok dengan permintaan. Tidak
memakan context selama belum terpakai.

### Konfigurasi

**`.claude/settings.local.json`** — daftar `deny` permission. Melarang Claude
menjalankan dev server, build, dan tool browser preview, karena itu dijalankan
sendiri oleh user. File ini bersifat pribadi per mesin dan **harus masuk
`.gitignore`** di project tujuan.

**`.claude/settings.local.example.json`** — salinan isinya yang sengaja
di-commit. Karena file aslinya di-gitignore, ia tidak ikut saat repo di-clone,
jadi installer memakai template ini sebagai sumber.

**`.mcp.json`** — MCP server. Berisi dua entry:

- `shadcn` — akses registry shadcn: cari, lihat, dan pasang komponen lewat
  perintah biasa. Berlaku untuk semua project React.
- `laravel-boost` — dokumentasi versi-spesifik, query database, log. **Hapus
  entry ini kalau project tujuan bukan Laravel.**

**`CLAUDE.snippet.md`** — konvensi project yang harus selalu dibaca: aturan
shadcn/ui, package manager, dan daftar perintah terlarang. Isinya ditempel ke
`CLAUDE.md` project, bukan dipakai sebagai file terpisah.

**`install.ps1`** — pemasang otomatis. Menyalin semua yang di atas ke sebuah
project tanpa menimpa apa pun, dan menyesuaikan isinya dengan jenis project.

## Cara pasang ke project baru

### Satu baris, tanpa clone

Berdiri di root project tujuan, lalu jalankan:

```powershell
pwsh -NoProfile -Command "irm https://raw.githubusercontent.com/susantokun/claude-setup/main/install.ps1 | iex"
```

Baris itu jalan apa adanya di cmd, Cmder, dan PowerShell. Script mengambil repo
ini ke folder sementara, memasang isinya ke project tempat kamu berdiri, lalu
menghapus folder sementaranya. Butuh `git` di PATH.

Mau memaksa skill lama tertimpa versi terbaru:

```powershell
pwsh -NoProfile -Command "& ([scriptblock]::Create((irm https://raw.githubusercontent.com/susantokun/claude-setup/main/install.ps1))) -Force"
```

### Dari clone lokal

Kalau lebih suka pegang salinannya sendiri:

```bash
git clone git@github.com:susantokun/claude-setup.git C:/tools/claude-setup
```

Lalu dari root project mana pun:

```powershell
& C:/tools/claude-setup/install.ps1
```

Bedanya cuma sumbernya. Versi ini juga ikut menyalin `settings.local.json`
milikmu sendiri kalau ada; versi satu baris memakai
`settings.local.example.json` yang ter-commit.

### Yang dilakukan installer

Menyalin semua skill, memasang `settings.local.json` dan mendaftarkannya ke
`.gitignore`, menggabungkan `.mcp.json`, dan menempelkan konvensi ke `CLAUDE.md`.

Yang perlu diketahui:

- **Tidak menimpa apa pun.** File dan skill yang sudah ada dilewati dan
  dilaporkan. Mau menimpa skill dengan versi terbaru: tambahkan `-Force`.
- **Aman diulang.** Menjalankan dua kali tidak menggandakan isi `.gitignore`,
  `.mcp.json`, atau `CLAUDE.md`.
- **Menyesuaikan jenis project.** Kalau tidak ada file `artisan`, entry
  `laravel-boost` dilewati dan path komponen di `CLAUDE.md` ditulis
  `src/components/ui`, bukan `resources/js/components/ui`.
- **Update belakangan** cukup jalankan ulang dengan `-Force` di project yang mau
  ikut versi baru. Kalau pakai clone lokal, `git pull` dulu.

Flag lain: `-Path <dir>` untuk menunjuk project tanpa pindah direktori,
`-SkipMcp` dan `-SkipClaudeMd` kalau dua file itu mau diurus manual.

Sesudahnya, **restart Claude Code** supaya MCP server terbaca, lalu pasang
komponen shadcn (lihat bagian di bawah).

### Kalau mau manual

<details>
<summary>Langkah per file, tanpa installer</summary>

#### 1. Salin skill dan permission

```bash
cp -r .claude /path/ke/project-baru/
```

Kalau project tujuan sudah punya `.claude/skills/`, salin per folder saja
supaya skill bawaan yang sudah ada tidak tertimpa:

```bash
cp -r .claude/skills/shadcnui-form /path/ke/project-baru/.claude/skills/
```

#### 2. Kecualikan permission dari git

`settings.local.json` khusus mesinmu, jangan sampai ikut ter-commit:

```bash
echo "/.claude/settings.local.json" >> /path/ke/project-baru/.gitignore
```

#### 3. Pasang MCP server

Salin `.mcp.json` ke root project. Kalau project sudah punya file itu,
**jangan ditimpa** — tambahkan entry-nya ke dalam `mcpServers` yang sudah ada:

```json
{
    "mcpServers": {
        "shadcn": {
            "command": "npx",
            "args": ["shadcn@latest", "mcp"]
        }
    }
}
```

MCP server baru hanya dibaca saat startup, jadi **restart Claude Code** dan
approve server-nya saat diminta.

#### 4. Tempel konvensi ke CLAUDE.md

```bash
cat CLAUDE.snippet.md >> /path/ke/project-baru/CLAUDE.md
```

Sesuaikan path komponen di dalamnya (`resources/js/components/ui` untuk Laravel
+ Inertia, `src/components/ui` untuk Next.js atau Vite).

Kalau project tujuan pakai Laravel Boost, taruh isinya **di luar** blok
`<laravel-boost-guidelines>` — blok itu ditulis ulang setiap Boost regenerate
dan isinya akan hilang.

</details>

### Pasang komponen yang dipakai skill

Skill shadcn/ui mengandalkan komponen ini:

```bash
npx shadcn@latest add field dialog alert-dialog table
```

`shadcnui-data-table` juga butuh TanStack Table:

```bash
npm i @tanstack/react-table
```

Pastikan project cuma punya satu lockfile sebelum menjalankannya. shadcn memilih
package manager dari lockfile yang ia temukan, jadi repo yang punya
`package-lock.json` **dan** `pnpm-lock.yaml` sekaligus akan salah pilih dan bisa
merusak `node_modules`.

## Memastikan skill terbaca

Buka Claude Code di project tujuan, lalu minta sesuatu yang **tidak menyebut**
nama skill-nya, misalnya *"buatkan halaman tambah data produk"*. Kalau
`shadcnui-form` bekerja, hasilnya memakai `<Field>` dan `<FieldError>`, bukan
`<div>` + `<Label>`.

Kalau tidak aktif, biasanya karena `description` di SKILL.md kurang mencakup
cara kamu bertanya. Tambahkan kata pemicunya ke `description`, jangan ke body —
hanya `description` yang dibaca saat menentukan skill mana yang dimuat.

## Pilihan lain: pasang global

Kalau tidak mau menyalin ke tiap project, taruh skill di direktori global. Skill
akan aktif di semua project tanpa disalin:

```
~/.claude/skills/           # macOS / Linux
C:\Users\<nama>\.claude\skills\    # Windows
```

Bedanya: skill global bersifat pribadi dan tidak ikut ke repo, jadi tim tidak
kebagian. Skill per-project ikut ter-commit dan dipakai semua orang. Keduanya
bisa dipakai bersamaan — kalau namanya sama, versi project yang menang.

## Menulis skill sendiri

Satu skill = satu folder berisi `SKILL.md` dengan frontmatter:

```markdown
---
name: nama-skill
description: 'Kapan skill ini dibaca. Sebutkan kata pemicu sebanyak mungkin.'
---

# Judul

Aturan yang harus diikuti.
```

Yang menentukan skill terpakai atau tidak hanya `description`. Tulis kapan
skill dipakai dan kapan tidak, sebutkan sinonim dan istilah yang biasa kamu
pakai, termasuk bahasa Indonesia. Isi body baru dibaca setelah skill terpilih,
jadi taruh aturan detail di sana, bukan di `description`.

Skill yang terlalu panjang cenderung diabaikan sebagian. Tulis padat, pakai
daftar bernomor, dan tutup dengan checklist singkat "cek sebelum selesai".
