# Function to take ownership and grant full control
function Grant-FullControl {
    param (
        [string]$path
    )
    try {
        icacls $path /grant Everyone:F /T /C
        Write-Output "Granted full control to: $path"
    } catch {
        Write-Output "Failed to grant full control to: $path - $($_.Exception.Message)"
    }
}

# Function to clear Edge temporary files
function Clear-EdgeTempFiles {
    try {
        $edgeDataPath = "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache"
        if (Test-Path -Path $edgeDataPath) {
            Grant-FullControl -path $edgeDataPath
            Remove-Item -Path $edgeDataPath -Recurse -Force
            Write-Output "Edge temporary files cleared successfully."
        } else {
            Write-Output "Edge cache path not found."
        }
    } catch {
        Write-Output "Failed to clear Edge temporary files - $($_.Exception.Message)"
    }
}

# Function to clear Chrome temporary files
function Clear-ChromeTempFiles {
    try {
        $chromeDataPath = "$env:LocalAppData\Google\Chrome\User Data\Default\Cache"
        if (Test-Path -Path $chromeDataPath) {
            Grant-FullControl -path $chromeDataPath
            Remove-Item -Path $chromeDataPath -Recurse -Force
            Write-Output "Chrome temporary files cleared successfully."
        } else {
            Write-Output "Chrome cache path not found."
        }
    } catch {
        Write-Output "Failed to clear Chrome temporary files - $($_.Exception.Message)"
    }
}

# Function to clear Firefox temporary files
function Clear-FirefoxTempFiles {
    try {
        $firefoxProfilePath = "$env:AppData\Mozilla\Firefox\Profiles"
        if (Test-Path -Path $firefoxProfilePath) {
            $firefoxCachePaths = Get-ChildItem -Path $firefoxProfilePath -Recurse -Filter "cache2"
            foreach ($cachePath in $firefoxCachePaths) {
                Grant-FullControl -path $cachePath.FullName
                Remove-Item -Path $cachePath.FullName -Recurse -Force
            }
            Write-Output "Firefox temporary files cleared successfully."
        } else {
            Write-Output "Firefox profile path not found."
        }
    } catch {
        Write-Output "Failed to clear Firefox temporary files - $($_.Exception.Message)"
    }
}

# Clear temporary internet files for all major browsers
Clear-InternetExplorerTempFiles
Clear-EdgeTempFiles
Clear-ChromeTempFiles
Clear-FirefoxTempFiles

Write-Output "Temporary internet files cleanup process completed."
