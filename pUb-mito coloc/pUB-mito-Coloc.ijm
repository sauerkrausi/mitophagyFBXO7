// Function of this macro is to measure the coloc between HSP60 stain (mito) and pUb on confocal images stacks.  
  function pUbMito(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_Eval/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "area mean modal min bounding fit shape feret's integrated area_fraction redirect=None decimal=3");
		
       	origname = getTitle;

		// dublicate 488+561 channels, filter and convert to binary file 
		// mito channel
		run("Select All");
		name = getTitle();
		
		run("Duplicate...", "title=mito duplicate channels=2");
		run("Gaussian Blur...", "sigma=2");
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Close-");
		run("Fill Holes");

		//pUb channel
		selectWindow(origname);
		run("Duplicate...", "title=pUb duplicate channels=1");
		setAutoThreshold("Triangle dark");
		//run("Threshold...");
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Gaussian Blur...", "sigma=1");
		run("Convert to Mask");
		run("Analyze Particles...", "size=0.50-Infinity show=Outlines display exclude summarize");

		// save results as csv files
		csvname = origname + "pUb" + ".csv"; 
       	selectWindow("Results");
        saveAs("Results", outfinal + i+"_pUb_"+csvname);
		selectWindow("Results"); 
     	run("Close");
     	
     	// saves the pUbmask image also in the folder 
		selectWindow("pUb");
		maskname = origname + "pUb";
		saveAs("Tiff", outfinal + i+"_"+ maskname);



		// saves the mito-mask image also in the folder 
		selectWindow("mito");
		maskname = origname + "mito";
		saveAs("Tiff", outfinal + i+"_"+ maskname);
		
		// measure particles, change size if you would like to change the lower size cutoff 
		run("Analyze Particles...", "size=0.05-Infinity show=Outlines display exclude summarize");

		// save results as csv files
		csvname = origname + "mito" + ".csv"; 
       	selectWindow("Results");
        saveAs("Results", outfinal + i+"_mito_"+csvname);
		selectWindow("Results"); 
		


		// save summary 
		selectWindow("Summary");
		saveAs("Results", outfinal + i+"_Summary_"+csvname);

        // close all windows        
   		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        pUbMito(input, list[i]);