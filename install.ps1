#Requires -Version 7
<#
.SYNOPSIS
    Memasang skill dan konfigurasi claude-setup ke sebuah project.

.DESCRIPTION
    Dari root project tujuan, tanpa clone dulu:
        pwsh -NoProfile -Command "irm https://raw.githubusercontent.com/susantokun/claude-setup/main/install.ps1 | iex"

    Atau dari clone lokal:
        & C:/tools/claude-setup/install.ps1

    Script tidak pernah menimpa file yang sudah ada, kecuali dipaksa dengan
    -Force. Yang dilewati dilaporkan sebagai "-".

.PARAMETER Path
    Root project tujuan. Default: direktori saat ini.

.PARAMETER Repo
    Sumber saat dijalankan lewat irm | iex. Default repo publik claude-setup.

.PARAMETER Force
    Timpa skill yang namanya sudah ada di project tujuan.

.PARAMETER SkipMcp
    Jangan sentuh .mcp.json.

.PARAMETER SkipClaudeMd
    Jangan tempel konvensi ke CLAUDE.md.
#>
[CmdletBinding()]
param(
    [string]$Path = (Get-Location).Path,
    [string]$Repo = 'https://github.com/susantokun/claude-setup.git',
    [switch]$Force,
    [switch]$SkipMcp,
    [switch]$SkipClaudeMd
)

$ErrorActionPreference = 'Stop'

function Write-Step { param([string]$Message) Write-Host "  + $Message" -ForegroundColor Green }
function Write-Skip { param([string]$Message) Write-Host "  - $Message" -ForegroundColor DarkGray }

# Sumber ----------------------------------------------------------------------
# Dijalankan dari clone lokal: pakai folder script. Dijalankan lewat irm | iex:
# $PSScriptRoot kosong, jadi repo di-clone dulu ke folder sementara.
$temp = $null
$source = $PSScriptRoot

if (-not $source -or -not (Test-Path -LiteralPath (Join-Path $source '.claude/skills'))) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "git tidak ditemukan di PATH. Pasang git, atau clone repo lalu jalankan install.ps1 dari sana."
    }
    $temp = Join-Path ([System.IO.Path]::GetTempPath()) "claude-setup-$([guid]::NewGuid())"
    Write-Host "Mengambil claude-setup dari $Repo ..." -ForegroundColor DarkGray
    git clone --depth 1 --quiet $Repo $temp
    if ($LASTEXITCODE -ne 0) { throw "Gagal clone $Repo" }
    $source = $temp
}

try {
    $target = (Resolve-Path -LiteralPath $Path).Path
    if ($source -eq $target) {
        throw "Target sama dengan sumber. Jalankan script ini dari root project tujuan."
    }

    $isLaravel = Test-Path -LiteralPath (Join-Path $target 'artisan')
    $uiPath = $isLaravel ? 'resources/js/components/ui' : 'src/components/ui'

    Write-Host "`nclaude-setup -> $target" -ForegroundColor Cyan
    Write-Host ("Project terdeteksi sebagai: " + ($isLaravel ? 'Laravel' : 'non-Laravel')) -ForegroundColor Cyan
    Write-Host ''

    # 1. Skill ----------------------------------------------------------------
    Write-Host 'Skill' -ForegroundColor White
    $skillsTarget = Join-Path $target '.claude/skills'
    New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null

    foreach ($skill in Get-ChildItem -Directory (Join-Path $source '.claude/skills')) {
        $dest = Join-Path $skillsTarget $skill.Name
        if ((Test-Path -LiteralPath $dest) -and -not $Force) {
            Write-Skip "$($skill.Name) sudah ada, lewati (pakai -Force untuk menimpa)"
            continue
        }
        Copy-Item -Recurse -Force -LiteralPath $skill.FullName -Destination $skillsTarget
        Write-Step $skill.Name
    }

    # 2. Permission -----------------------------------------------------------
    Write-Host "`nPermission" -ForegroundColor White
    $settingsTarget = Join-Path $target '.claude/settings.local.json'
    # settings.local.json biasanya di-gitignore, jadi tidak ikut saat repo di-clone.
    # Pakai punya sumber kalau ada, kalau tidak jatuh ke template yang ter-commit.
    $settingsSource = Join-Path $source '.claude/settings.local.json'
    if (-not (Test-Path -LiteralPath $settingsSource)) {
        $settingsSource = Join-Path $source '.claude/settings.local.example.json'
    }

    if (Test-Path -LiteralPath $settingsTarget) {
        Write-Skip 'settings.local.json sudah ada, lewati'
    } elseif (Test-Path -LiteralPath $settingsSource) {
        Copy-Item -LiteralPath $settingsSource -Destination $settingsTarget
        Write-Step 'settings.local.json'
    } else {
        Write-Skip 'sumber settings.local.json tidak ditemukan, lewati'
    }

    $gitignore = Join-Path $target '.gitignore'
    $ignoreLine = '/.claude/settings.local.json'
    $ignored = (Test-Path -LiteralPath $gitignore) -and
               ((Get-Content -LiteralPath $gitignore) -contains $ignoreLine)
    if ($ignored) {
        Write-Skip '.gitignore sudah memuat settings.local.json'
    } else {
        Add-Content -LiteralPath $gitignore -Value "`n# Permission Claude Code, khusus mesin ini`n$ignoreLine"
        Write-Step '.gitignore diperbarui'
    }

    # 3. MCP server -----------------------------------------------------------
    if (-not $SkipMcp) {
        Write-Host "`nMCP server" -ForegroundColor White
        $mcpTarget = Join-Path $target '.mcp.json'
        $incoming = Get-Content -Raw -LiteralPath (Join-Path $source '.mcp.json') |
                    ConvertFrom-Json -AsHashtable

        if (-not $isLaravel) {
            $incoming.mcpServers.Remove('laravel-boost')
            Write-Skip 'laravel-boost dilewati, project bukan Laravel'
        }

        if (Test-Path -LiteralPath $mcpTarget) {
            $existing = Get-Content -Raw -LiteralPath $mcpTarget | ConvertFrom-Json -AsHashtable
            if (-not $existing.ContainsKey('mcpServers')) { $existing.mcpServers = @{} }
            foreach ($name in $incoming.mcpServers.Keys) {
                if ($existing.mcpServers.ContainsKey($name)) {
                    Write-Skip "$name sudah terdaftar, lewati"
                } else {
                    $existing.mcpServers[$name] = $incoming.mcpServers[$name]
                    Write-Step $name
                }
            }
            $existing | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $mcpTarget
        } else {
            $incoming | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $mcpTarget
            $incoming.mcpServers.Keys | ForEach-Object { Write-Step $_ }
        }
    }

    # 4. Konvensi CLAUDE.md ---------------------------------------------------
    if (-not $SkipClaudeMd) {
        Write-Host "`nKonvensi" -ForegroundColor White
        $claudeMd = Join-Path $target 'CLAUDE.md'
        $snippet = (Get-Content -Raw -LiteralPath (Join-Path $source 'CLAUDE.snippet.md')).
                   Replace('resources/js/components/ui', $uiPath)

        $alreadyThere = (Test-Path -LiteralPath $claudeMd) -and
                        ((Get-Content -Raw -LiteralPath $claudeMd) -match '(?m)^# Package manager$')
        if ($alreadyThere) {
            Write-Skip 'CLAUDE.md sudah memuat konvensi, lewati'
        } else {
            Add-Content -LiteralPath $claudeMd -Value "`n$snippet"
            Write-Step "CLAUDE.md (+ path UI: $uiPath)"
        }
    }

    # Penutup -----------------------------------------------------------------
    Write-Host "`nSelesai. Langkah berikutnya:" -ForegroundColor Cyan
    Write-Host '  1. Restart Claude Code, lalu approve MCP server saat diminta.'
    Write-Host '  2. npx shadcn@latest add field dialog alert-dialog table'
    Write-Host '  3. npm i @tanstack/react-table'
    if (-not $isLaravel) {
        Write-Host '  4. Cek CLAUDE.md: daftar perintah terlarang masih berisi contoh Laravel.'
    }
    Write-Host ''
}
finally {
    if ($temp -and (Test-Path -LiteralPath $temp)) {
        Remove-Item -Recurse -Force -LiteralPath $temp
    }
}
