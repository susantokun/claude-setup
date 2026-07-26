---
name: shadcnui-date-picker
description: 'Aturan input tanggal React dengan shadcn/ui DatePicker (Popover + Calendar, Base UI). Baca sebelum membuat atau mengubah input tanggal, filter periode, rentang tanggal, tanggal lahir, jadwal, atau deadline. Pemicu bahasa Indonesia: "input tanggal", "pilih tanggal", "date picker", "kalender", "tanggal mulai", "rentang tanggal", "filter periode", "tanggal lahir".'
---

# Date Picker

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang `<input type="date">` dan library kalender lain.
2. Tidak ada komponen `DatePicker`. Susun dari `Popover` + `Calendar` + `Button`.
3. **Ikon kalender wajib ada di trigger**, tanpa kecuali: `<CalendarIcon />` dari `lucide-react` sebagai anak pertama tombol.
4. Base UI: trigger pakai `render={<Button ... />}`, **bukan** `asChild`.
5. Trigger wajib menandai keadaan kosong: `data-empty={!date}` + `className="justify-start text-left font-normal data-[empty=true]:text-muted-foreground"`.
6. Tampilan nilai pakai `format(date, "PPP")` dari `date-fns`. Placeholder bahasa Indonesia ("Pilih tanggal"), bukan teks kosong.
7. `PopoverContent` selalu `className="w-auto p-0"`. Tanpa itu kalender terpotong.
8. Rentang tanggal: `mode="range"`, state `DateRange`, tampilkan `from - to` di trigger.
9. Di dalam form: bungkus `<Field>` (skill `shadcnui-form`), dan kirim ke server sebagai `format(date, "yyyy-MM-dd")`, bukan objek `Date` mentah.
10. Belum terpasang: `npx shadcn@latest add popover calendar button` dan `npm i date-fns`.

```tsx
<Popover>
  <PopoverTrigger
    render={
      <Button variant="outline" data-empty={!date}
        className="justify-start text-left font-normal data-[empty=true]:text-muted-foreground" />
    }
  >
    <CalendarIcon />
    {date ? format(date, "PPP") : <span>Pilih tanggal</span>}
  </PopoverTrigger>
  <PopoverContent className="w-auto p-0">
    <Calendar mode="single" selected={date} onSelect={setDate} />
  </PopoverContent>
</Popover>
```

Cek sebelum selesai: ada `CalendarIcon`, pakai `render` bukan `asChild`, `PopoverContent` punya `w-auto p-0`, tidak ada `input type="date"`.
