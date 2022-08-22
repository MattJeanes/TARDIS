$sourceLanguageFolder = Join-Path $PSScriptRoot "i18n/languages"
$targetLanguageFolder = Join-Path $PSScriptRoot "lua/tardis/languages"

$sourceLanguageCode = "en"
$sourceLanguage = Get-Content -Raw (Join-Path $sourceLanguageFolder "$sourceLanguageCode.json") | ConvertFrom-Json -AsHashtable
$targetLanguageFolder | Get-ChildItem | Remove-Item

Get-ChildItem $sourceLanguageFolder | ForEach-Object {
    $code = $_.BaseName
    $languageFile = Get-Content -Raw $_.FullName
    $language = $languageFile | ConvertFrom-Json -AsHashtable
    $targetFilename = Join-Path $targetLanguageFolder "$($code.ToLower()).lua"

    $content = "-- AUTO GENERATED FILE - DO NOT EDIT --`n"
    $content += "-- SOURCE FILE: i18n/languages/$($_.Name) --`n`n"
    $content += "local T = {}`n"
    $content += "T.Code = `"$code`"`n"
    $content += "T.Name = `"$($language.Name)`"`n"
    $content += "T.Phrases = {`n"

    $changes = $false
    $language.Phrases.Keys | Sort-Object | ForEach-Object {
        $key = $_
        $phrase = $language.Phrases[$key]
        if (-not $changes -and $sourceLanguage.Phrases[$key] -ne $phrase) {
            $changes = $true
        }
        $phrase = $phrase.Replace("`n", "\n")
        $phrase = $phrase.Replace("`"", "\`"")
        $content += "    [`"$key`"] = `"$phrase`",`n"
    }

    if (-not $changes -and $sourceLanguageCode -ne $code) {
        Write-Warning "No phrases changed in $code compared to $sourceLanguageCode baseline, skipping.."
        return
    }

    $content += "}`n`n"
    $content += "TARDIS:AddLanguage(T)`n"

    Set-Content -NoNewline -Path $targetFilename -Value $content
}