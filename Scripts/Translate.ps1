foreach($file in Get-ChildItem '.\English\*.txt')
{
    $Content = Get-Content -Encoding UTF8 $file.fullname
    $Content.Count
    
    $GerPath = (Join-Path '.\German_deepl\' -ChildPath (Split-Path $file.fullname -Leaf))
    $TransPath = (Join-Path '.\Translation\' -ChildPath (Split-Path $file.fullname -Leaf))
    if(Test-Path $TransPath) {Remove-Item $TransPath }
    #Write-Host $GerPath

    $ContentGerman = Get-Content -Encoding UTF8 $GerPath 
    $ContentGerman.count
    $i =0
    Foreach($line in $Content){
        $newline = ''
        if($line.Trim() -ne ''){
            $newline= $line.split(';')[0] + ';' + $ContentGerman[$i].Split(';')[1]
        }
        $i++
        $newline | Out-File -Append  -FilePath $TransPath 
    }
    
}