# shadcn/ui

Project ini pakai shadcn/ui (style `new-york`, ikon `lucide`, Tailwind v4,
CSS variables). Komponen ada di `resources/js/components/ui` dan dikecualikan
dari Prettier dan ESLint, jadi pertahankan format asli shadcn (indent 2 spasi,
double quote, tanpa semicolon), bukan gaya TS project.

> Sesuaikan path di atas: `resources/js/components/ui` untuk Laravel + Inertia,
> `src/components/ui` untuk Next.js atau Vite.

Cek `resources/js/components/ui` sebelum membuat UI primitive apa pun.

Tambah komponen dengan `npx shadcn@latest add <komponen>`. Lihat dulu dengan
`--dry-run`, dan pakai `npx shadcn@latest view @shadcn/<nama>` untuk memeriksa
isi komponen sebelum menambahkannya.

# Package manager

Project ini pakai npm, dan hanya npm. `package-lock.json` adalah satu-satunya
sumber kebenaran dan `packageManager` di `package.json` mengunci versinya.

Jangan pernah menjalankan `pnpm` atau `yarn` di sini. Tool yang mendeteksi
package manager otomatis akan mengikuti lockfile mana pun yang ditemukan, jadi
jangan commit `pnpm-lock.yaml` atau `yarn.lock` — satu file nyasar membuat
`shadcn add` menjalankan `pnpm install`, yang memindahkan `node_modules` hasil
npm ke `node_modules/.ignored` dan merusak build sampai `npm install` diulang.

# Yang tidak boleh dijalankan Claude

Dev server dan build dijalankan sendiri oleh user.
`.claude/settings.local.json` melarang perintah berikut — jangan dicoba, dan
jangan menyarankan cara memutarinya:

- `npm run dev`, `npm run build`, `npm run build:ssr`, `composer run dev`,
  `vite`, `php artisan serve`
- Semua tool browser preview (`mcp__Claude_Browser__*`,
  `mcp__claude-in-chrome__*`)

Verifikasi pekerjaan frontend dengan `npm run types:check`, `npm run lint:check`,
`npx prettier --check`, dan test. Kalau sebuah perubahan butuh asset hasil build
atau pengecekan visual, katakan saja dan biarkan user yang menjalankan.
