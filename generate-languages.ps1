$sourceLanguageFolder = Join-Path $PSScriptRoot "i18n/languages"
$targetLanguageFolder = Join-Path $PSScriptRoot "lua/tardis/languages"

Get-ChildItem $sourceLanguageFolder | ForEach-Object {
    $code = $_.BaseName
    $language = Get-Content -Raw $_.FullName | ConvertFrom-Json -AsHashtable
    $targetFilename = Join-Path $targetLanguageFolder "$($code.ToLower()).lua"

    $content = "-- AUTO GENERATED FILE - DO NOT EDIT --`n"
    $content += "-- SOURCE FILE: i18n/languages/$($_.Name) --`n`n"
    $content += "local T = {}`n"
    $content += "T.Code = `"$code`"`n"
    $content += "T.Name = `"$($language.Name)`"`n"
    $content += "T.Phrases = {`n"

    $language.Phrases.Keys | Sort-Object | ForEach-Object {
        $key = $_
        $phrase = $language.Phrases[$key]
        $phrase = $phrase.Replace("`n", "\n")
        $phrase = $phrase.Replace("`"", "\`"")
        $content += "    [`"$key`"] = `"$phrase`",`n"
    }

    $content += "}`n`n"
    $content += "TARDIS:AddLanguage(T)`n"

    Set-Content -NoNewline -Path $targetFilename -Value $content
}