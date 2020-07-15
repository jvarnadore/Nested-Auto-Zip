#Compress files and create archive.

<# We want to go here \\tn-web\exported email\2017\archive2017_06\2017_0601_20190820-0954\messages
Compress all the .emls in this folder to an archive.
And then repeat.
#>

<# Things we're definitely going to need:
   1) List of the folderes we want to repeat this job for.
   2) A script that will go into $folder, go into the messages subdirectory, and then compress all of the .emls in the folder into a zip called $folder
#>

$MonthFolderList = Get-ChildItem -Path "\\tn-web\exported email\Testing";

foreach ($MonthFolder in $MonthFolderList) {
   $DayFolderList = Get-ChildItem -Path $MonthFolder.FullName;
   foreach ($DayFolder in $DayFolderList) {
      $DayFolderFullName = $DayFolder.FullName;
      $DayFolderPath = $DayFolderFullName += "\messages\*.eml";
      $ArchiveSplitName = $DayFolder.Name -split "_";
      if ($ArchiveSplitName[2] -eq "spam"){
         $ArchiveName = $ArchiveSplitName[0] + "_" +  $ArchiveSplitName[1] + "_" + $ArchiveSplitName[2];
      }
      Else {
         $ArchiveName = $ArchiveSplitName[0] + "_" +  $ArchiveSplitName[1];
      }
      $DestinationPath = $DayFolder.FullName + "\messages\" + $ArchiveName;
      Compress-Archive -path $DayFolderPath -DestinationPath $DestinationPath -CompressionLevel Fastest;
      Write-Host $ArchiveName "has been created.";
   }
}
