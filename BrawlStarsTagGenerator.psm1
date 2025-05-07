<#
.SYNOPSIS
Converts between numeric IDs and hashtag codes used in Brawl Stars.

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

<#
.SYNOPSIS
Converts between numeric IDs and hashtag codes used in Brawl Stars.
#>

class LogicLong {
    [int]$High
    [int]$Low

    LogicLong([int]$high, [int]$low) {
        $this.High = $high
        $this.Low = $low
    }

    [string] ToString() {
        return "High: $($this.High), Low: $($this.Low)"
    }
}

function ConvertTo-LogicLongCode {
    [CmdletBinding(DefaultParameterSetName='ByLogicLong')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='ByLogicLong')]
        [long]$LogicLong,
        
        [Parameter(Mandatory=$true, ParameterSetName='ByParts')]
        [long]$Id,
        
        [Parameter(ParameterSetName='ByParts')]
        [int]$HighId = 0
    )

    $CONVERSION_CHARS = "0289PYLQGRJCUV"
    $HASHTAG = "#"

    if ($PSCmdlet.ParameterSetName -eq 'ByParts') {
        if ($HighId -lt 256) {
            $value = ($Id -shl 8) -bor $HighId
            return $HASHTAG + (ConvertTo-Base -Value $value -Chars $CONVERSION_CHARS)
        }
        return $null
    }
    else {
        $highValue = ($LogicLong -shr 32) -band 0xFFFFFFFF
        if ($highValue -lt 256) {
            $lowerInt = $LogicLong -band 0xFFFFFFFF
            $value = ($lowerInt -shl 8) -bor $highValue
            return $HASHTAG + (ConvertTo-Base -Value $value -Chars $CONVERSION_CHARS)
        }
        return $null
    }
}

function ConvertFrom-LogicLongCode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Code
    )

    $CONVERSION_CHARS = "0289PYLQGRJCUV"

    if ($Code.Length -lt 14) {
        $idCode = $Code.Substring(1)
        $id = ConvertFrom-Base -Code $idCode -Chars $CONVERSION_CHARS

        if ($id -ne -1) {
            $high = $id % 256
            $low = ($id -shr 8) -band 0x7FFFFFFF
            return [LogicLong]::new($high, $low)
        }
    }
    else {
        Write-Warning "Cannot convert the string to code. String is too long."
    }

    return [LogicLong]::new(-1, -1)
}

function ConvertTo-Base {
    param(
        [long]$Value,
        [string]$Chars
    )

    $code = New-Object char[] 12
    $conversionCharsCount = $Chars.Length

    for ($i = 11; $i -ge 0; $i--) {
        $code[$i] = $Chars[$Value % $conversionCharsCount]
        $Value = [Math]::Floor($Value / $conversionCharsCount)

        if ($Value -eq 0) {
            return [string]::new($code, $i, 12 - $i)
        }
    }

    return [string]::new($code)
}

function ConvertFrom-Base {
    param(
        [string]$Code,
        [string]$Chars
    )

    $id = 0
    $conversionCharsCount = $Chars.Length
    $codeCharsCount = $Code.Length

    for ($i = 0; $i -lt $codeCharsCount; $i++) {
        $charIndex = $Chars.IndexOf($Code[$i])

        if ($charIndex -eq -1) {
            return -1
        }

        $id = $id * $conversionCharsCount + $charIndex
    }

    return $id
}

Export-ModuleMember -Function ConvertFrom-LogicLongCode, ConvertTo-LogicLongCode
