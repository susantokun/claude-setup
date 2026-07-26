---
name: shadcnui-dialog
description: 'Aturan modal/dialog React dengan shadcn/ui Dialog (Base UI). Baca sebelum membuat atau mengubah modal, dialog, popup, sheet detail, form dalam modal, atau tombol yang membuka jendela overlay. Pemicu bahasa Indonesia: "pakai modal", "buatkan dialog", "tampilkan popup", "form di modal", "modal detail", "modal edit". Bukan untuk konfirmasi hapus atau aksi destruktif — itu pakai skill shadcnui-alert-dialog.'
---

# Dialog

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang bikin overlay sendiri (`div` + `fixed` + `z-50`) atau pakai `<dialog>` HTML.
2. Struktur wajib lengkap: `Dialog` > `DialogTrigger` > `DialogContent` > `DialogHeader` (`DialogTitle` + `DialogDescription`) > isi > `DialogFooter`.
3. `DialogTitle` dan `DialogDescription` selalu ada, walau pendek. Keduanya dipakai screen reader.
4. Base UI: kustom trigger pakai `render={<Button />}`, **bukan** `asChild`. Berlaku juga untuk `DialogClose`.
5. Tombol batal pakai `DialogClose`, bukan `onClick` yang menutup state manual.
6. Butuh kontrol dari luar (buka setelah fetch, tutup setelah submit): `<Dialog open={open} onOpenChange={setOpen}>`, trigger boleh dihilangkan.
7. Isi form di dalam dialog tetap ikut aturan skill `shadcnui-form` (`Field`, bukan `Label`+`Input`).
8. Jangan atur lebar lewat wrapper. Pakai `className` di `DialogContent` (`sm:max-w-lg`). Sembunyikan tombol silang dengan `showCloseButton={false}`.
9. Import dari `@/components/ui/dialog`. Komponen belum ada: `npx shadcn@latest add dialog`.

```tsx
<Dialog open={open} onOpenChange={setOpen}>
  <DialogTrigger render={<Button variant="outline" />}>Edit</DialogTrigger>
  <DialogContent className="sm:max-w-lg">
    <DialogHeader>
      <DialogTitle>Ubah produk</DialogTitle>
      <DialogDescription>Perubahan tersimpan setelah ditekan Simpan.</DialogDescription>
    </DialogHeader>
    <FieldGroup>{/* field di sini */}</FieldGroup>
    <DialogFooter>
      <DialogClose render={<Button variant="outline" />}>Batal</DialogClose>
      <Button type="submit">Simpan</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

Cek sebelum selesai: ada `DialogTitle` + `DialogDescription`, tombol batal pakai `DialogClose`, tidak ada `asChild`, tidak ada overlay buatan sendiri.
