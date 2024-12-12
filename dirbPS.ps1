# Configuration
$targetUrl = "http://perdu.com" # Remplace par le site cible
$wordlistPath = "wordlist.txt" # Chemin vers la liste de dictionnaires

# Vérifier si le fichier de wordlist existe
if (-Not (Test-Path $wordlistPath)) {
    Write-Host "Le fichier de wordlist n'existe pas : $wordlistPath" -ForegroundColor Red
    exit
}

# Charger la liste de mots
$wordlist = Get-Content $wordlistPath

# Créer un client Web
$webClient = New-Object System.Net.WebClient

# Fonction pour tester un répertoire
function Test-Directory {
    param (
        [string]$url
    )
    try {
        $response = $webClient.DownloadString($url)
        Write-Host "[+] Trouvé : $url" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -ne "404") {
            Write-Host "[-] Erreur sur $url : $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
        }
    }
}

# Énumération des répertoires
foreach ($word in $wordlist) {
    $testUrl = "$targetUrl/$word"
    Test-Directory -url $testUrl
}
