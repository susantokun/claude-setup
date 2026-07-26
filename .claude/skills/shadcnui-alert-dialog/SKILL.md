---
name: shadcnui-alert-dialog
description: 'Aturan modal konfirmasi React dengan shadcn/ui AlertDialog (Base UI). Baca sebelum membuat konfirmasi hapus, batalkan, logout, reset, atau aksi apa pun yang tidak bisa dibatalkan. Pemicu bahasa Indonesia: "modal konfirmasi", "konfirmasi hapus", "yakin mau hapus", "dialog konfirmasi", "tanya dulu sebelum hapus", "popup konfirmasi". Modal biasa (form, detail) pakai skill shadcnui-dialog.'
---

# Alert Dialog

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang `confirm()`, `window.confirm`, `Dialog` biasa, atau overlay buatan sendiri untuk konfirmasi.
2. Struktur wajib: `AlertDialog` > `AlertDialogTrigger` > `AlertDialogContent` > `AlertDialogHeader` (`AlertDialogMedia` + `AlertDialogTitle` + `AlertDialogDescription`) > `AlertDialogFooter` (`AlertDialogCancel` + `AlertDialogAction`).
3. Konfirmasi pendek pakai `<AlertDialogContent size="sm">`. Footer otomatis jadi dua kolom sama lebar, itu tampilan standarnya.
4. `AlertDialogCancel` dan `AlertDialogAction` **adalah Button**. Beri `variant` langsung: `<AlertDialogAction variant="destructive">`, `<AlertDialogCancel variant="ghost">`. Jangan dibungkus `render={<Button />}`. Cancel default `variant="outline"`.
5. **`AlertDialogAction` tidak menutup dialog sendiri** — ia Button biasa, bukan Close. Tutup lewat `open`/`onOpenChange` setelah aksinya selesai. Hanya `AlertDialogCancel` yang menutup otomatis.
6. Aksi destruktif memakai ikon di header: `<AlertDialogMedia className="bg-destructive/10 text-destructive dark:bg-destructive/20 dark:text-destructive">` berisi `Trash2Icon`, ditaruh di dalam `AlertDialogHeader` sebelum title.
7. Base UI: trigger pakai `render={<Button variant="destructive">Hapus</Button>} />` (self-closing), bukan `asChild`.
8. Title berupa pertanyaan pendek ("Hapus produk ini?"). Description menjelaskan akibatnya, sebutkan kalau permanen.
9. Label tombol pakai kata kerja aksi ("Hapus"), bukan "OK" atau "Ya".
10. Aksi async: matikan tombol saat proses berjalan, laporkan hasilnya lewat toast (skill `shadcnui-toast`).
11. Belum terpasang: `npx shadcn@latest add alert-dialog`.

```tsx
<AlertDialog open={open} onOpenChange={setOpen}>
  <AlertDialogTrigger render={<Button variant="destructive">Hapus</Button>} />
  <AlertDialogContent size="sm">
    <AlertDialogHeader>
      <AlertDialogMedia className="bg-destructive/10 text-destructive dark:bg-destructive/20 dark:text-destructive">
        <Trash2Icon />
      </AlertDialogMedia>
      <AlertDialogTitle>Hapus produk ini?</AlertDialogTitle>
      <AlertDialogDescription>
        Data produk dan riwayat stoknya dihapus permanen dan tidak bisa dikembalikan.
      </AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel variant="ghost">Batal</AlertDialogCancel>
      <AlertDialogAction variant="destructive" onClick={hapus}>Hapus</AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

Cek sebelum selesai: `variant` langsung di Cancel/Action (bukan `render`), ada `AlertDialogMedia` untuk aksi hapus, `size="sm"`, dan dialog benar-benar tertutup setelah Action.
