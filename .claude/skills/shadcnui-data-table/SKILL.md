---
name: shadcnui-data-table
description: 'Aturan tabel data React dengan shadcn/ui DataTable + TanStack Table, wajib pagination dan search. Baca sebelum membuat atau mengubah tabel, daftar data, halaman index/list, grid data, atau menambah kolom/sorting/filter pada tabel. Pemicu bahasa Indonesia: "buatkan tabel", "tabel data", "halaman daftar", "list data", "tampilkan datanya dalam tabel", "tambah kolom", "tabel dengan pencarian".'
---

# Data Table

Ambil definisi komponen dari MCP `shadcn` sebelum menulis kode. Jangan pakai ingatan.

1. Dilarang `<table>` polos atau `map` manual. Selalu `Table` shadcn + `useReactTable` dari `@tanstack/react-table`.
2. **Pagination dan search wajib ada di setiap tabel**, walau tidak diminta.
3. Pisah dua file: `columns.tsx` (`ColumnDef<T>[]`, ada `"use client"` di Next.js) dan `data-table.tsx` (komponen generic `DataTable<TData, TValue>`).
4. Row model wajib dipasang semua: `getCoreRowModel`, `getPaginationRowModel`, `getFilteredRowModel`, `getSortedRowModel`.
5. State pakai `React.useState`: `sorting` (`SortingState`), `columnFilters` (`ColumnFiltersState`), dipasang lewat `onSortingChange` / `onColumnFiltersChange` + `state`.
6. Search = `Input` di atas tabel yang menyetir `table.getColumn("x")?.setFilterValue(...)`. Placeholder sebut kolomnya ("Cari nama..."). Butuh cari lintas kolom: pakai `globalFilter` + `onGlobalFilterChange`.
7. Body wajib punya cabang kosong: `<TableCell colSpan={columns.length} className="h-24 text-center">Tidak ada data.</TableCell>`.
8. Pagination pakai `Button` Sebelumnya/Berikutnya dengan `disabled={!table.getCanPreviousPage()}` / `getCanNextPage()`. Tampilkan jumlah baris dari `table.getFilteredRowModel().rows.length`.
9. Kolom aksi: `id: "actions"`, `enableHiding: false`, isinya `DropdownMenu`. Hapus data lewat skill `shadcnui-alert-dialog`.
10. Header sortable pakai `Button variant="ghost"` + `column.toggleSorting(column.getIsSorted() === "asc")`, bukan string biasa.
11. Data server-side (Laravel/Inertia paginator): set `manualPagination: true` + `pageCount`, dan navigasi lewat request, jangan campur dengan paginator bawaan.
12. Belum terpasang: `npx shadcn@latest add table` dan `npm i @tanstack/react-table`.

```tsx
const table = useReactTable({
  data, columns,
  getCoreRowModel: getCoreRowModel(),
  getPaginationRowModel: getPaginationRowModel(),
  getFilteredRowModel: getFilteredRowModel(),
  getSortedRowModel: getSortedRowModel(),
  onSortingChange: setSorting,
  onColumnFiltersChange: setColumnFilters,
  state: { sorting, columnFilters },
})
```

Isi render mengikuti struktur resmi: `Input` filter → `div` border + `Table` (`getHeaderGroups`/`getRowModel` + `flexRender`) → baris tombol pagination.

Cek sebelum selesai: ada input search, ada tombol pagination yang bisa disabled, ada state kosong, tidak ada `<table>` manual.
