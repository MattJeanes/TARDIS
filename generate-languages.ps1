$sourceLanguageFolder = Join-Path $PSScriptRoot "i18n/languages"
$targetLanguageFolder = Join-Path $PSScriptRoot "lua/tardis/languages"

$targetLanguageFolder | Get-ChildItem | Remove-Item

Get-ChildItem $sourceLanguageFolder | ForEach-Object {
    $code = $_.BaseName
    $languageFile = Get-Content -Raw $_.FullName
    $language = $languageFile | ConvertFrom-Json -AsHashtable
    $targetFilename = Join-Path $targetLanguageFolder "$($code.ToLower()).lua"

    if (-not $language.Name) {
        Write-Warning "Language $code has no name, skipping.."
        return
    }

    if ((-not $language.Phrases) -or ($language.Phrases.Keys.Count -eq 0)) {
        Write-Warning "Language $code has no phrases, skipping.."
        return
    }

    $content = "-- AUTO GENERATED FILE - DO NOT EDIT --`n"
    $content += "-- SOURCE FILE: i18n/languages/$($_.Name) --`n`n"
    $content += "local T = {}`n"
    $content += "T.Code = `"$code`"`n"
    $content += "T.Name = `"$($language.Name)`"`n"
    $content += "T.Phrases = {`n"

    $language.Phrases.Keys | Where-Object { $language.Phrases[$_] } | Sort-Object | ForEach-Object {
        $key = $_
        $phrase = $language.Phrases[$key]
        $phrase = $phrase.Replace("`n", "\n")
        $phrase = $phrase.Replace("`"", "\`"")
        $content += "    [`"$key`"] = `"$phrase`",`n"
    }

    $content += "}`n`n"
    $content += "TARDIS:AddLanguage(T)`n"

    Write-Host "Writing language $code to $targetFilename"

    Set-Content -NoNewline -Path $targetFilename -Value $content
}