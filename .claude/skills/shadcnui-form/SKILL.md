---
name: shadcnui-form
description: 'Aturan form input React dengan shadcn/ui Field. Baca sebelum membuat atau mengubah form, form input, input, textarea, select, checkbox, radio, halaman create/edit, atau file .tsx di resources/js. Pemicu bahasa Indonesia: "buatkan form", "form input", "tambah field", "halaman tambah data".'
---

# Form Input React

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Semua kontrol input dibungkus `<Field>`. Dilarang `<Label>`+`<Input>` polos.
2. Import dari `@/components/ui/field`.
3. Urutan: FieldLabel -> kontrol -> FieldDescription -> FieldError.
4. `htmlFor` wajib sama dengan `id` kontrol.
5. Kumpulan field dibungkus `<FieldGroup>`.
6. Error: `data-invalid` di Field + `aria-invalid` di kontrol + `<FieldError>`.
7. Jangan tambah class layout manual di `<Field>`. Label sejajar kontrol pakai `orientation="horizontal"`.
8. Komponen belum ada: `npx shadcn@latest add field`.

```tsx
<FieldGroup>
  <Field data-invalid={!!errors.nama}>
    <FieldLabel htmlFor="nama">Nama</FieldLabel>
    <Input id="nama" value={data.nama} aria-invalid={!!errors.nama}
           onChange={(e) => setData("nama", e.target.value)} />
    {errors.nama && <FieldError>{errors.nama}</FieldError>}
  </Field>
</FieldGroup>
```

Cek sebelum selesai: tidak ada input di luar `<Field>`, `htmlFor` cocok `id`, error pakai `FieldError`.
