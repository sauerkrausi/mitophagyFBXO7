	function mtDNA(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_Eval/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "area integrated area_fraction redirect=None decimal=3");
		Stack.getDimensions(w, h, channels, slices, frames);
		
       	origname = getTitle;
       	run("Select All");

		// dublicate 488 channels, and subtract nucleus to get only mtDNA signal 
		selectWindow(origname);
		run("Duplicate...", "title=mtDNA duplicate channels=1");
		run("Subtract Background...", "rolling=10");
		setAutoThreshold("Otsu dark");
		//run("Threshold...");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		rename("mtDNA");

		// dublicate 405 channels, subtact background and convert to binary file  for nuclear mask
		selectWindow(origname);
		run("Duplicate...", "title=NUC duplicate channels=2");
		run("Gaussian Blur...", "sigma=2 scaled");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Dilate");
		run("Fill Holes");

		
		imageCalculator("Subtract create stack", "mtDNA","NUC");
		selectWindow("Result of mtDNA");
		rename("mtDNAonly");
		
		// measure particles, change size if you would like to change the lower size cutoff 
		// save results as csv files
		// saves the 488 channel with overlay of analyzed objects also in the folder 
		run("Analyze Particles...", "size=0.05-3 show=[Overlay Masks] display exclude summarize");
				
		csvname = origname + "mtDNAfoci" + ".csv"; 
        saveAs("Results", outfinal + i+"_mtDNA_"+csvname);
     	run("Close");
     	
		selectWindow("mtDNAonly");
		maskname = origname + "mtDNA";
		saveAs("Tiff", outfinal + i+"_"+ maskname);
		run("Close"); 

		// measure Nucelar particles, change size if you would like to change the lower size cutoff 
		// save results as csv files
		// saves the 405 channel with overlay of analyzed objects also in the folder 
		selectWindow("NUC");
		run("Analyze Particles...", "size=10-Infinity show=[Overlay Masks] display exclude summarize");
		
		csvname = origname + "mtDNAfoci" + ".csv"; 
        saveAs("Results", outfinal + i+"_NUC_"+csvname);
     	run("Close");

		selectWindow("NUC");
		maskname = origname + "NUC";
		saveAs("Tiff", outfinal + i+"_"+ maskname);
        
        // close all windows        
   		run("Close"); 
     run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        mtDNA(input, list[i]);