---
name: shadcnui-toast
description: 'Aturan notifikasi aksi React dengan shadcn/ui Toast (Base UI), wajib pakai toast.promise untuk aksi async. Baca sebelum menulis handler submit, simpan, hapus, upload, atau aksi apa pun yang perlu umpan balik berhasil/gagal. Pemicu bahasa Indonesia: "notifikasi", "toast", "pesan berhasil", "alert sukses", "kasih feedback", "loading saat simpan", "pemberitahuan".'
---

# Toast

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. **Setiap aksi wajib punya umpan balik toast**: simpan, ubah, hapus, upload, kirim. Dilarang `alert()`, `console.log`, atau banner buatan sendiri sebagai pengganti.
2. `<Toaster />` dipasang sekali saja di root layout. Kalau belum ada, pasang dulu.
3. Import `toast` dari `@/components/ui/toast`. Bukan `sonner`, bukan `useToast`.
4. **Aksi async wajib `toast.promise`**, bukan rangkaian toast manual sebelum dan sesudah `await`. Satu toast berubah dari loading ke hasil.
5. `loading` / `success` / `error` boleh string, objek `{ title, description }`, atau fungsi yang menerima hasil dan error. Pakai fungsi kalau pesannya memuat data dari respons.
6. Pesan error ambil dari error asli. Dilarang menelan error jadi teks generik "Terjadi kesalahan" kalau server sudah mengirim alasannya.
7. Aksi sinkron atau hasil dari redirect: `toast.add({ type, title, description })` dengan `type` salah satu `success`, `error`, `warning`, `info`, `loading`.
8. Tombol di dalam toast pakai `actionProps`. Tutup manual dengan `toast.close(id)` memakai id kembalian `toast.add`.
9. Judul singkat tanpa titik ("Produk tersimpan"), deskripsi baru menjelaskan detail. Jangan taruh kalimat panjang di title.
10. Belum terpasang: `npx shadcn@latest add toast`.

```tsx
toast.promise(simpanProduk(data), {
  loading: "Menyimpan produk...",
  success: (produk) => ({ title: "Produk tersimpan", description: produk.nama }),
  error: (err) => ({ title: "Gagal menyimpan", description: err.message }),
})
```

Cek sebelum selesai: `<Toaster />` terpasang, aksi async pakai `toast.promise`, pesan error dari error asli, tidak ada `alert()`.
