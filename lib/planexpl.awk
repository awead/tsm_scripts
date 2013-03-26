# Explode a recovery plan file into separate files (macros,scripts,
# volume history file etc.).
#
# Invoke with:
#   awk -f planexpl.awk recoveryplanfilename      (On SUN use nawk)
# Where:
#   recoveryplanfilename is the name of the recovery plan file created
#               by the DRM PREPARE command.
#
BEGIN {
      prefix = "";
      outFileName = "";
      firstRemove = 1;
      }
      {
      if (match($1,"end") == 1)
         {
         close(outFileName);
         if (match($2,"RECOVERY.SCRIPT.DISASTER.RECOVERY.MODE") ||
            match($2,"RECOVERY.SCRIPT.NORMAL.MODE")             ||
            match($2,"PRIMARY.VOLUMES.REPLACEMENT.CREATE"))
            {
            system("chmod u+x "outFileName);
            }
         outFileName = "";
         }
      if (outFileName != "")
         {
         aline = $0;
         print aline >> outFileName;
         }
	if (match($1,"DRM") == 1 && match($2,"PLANPREFIX") == 1)
         {

            if (substr($3,length($3)) == "/")
		 prefix = $3;
	
	    else
	       prefix = $3".";
	 }
      if (match($1,"begin") == 1 &&
         (match($2,"RECOVERY.SCRIPT.DISASTER.RECOVERY.MODE") ||
          match($2,"RECOVERY.SCRIPT.NORMAL.MODE")            ||
          match($2,"RECOVERY.VOLUMES.REQUIRED")              ||
          match($2,"RECOVERY.DEVICES.REQUIRED")              ||
          match($2,"DB.STORAGEPATHS")                        ||
          match($2,"ACTIVEDATASTGPOOL.VOLUMES.AVAILABLE")    ||
          match($2,"ACTIVEDATASTGPOOL.VOLUMES.DESTROYED")    ||
          match($2,"COPYSTGPOOL.VOLUMES.AVAILABLE")          ||
          match($2,"COPYSTGPOOL.VOLUMES.DESTROYED")          ||
          match($2,"PRIMARY.VOLUMES.DESTROYED")              ||
          match($2,"PRIMARY.VOLUMES.REPLACEMENT.CREATE")     ||
          match($2,"PRIMARY.VOLUMES.REPLACEMENT")            ||
          match($2,"STGPOOLS.RESTORE")                       ||
          match($2,"LICENSE.REGISTRATION")                   ||
          match($2,"RECOVERY.INSTRUCTIONS.GENERAL")          ||
          match($2,"RECOVERY.INSTRUCTIONS.OFFSITE")          ||
          match($2,"RECOVERY.INSTRUCTIONS.INSTALL")          ||
          match($2,"RECOVERY.INSTRUCTIONS.DATABASE")         ||
          match($2,"RECOVERY.INSTRUCTIONS.STGPOOL")          ||
          match($2,"VOLUME.HISTORY.FILE")                    ||
          match($2,"DEVICE.CONFIGURATION.FILE")              ||
          match($2,"DSMSERV.OPT.FILE")))
          {
          outFileName = prefix$2;
          system("rm "outFileName" 2>nul");
          print "Creating file ",outFileName;
          }
      }
END   {
      }
