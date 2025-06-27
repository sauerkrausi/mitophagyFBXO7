function iNMitoObjects(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_Eval/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "area mean modal min bounding fit shape feret's integrated area_fraction redirect=None decimal=2");
		
       	origname = getTitle;

		// dublicate mitochondrial channel, convert to binary file 
		run("Duplicate...", "title=mito duplicate channels=1");
		run("Subtract Background...", "rolling=10 sliding");
		setAutoThreshold("Huang dark");
		//run("Threshold...");
		setOption("BlackBackground", false);
		run("Convert to Mask");


		// measure mitochondria, change size if you would like to change the lower size cutoff 
		// save results as csv files
		// saves the mitochondrial channel with overlay of analyzed objects also in the folder 
		run("Analyze Particles...", "size=0.5-Infinity show=Overlay display exclude");
					
		csvname = origname + "mito" + ".csv"; 
        saveAs("Results", outfinal + i+"_mitochondria_"+csvname);
     	run("Close");
     	     		
		selectWindow("mito");
		maskname = origname + "mitochondria";
		saveAs("Tiff", outfinal + i+"_"+ maskname);

        // close all windows        
   		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        iNMitoObjects(input, list[i]);