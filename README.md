# finance-new — Master LitFill keuangan

Pencatatan keuangan pribadi pakai **hledger**.

## Struktur

- `2026.journal` — jurnal tahun berjalan (entri + header directives)
- `2025.journal` — jurnal tahun sebelumnya (include dari 2026)
- `AGENT.md` — instruksi asisten (pi)
- `fmt-journal` — rapikan format jurnal tanpa menghapus header
- `laporan.sh` — generate laporan HTML ke `docs/`
- `.pi/skills/hledger-finance/` — skill pi pakai pencatatan

## Tools

```bash
# validasi
hledger check -f 2026.journal

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
2. Jalankan `hledger check -f 2026.journal` deto validasi balance
3. Rapikan format: `./fmt-journal -o 2026.journal 2026.journal`
4. Laporkan saldo: `hledger bal ...`

Detali skill: `.pi/skills/hledger-finance/SKILL.md`