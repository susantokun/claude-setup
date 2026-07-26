---
name: shadcnui-select
description: 'Aturan input pilihan React dengan shadcn/ui Select (Base UI). Baca sebelum membuat atau mengubah dropdown, select, combobox sederhana, filter status, pilih kategori, atau mengganti <select> native. Pemicu bahasa Indonesia: "dropdown", "select", "pilihan", "pilih kategori", "filter status", "opsi", "combo box".'
---

# Select

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang `<select>` dan `<option>` native.
2. Struktur wajib lengkap: `Select` > `SelectTrigger` > `SelectValue` > `SelectContent` > `SelectGroup` > `SelectItem`.
3. Base UI: isi `items` di root `Select` dengan array `{ label, value }`, lalu render `SelectItem` dari array yang sama. Tanpa `items`, trigger menampilkan value mentah, bukan label.
4. Placeholder ditulis di `SelectValue placeholder="..."`, bukan sebagai `SelectItem` kosong.
5. `SelectItem` wajib punya `value` tidak kosong. Untuk "semua"/"tanpa pilihan" pakai value sentinel seperti `"all"`, bukan `""`.
6. Lebar diatur di `SelectTrigger` (`className="w-[180px]"` atau `w-full`), bukan di `SelectContent`.
7. Terkontrol: `value` + `onValueChange`. Jangan campur dengan `onChange`.
8. Pilihan berkelompok pakai `SelectGroup` + `SelectLabel`, pemisah pakai `SelectSeparator`.
9. Di dalam form: bungkus `<Field>` (skill `shadcnui-form`), `id` ditaruh di `SelectTrigger` dan disamakan dengan `htmlFor`.
10. Belum terpasang: `npx shadcn@latest add select`.

```tsx
const items = [
  { label: "Aktif", value: "aktif" },
  { label: "Nonaktif", value: "nonaktif" },
]

<Select items={items} value={data.status} onValueChange={(v) => setData("status", v)}>
  <SelectTrigger id="status" className="w-full">
    <SelectValue placeholder="Pilih status" />
  </SelectTrigger>
  <SelectContent>
    <SelectGroup>
      {items.map((item) => (
        <SelectItem key={item.value} value={item.value}>{item.label}</SelectItem>
      ))}
    </SelectGroup>
  </SelectContent>
</Select>
```

Cek sebelum selesai: ada `items` di root, placeholder di `SelectValue`, tidak ada `value=""`, lebar di trigger.
