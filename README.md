# BrawlCodeGenerator

PowerShell module for converting between numeric player IDs and hashtag codes in Brawl Stars.

## Features
- Convert player ID to game tag (e.g. `#QYUURGGQ`)
- Convert game tag back to player ID
- Supports both 32-bit and 64-bit ID formats

## Installation
```powershell
Install-Module -Name BrawlCodeGenerator -Force
```

## Examples
```powershell
# Convert ID to tag
ConvertTo-LogicLongCode -Id 3056576

# Convert tag to ID
ConvertFrom-LogicLongCode -Code "#QYUURGGQ"
```

## Requirements
- PowerShell 5.1 or newer
