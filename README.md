# BrawlCodeGenerator

PowerShell module for converting between numeric player IDs and hashtag codes in Brawl Stars.

## Execution Policy
Type `Set-ExecutionPolicy Bypass` for normal installation

## Features
- Convert player ID to game tag (e.g. `#QYUURGGQ`)
- Convert game tag back to player ID
- Supports both 32-bit and 64-bit ID formats

## Installation
1. Download the module archive
2. Extract the contents to one of your PowerShell modules folders:
   - For all users: `C:\Program Files\WindowsPowerShell\Modules\`
   - For current user: `C:\Users\username\Documents\WindowsPowerShell\Modules\`
3. The extracted folder should be named `BrawlCodeGenerator` (containing the .psm1 file)
4. Verify installation by running: `Get-Module -ListAvailable BrawlCodeGenerator`

## Examples
```powershell
# Convert ID to tag
ConvertTo-LogicLongCode -Id 3056576 -HighId 15

# Convert tag to ID
ConvertFrom-LogicLongCode -Code "#QYUURGGQ"
```

## Requirements
- PowerShell 5.1 or newer

## Notes
- You may need to run `Import-Module BrawlCodeGenerator` after installation
- If you get execution policy errors, run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
