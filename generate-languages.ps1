$sourceLanguageFolder = Join-Path $PSScriptRoot "i18n/languages"
$targetLanguageFolder = Join-Path $PSScriptRoot "lua/tardis/languages"

$targetLanguageFolder | Get-ChildItem | Remove-Item

$originLanguage = Get-Content -Raw (Join-Path $sourceLanguageFolder "en.json") | ConvertFrom-Json -AsHashtable

Get-ChildItem $sourceLanguageFolder | ForEach-Object {
    $code = $_.BaseName
    $language = Get-Content -Raw $_.FullName | ConvertFrom-Json -AsHashtable

    $sortedPhrases = [ordered]@{}
    $language.Phrases.Keys | Where-Object { -not $originLanguage.Phrases.Contains($_) } | ForEach-Object {
        Write-Warning "Removing orphaned phrase $_ from language $code"
    }
    $originLanguage.Phrases.Keys | Sort-Object | ForEach-Object {
        $key = $_
        if ($language.Phrases.Contains($key)) {
            $phrase = $language.Phrases[$key]
        }
        else {
            Write-Host "Adding placeholder for missing phrase $key in language $code"
            $phrase = [string]::Empty
        }
        $phrase = $language.Phrases.Contains($key) ? $language.Phrases[$key] : [string]::Empty
        $sortedPhrases[$key] = $phrase
    }

    $language.Phrases = $sortedPhrases

    $language | ConvertTo-Json | Set-Content -Path $_.FullName
    
    $targetFilename = Join-Path $targetLanguageFolder "$($code.ToLower()).lua"

    if (-not $language.Name) {
        Write-Warning "Language $code has no name, skipping.."
        return
    }

    if ((-not $language.Phrases) -or ($language.Phrases.Keys.Count -eq 0)) {
        Write-Warning "Language $code has no phrases, skipping.."
        return
    }

    $content = [System.Text.StringBuilder]::new()

    $null = $content.AppendLine("-- AUTO GENERATED FILE - DO NOT EDIT --")
    $null = $content.AppendLine("-- SOURCE FILE: i18n/languages/$($_.Name) --")
    $null = $content.AppendLine()
    $null = $content.AppendLine("local T = {}")
    $null = $content.AppendLine("T.Code = `"$code`"")
    $null = $content.AppendLine("T.Name = `"$($language.Name)`"")
    $null = $content.AppendLine("T.Phrases = {")

    $language.Phrases.Keys | Where-Object { $language.Phrases[$_] } | Sort-Object | ForEach-Object {
        $key = $_
        $phrase = $language.Phrases[$key]
        $phrase = $phrase.Replace("`n", "\n")
        $phrase = $phrase.Replace("`"", "\`"")
        $null = $content.AppendLine("    [`"$key`"] = `"$phrase`",")
    }

    $null = $content.AppendLine("}")
    $null = $content.AppendLine()
    $null = $content.AppendLine("TARDIS:AddLanguage(T)")

    Write-Host "Writing language $code to $targetFilename"

    Set-Content -NoNewline -Path $targetFilename -Value $content
}