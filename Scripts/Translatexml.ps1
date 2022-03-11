foreach($file in Get-ChildItem '.\English\*.xml')
{
    $Content = [xml] (Get-Content -Encoding UTF8 $file.fullname)
    $GerPath = (Join-Path '.\German_deepl\' -ChildPath (Split-Path $file.fullname -Leaf))
    $TransPath = (Join-Path '.\Translation\' -ChildPath (Split-Path $file.fullname -Leaf)) + "_deepl.txt"
    
    
    if(!(Test-Path $TransPath)) {
      '<Dat>' | Out-File  $TransPath 
    
        $i=0
        foreach($item in $Content.ArrayOfGameEvent.GameEvent.TriggerActions.GameEventAction.MessageTitle){
          if($item.Trim() -ne ''){
              '<MT>' | Out-File  $TransPath -Appen
              
              $item  = $item  -replace '<', '&lt;'
              $item  = $item  -replace '>', '&gt;'
              
              $item | Out-File  $TransPath -Append
              '</MT>' | Out-File  $TransPath -Append
          } else {'<MT></MT>' | Out-File  $TransPath -Append}

          if(($Content.ArrayOfGameEvent.GameEvent.TriggerActions.GameEventAction.Description)[$i].Trim() -ne ''){
              '<Des>' | Out-File  $TransPath -Append
              $text = ($Content.ArrayOfGameEvent.GameEvent.TriggerActions.GameEventAction.Description)[$i]
              $text = $text -replace '<', '&lt;'
              $text = $text -replace '>', '&gt;'
               $text | Out-File  $TransPath -Append
              '</Des>' | Out-File  $TransPath -Append
         } else {'<Des></Des>' | Out-File  $TransPath -Append}
          $i++
        }
       '</Dat>' | Out-File  $TransPath -Append
     }

     #Wieder zusammen bauen
     $TransPathGer = (Join-Path '.\Translation\' -ChildPath (Split-Path $file.fullname -Leaf)) + "_deeplGer.txt"
     $ContentGer = [xml] (Get-Content -Encoding UTF8 $TransPathGer)

        $nm= $Content.SelectNodes('/ArrayOfGameEvent/GameEvent/TriggerActions/GameEventAction/MessageTitle')
        $nd= $Content.SelectNodes('/ArrayOfGameEvent/GameEvent/TriggerActions/GameEventAction/Description')  
   
     for($i=0; $i -lt $ContentGer.Dat.MT.Count;$i++){ 
        $message = $ContentGer.Dat.MT[$i]
        $des = $ContentGer.Dat.Des[$i]
        
        $nm[$i].InnerText = $message.Trim()
        $nd[$i].InnerText =  $des.Trim() 
        #Write-Host $($i+' ') -NoNewline
     }
     
     $TransPathxml = (Join-Path '.\Translation\' -ChildPath (Split-Path $file.fullname -Leaf)) 
     $Content.Save($TransPathxml)


}


