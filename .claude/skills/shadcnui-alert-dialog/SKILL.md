---
name: shadcnui-alert-dialog
description: 'Aturan modal konfirmasi React dengan shadcn/ui AlertDialog (Base UI). Baca sebelum membuat konfirmasi hapus, batalkan, logout, reset, atau aksi apa pun yang tidak bisa dibatalkan. Pemicu bahasa Indonesia: "modal konfirmasi", "konfirmasi hapus", "yakin mau hapus", "dialog konfirmasi", "tanya dulu sebelum hapus", "popup konfirmasi". Modal biasa (form, detail) pakai skill shadcnui-dialog.'
---

# Alert Dialog

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang `confirm()`, `window.confirm`, `Dialog` biasa, atau overlay buatan sendiri untuk konfirmasi.
2. Struktur wajib lengkap: `AlertDialog` > `AlertDialogTrigger` > `AlertDialogContent` > `AlertDialogHeader` (`AlertDialogTitle` + `AlertDialogDescription`) > `AlertDialogFooter` (`AlertDialogCancel` + `AlertDialogAction`).
3. Footer selalu berisi kedua tombol. `AlertDialogCancel` di kiri, `AlertDialogAction` di kanan.
4. Title berupa pertanyaan pendek ("Hapus produk ini?"). Description menjelaskan akibatnya, sebutkan kalau permanen.
5. Base UI: kustom tombol pakai `render={<Button />}`, **bukan** `asChild`.
6. Aksi destruktif: `AlertDialogAction render={<Button variant="destructive" />}`. Label tombol pakai kata kerja aksi ("Hapus"), bukan "OK" atau "Ya".
7. Tidak ada tombol silang dan tidak boleh tertutup karena klik di luar — jangan tambahkan penutup manual.
8. Aksi async: kontrol dengan `open`/`onOpenChange`, matikan tombol saat proses berjalan, tutup setelah selesai.
9. Import dari `@/components/ui/alert-dialog`. Komponen belum ada: `npx shadcn@latest add alert-dialog`.

```tsx
<AlertDialog>
  <AlertDialogTrigger render={<Button variant="destructive" />}>Hapus</AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Hapus produk ini?</AlertDialogTitle>
      <AlertDialogDescription>
        Data produk dan riwayat stoknya dihapus permanen dan tidak bisa dikembalikan.
      </AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel>Batal</AlertDialogCancel>
      <AlertDialogAction render={<Button variant="destructive" />} onClick={hapus}>
        Hapus
      </AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

Cek sebelum selesai: ada Cancel dan Action, description menyebut akibat, aksi hapus pakai variant `destructive`, tidak ada `confirm()`.
