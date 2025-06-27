// function of this macro is to copy out single color MIPs from composite stacks for downstream CellProfiler analysis of GFP-Parkin  
  function ChannelCopy(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_Channels";
  		File.makeDirectory(outfinal);
  		
  		origname = getTitle;
		
		// dublicate Parkin
			run("Select All");
			run("Duplicate...", "title=Parkin duplicate channels=2");
			488name = getTitle();
		
		// dublicate DNA
			selectWindow(origname);
			run("Select All");
			run("Duplicate...", "title=DNA duplicate channels=1");
			568name = getTitle();
    			
		// dublicate Mito
			selectWindow(origname);
			run("Select All");
			run("Duplicate...", "title=HSP60 duplicate channels=3");
			647name = getTitle();
     	
     	
     	// saves the 488 channel as Parkin
			selectWindow("Parkin");
			maskname1 = origname + "Parkin";
			saveAs("Tiff", outfinal + maskname1 +"-"+i);

		// saves the 568 channel as DNA
			selectWindow("DNA");
			maskname2 = origname + "DNA";
			saveAs("Tiff", outfinal + maskname2 +"-"+i);

		// saves the 647 channel as HSP60
			selectWindow("HSP60");
			maskname3 = origname + "HSP60";
			saveAs("Tiff", outfinal + maskname3 +"-"+i);
		
        // close all windows        
  		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        ChannelCopy(input, list[i]);