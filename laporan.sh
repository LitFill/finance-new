#!/bin/bash
# laporan.sh — Generate laporan HTML jurnal keuangan
# Usage: ./laporan.sh [TAHUN]
# Default TAHUN: tahun sekarang

set -euo pipefail

TAHUN="${1:-$(date +%Y)}"
JOURNAL="${TAHUN}.journal"
OUTDIR="docs"
OUTFILE="${OUTDIR}/laporan-${TAHUN}.html"

if [ ! -f "$JOURNAL" ]; then
    echo "Error: file jurnal '$JOURNAL' tidak ditemukan." >&2
    exit 1
fi

mkdir -p "$OUTDIR"

echo "» Membangun laporan tahun $TAHUN..."
echo "» Output: $OUTFILE"

{
  cat <<'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Laporan Keuangan Master LitFill —
EOF
  echo -n " ${TAHUN}"
  cat <<'EOF'
</title>
<style>
  :root { --bg:#0d1117; --fg:#c9d1d9; --accent:#58a6ff; --muted:#8b949e; --border:#30363d; }
  body { font-family: system-ui, -apple-system, sans-serif; background:var(--bg); color:var(--fg); max-width:960px; margin:2rem auto; padding:0 1rem; line-height:1.6; }
  h1,h2 { color:var(--accent); border-bottom:1px solid var(--border); padding-bottom:.3rem; }
  h1 { font-size:1.6rem; } h2 { font-size:1.2rem; margin-top:2rem; }
  pre,code { font-family: "SFMono-Regular", Consolas, monospace; font-size:.9rem; }
  pre { background:#161b22; padding:1rem; border-radius:8px; overflow-x:auto; border:1px solid var(--border); }
  .card { background:#161b22; border:1px solid var(--border); border-radius:10px; padding:1.2rem; margin-bottom:1.5rem; }
  .muted { color:var(--muted); }
  table { width:100%; border-collapse:collapse; margin-top:.5rem; }
  th,td { text-align:left; padding:.5rem .6rem; border-bottom:1px solid var(--border); }
  th { color:var(--accent); font-weight:600; }
  .num { text-align:right; font-variant-numeric:tabular-nums; }
  .line { display:flex; justify-content:space-between; margin:.25rem 0; }
  .credit { color:#3fb950; }
  .debit  { color:#f85149; }
  footer { margin-top:3rem; text-align:center; color:var(--muted); font-size:.85rem; border-top:1px solid var(--border); padding-top:1rem; }
</style>
</head>
<body>
EOF

  echo "<h1>📊 Laporan Keuangan ${TAHUN}</h1>"
  echo '<p class="muted">Dibangun oleh hledger</p>'

  # --- Ringkasan ---
  echo '<div class="card"><h2>📋 Ringkasan Balance</h2><pre>'
  hledger bal -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  # --- Aset ---
  echo '<div class="card"><h2>💰 Aset (assets)</h2><pre>'
  hledger bal assets -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  # --- Liabilities ---
  echo '<div class="card"><h2>💳 Kewajiban (liabilities)</h2><pre>'
  hledger bal liabilities -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  # --- Income ---
  echo '<div class="card"><h2>📥 Pemasukan (income)</h2><pre>'
  hledger bal income -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  # --- Expenses ---
  echo '<div class="card"><h2>📤 Pengeluaran (expenses)</h2><pre>'
  hledger bal expenses -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  # --- Cashflow ---
  echo '<div class="card"><h2>🌊 Cashflow</h2><pre>'
  hledger print -f "$JOURNAL" 2>&1 || true
  echo '</pre></div>'

  echo '<footer>Generated on'
  date +" %Y-%m-%d %H:%M:%S %Z"
  echo 'by laporan.sh</footer>'
  echo '</body></html>'

} > "$OUTFILE"

echo "» Laporan berhasil dibuild!"
echo "» Buka di browser: file://${PWD}/${OUTFILE}"
