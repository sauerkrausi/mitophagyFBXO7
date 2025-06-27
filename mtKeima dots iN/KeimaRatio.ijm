  function KeimaDots(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_Eval/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "area mean modal min bounding fit shape feret's integrated area_fraction redirect=None decimal=3");
		
       	origname = getTitle;

		// dublicate 488+561 channels, filter and convert to binary file 
		run("Select All");
		name = getTitle();
		
		run("Duplicate...", "duplicate channels=1");
		rename("pH7");
		selectWindow(name);
		run("Duplicate...", "duplicate channels=2");
		rename("pH3");

		imageCalculator("Divide create", "pH3","pH7");
		rename("ratio");
		
		// saves the pH3-mask image also in the folder 
		selectWindow("ratio");
		maskname = origname + "KeimaRatio";
		saveAs("Tiff", outfinal + i+"_"+ maskname);
		
		run("Subtract Background...", "rolling=25 sliding");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		rename("binary");

		// measure particles, change size if you would like to change the lower size cutoff 
		selectWindow("binary");
		run("Analyze Particles...", "size=0.50-Infinity pixel show=Outlines display exclude");

		// save results as csv files
		csvname = origname + "KeimaRatio" + ".csv"; 
       	selectWindow("Results");
        saveAs("Results", outfinal + i+"_KeimaRatio_"+csvname);
		selectWindow("Results"); 
     	run("Close");

        // close all windows        
   		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        KeimaDots(input, list[i]);