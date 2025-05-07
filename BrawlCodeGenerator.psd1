@{
    RootModule        = 'BrawlCodeGenerator.psm1'
    ModuleVersion     = '1.0'  # <- Исправлено: добавлен патч-версии (1.0.0 вместо 1.0)
    GUID              = 'f48a69b4-59bb-4c13-b2c8-d2410da85116'
    Author            = 'NotCat'
    CompanyName       = 'Unknown'
    Copyright         = '(c) NotCat. All rights reserved.'
    Description       = 'Brawl Stars Code Generator'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('ConvertFrom-LogicLongCode', 'ConvertTo-LogicLongCode')
    CmdletsToExport   = @()  # <- Оставьте пустым, если нет cmdlets
}