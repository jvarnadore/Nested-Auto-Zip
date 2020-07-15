#Compress files and create archive.

<# We want to go here \\tn-web\exported email\2017\archive2017_06\2017_0601_20190820-0954\messages
Compress all the .emls in this folder to an archive.
And then repeat.
#>

<# Things we're definitely going to need:
   1) List of the folderes we want to repeat this job for.
   2) A script that will go into $folder, go into the messages subdirectory, and then compress all of the .emls in the folder into a zip called $folder
#>
#Script would start with using -Path on the Year folder and getting a list of folders named after months.
$MonthFolderList = Get-ChildItem -Path "\\tn-web\exported email\Testing";

#A double foreach nest to get into each day's folder inside each month.
foreach ($MonthFolder in $MonthFolderList) {
   $DayFolderList = Get-ChildItem -Path $MonthFolder.FullName;
   foreach ($DayFolder in $DayFolderList) {
       #Turning $DayFolder.FullName into a variable we can use for naming.
      $DayFolderFullName = $DayFolder.FullName;
      #Each Day folder holdes it's EMLs in a nested folder, so we append it here and designate what we're looking for.
      $DayFolderPath = $DayFolderFullName += "\messages\*.eml";
      #split up the complicated naming formule based on the numerous _ in the name.
      $ArchiveSplitName = $DayFolder.Name -split "_";
      #And IF/Else statement to filter out whether or not the archive should included _spam at the end.
      if ($ArchiveSplitName[2] -eq "spam"){
         $ArchiveName = $ArchiveSplitName[0] + "_" +  $ArchiveSplitName[1] + "_" + $ArchiveSplitName[2];
      }
      Else {
         $ArchiveName = $ArchiveSplitName[0] + "_" +  $ArchiveSplitName[1];
      }
      #Creating the variable used for our Compress-Archive path
      $DestinationPath = $DayFolder.FullName + "\messages\" + $ArchiveName;
      #Executing the compress command.
      Compress-Archive -path $DayFolderPath -DestinationPath $DestinationPath -CompressionLevel Fastest;
      #notification of the completion of each archive.
      Write-Host $ArchiveName "has been created.";
   }
}
