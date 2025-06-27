 function nucleiMIP(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_objects/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "centroid redirect=None decimal=3");
       	
       	origname = getTitle;
		/// duplicate nuclear channel, blur and convert to mask & post-filter
		Stack.getDimensions(width, height, channels, slices, frames);
		run("Duplicate...", "title=nuc duplicate channels=2");
		resetMinAndMax();
		run("Gaussian Blur...", "sigma=2");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Otsu background=Default calculate black");	
		run("Fill Holes", "stack");
		run("Analyze Particles...", "size=25-Infinity show=Overlay display exclude stack");

		// save results as csv files
		csvname = origname + "nuc" + ".csv"; 
        saveAs("Results", outfinal + i+"_nuc_"+csvname);
     	run("Close");
     	     		
		maskname = origname + "nuc";
		saveAs("Tiff", outfinal + i+"_"+ maskname);

        // close all windows        
   		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        nucleiMIP(input, list[i]);