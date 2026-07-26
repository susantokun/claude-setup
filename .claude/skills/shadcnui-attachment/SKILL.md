---
name: shadcnui-attachment
description: 'Aturan upload dan tampilan lampiran React dengan shadcn/ui Attachment (Base UI). Baca sebelum membuat atau mengubah upload file, unggah gambar, lampiran, dokumen, bukti transfer, atau daftar file terpilih. Pemicu bahasa Indonesia: "upload file", "unggah", "lampiran", "attachment", "pilih file", "upload gambar", "bukti bayar", "dokumen".'
---

# Attachment

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang menampilkan file terpilih sebagai teks polos, `<li>`, atau kartu buatan sendiri.
2. `Attachment` hanya menampilkan file. Pemilihannya tetap `<Input type="file">` di dalam `<Field>` (skill `shadcnui-form`) — sembunyikan input aslinya dan pakai `FieldLabel` sebagai area klik kalau mau tombol kustom.
3. Struktur wajib lengkap: `Attachment` > `AttachmentMedia` > `AttachmentContent` (`AttachmentTitle` + `AttachmentDescription`) > `AttachmentActions` > `AttachmentAction`.
4. **`state` wajib mengikuti proses upload sungguhan**: `idle`, `uploading`, `processing`, `error`, `done`. Jangan biarkan default `done` untuk file yang belum terkirim.
5. `AttachmentTitle` diisi nama file. `AttachmentDescription` diisi tipe dan ukuran, format "PDF · 2,4 MB".
6. `AttachmentMedia` diisi thumbnail untuk gambar, ikon `lucide-react` sesuai tipe untuk berkas lain.
7. Setiap `AttachmentAction` wajib `aria-label` yang menyebut nama filenya, karena isinya cuma ikon.
8. Banyak file dibungkus `AttachmentGroup`. Satu file tidak perlu.
9. Pratinjau pakai Dialog: `<DialogTrigger render={<AttachmentTrigger aria-label="..." />} />` (skill `shadcnui-dialog`).
10. Proses unggahnya sendiri dilaporkan lewat `toast.promise` (skill `shadcnui-toast`). Validasi tipe dan ukuran sebelum kirim, tampilkan penolakan sebagai `state="error"` + `AttachmentDescription` berisi alasannya.
11. Belum terpasang: `npx shadcn@latest add attachment`.

```tsx
<AttachmentGroup>
  {files.map((f) => (
    <Attachment key={f.id} state={f.state}>
      <AttachmentMedia><FileTextIcon /></AttachmentMedia>
      <AttachmentContent>
        <AttachmentTitle>{f.nama}</AttachmentTitle>
        <AttachmentDescription>{f.tipe} · {f.ukuran}</AttachmentDescription>
      </AttachmentContent>
      <AttachmentActions>
        <AttachmentAction aria-label={`Hapus ${f.nama}`} onClick={() => hapus(f.id)}>
          <XIcon />
        </AttachmentAction>
      </AttachmentActions>
    </Attachment>
  ))}
</AttachmentGroup>
```

Cek sebelum selesai: `state` mengikuti proses nyata, deskripsi memuat tipe dan ukuran, setiap action punya `aria-label`, upload dilaporkan lewat toast.
