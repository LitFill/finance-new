# finance — Master LitFill keuangan

Pencatatan keuangan pribadi pakai **hledger**.

## Struktur

- `2026.journal` — jurnal tahun berjalan (entri + header directives)
- `.omp/AGENTS.md` — instruksi asisten (omp)
- `fmt-journal` — rapikan format jurnal tanpa menghapus header
- `laporan.sh` — generate laporan HTML ke `docs/`
- `.omp/skills/hledger-finance/` — skill omp untuk pencatatan
- `.githooks/pre-commit` — validasi otomatis sebelum commit

## Tools

```bash
# aktifkan pre-commit hook (sekali saja)
git config core.hooksPath .githooks

# validasi ketat (semua akun & commodity wajib dideklarasikan)
hledger check -s -f 2026.journal

# balance
hledger bal -f 2026.journal
hledger bal assets -f 2026.journal
hledger bal expenses:makan -f 2026.journal

# riwayat mutasi
hledger reg assets:cash -f 2026.journal

# income statement / cashflow
hledger is -f 2026.journal
hledger cf -f 2026.journal
```

## Alur

1. Kritika/Tambah entri di `2026.journal` (format hledger, nominal Indonesia `Rp 1.000,00`)
2. Jalankan `hledger check -f 2026.journal` untuk validasi balance
3. Rapikan format: `./fmt-journal -o 2026.journal 2026.journal`
4. Laporkan saldo: `hledger bal ...`

## Pergantian tahun

1. Buat `<TAHUN BARU>.journal` — copy header directives (commodity, akun,
   budget periodik, price directive) dari jurnal tahun lalu, tanpa entri.
2. Tambahkan `include <TAHUN LALU>.journal` di paling atas jurnal baru
   supaya saldo pembuka/riwayat tetap terhitung.
3. Update referensi tahun di README, `.omp/AGENTS.md`, dan skill.

Detail skill: `.omp/skills/hledger-finance/SKILL.md`