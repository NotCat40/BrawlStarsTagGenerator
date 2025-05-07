<#
.SYNOPSIS
Converts between numeric IDs and hashtag codes used in games like Clash of Clans.

.DESCRIPTION
Provides functions to convert between numeric IDs and string codes in the format "#XXXXXX".
Uses the LogicLong class to represent high/low values of 64-bit integers.

.EXAMPLE
ConvertTo-LogicLongCode -Id 3056576
Returns: "#QYUURGGQ"

.EXAMPLE
ConvertFrom-LogicLongCode -Code "#QYUURGGQ"
Returns LogicLong object with High=15, Low=3056576
#>

class LogicLong {
    [long]$High
    [long]$Low

    LogicLong([long]$high, [long]$low) {
        $this.High = $high
        $this.Low = $low
    }

    [string] ToString() {
        return "High: $($this.High), Low: $($this.Low)"
    }
}

function ConvertTo-LogicLongCode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [long]$Id,
        [long]$HighId = 0,
        [switch]$Use64Bit
    )

    begin {
        $CONVERSION_CHARS = "0289PYLQGRJCUV"
        $HASHTAG = "#"
    }

    process {
        try {
            if ($Use64Bit) {
                # Full 64-bit conversion
                $code = $HASHTAG + (ConvertTo-InternalCode -Value $Id -Chars $CONVERSION_CHARS)
                return $code
            }
            else {
                # Traditional 32-bit compatible conversion
                if ($HighId -ne 0) {
                    # Если задана High-часть, объединяем с Low по оригинальной логике
                    $combinedValue = ($Id -shl 8) -bor ($HighId -band 0xFF)
                    $code = $HASHTAG + (ConvertTo-InternalCode -Value $combinedValue -Chars $CONVERSION_CHARS)
                    return $code
                }
                else {
                    # Если HighId = 0, работаем только с Low-частью
                    $code = $HASHTAG + (ConvertTo-InternalCode -Value $Id -Chars $CONVERSION_CHARS)
                    return $code
                }
            }
        }
        catch {
            Write-Error "Error converting ID to code: $_"
        }
    }
}

function ConvertFrom-LogicLongCode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Code
    )

    begin {
        $CONVERSION_CHARS = "0289PYLQGRJCUV"
    }

    process {
        try {
            if (-not $Code.StartsWith('#')) {
                throw "Code must start with '#'"
            }

            if ($Code.Length -gt 13) {
                throw "Code too long. Maximum length is 12 characters (excluding #)"
            }

            $idCode = $Code.Substring(1)
            $id = ConvertFrom-InternalCode -Code $idCode -Chars $CONVERSION_CHARS

            if ($id -eq -1) {
                throw "Invalid characters in code"
            }

            # Check if this is a traditional 32-bit compatible code
            if ($id -lt [math]::Pow(2, 40)) {
                $high = $id -band 0xFF
                $low = $id -shr 8
                return [LogicLong]::new($high, $low)
            }
            else {
                # Full 64-bit ID
                $high = $id -shr 32
                $low = $id -band 0xFFFFFFFF
                return [LogicLong]::new($high, $low)
            }
        }
        catch {
            Write-Error "Error converting code to ID: $_"
            return [LogicLong]::new(-1, -1)
        }
    }
}

# Internal helper functions
function ConvertTo-InternalCode {
    param(
        [long]$Value,
        [string]$Chars
    )

    if ($Value -lt 0) { return $null }

    $code = New-Object char[] 12
    $charsCount = $Chars.Length

    for ($i = 11; $i -ge 0; $i--) {
        $code[$i] = $Chars[[int]($Value % $charsCount)]
        $Value = [Math]::Floor($Value / $charsCount)

        if ($Value -eq 0) {
            return [string]::new($code, $i, 12 - $i)
        }
    }

    return [string]::new($code)
}

function ConvertFrom-InternalCode {
    param(
        [string]$Code,
        [string]$Chars
    )

    $id = 0
    $charsCount = $Chars.Length
    $codeLength = $Code.Length

    for ($i = 0; $i -lt $codeLength; $i++) {
        $charIndex = $Chars.IndexOf($Code[$i])

        if ($charIndex -eq -1) {
            return -1
        }

        $id = $id * $charsCount + $charIndex
    }

    return $id
}
Export-ModuleMember -Function ConvertFrom-LogicLongCode, ConvertTo-LogicLongCode