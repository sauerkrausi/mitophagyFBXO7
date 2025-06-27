 function p62nucleiMIP(input, filename) {
        open(input + filename);
        parentname = File.getName(input);
  		outfinal = input + parentname + "_evalobjects/";
  		File.makeDirectory(outfinal);

		// Set measurements before running script so everything is getting analyzed properly 
		run("Set Measurements...", "area mean modal min bounding fit shape feret's integrated area_fraction redirect=None decimal=2");
		 origname = getTitle;
		
		// process 488 == p62 channel to measure the aggregates after AO mitophagy induction  
		// filter images and the convert into binay image for analysis 
		selectWindow(origname);
       	run("Duplicate...", "title=p62 duplicate channels=1");
		run("Gaussian Blur...", "sigma=2");
		setAutoThreshold("Intermodes dark");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Analyze Particles...", "size=0.1-30 show=Overlay exclude");

		// save p62 segementation 
		selectWindow("p62");
     	maskname = origname + "p62";
		saveAs("Tiff", outfinal + i+"_"+ maskname);
		
		// save results as csv files and overlay 
		csvname = origname + "p62" + ".csv"; 
        saveAs("Results", outfinal + i+"_p62_"+csvname);
     	run("Close");
      
		// process 405 == DAPI channel to measure the aggregates after AO mitophagy induction  
		// filter images and the convert into binay image for analysis 
		selectWindow(origname);
		//Stack.getDimensions(width, height, channels, slices, frames);
		run("Duplicate...", "title=nuc duplicate channels=2");
		run("Gaussian Blur...", "sigma=2");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Otsu background=Default calculate black");	
		run("Fill Holes");
		run("Analyze Particles...", "size=25-Infinity show=Overlay display exclude");

		// save results as csv files
		csvname = origname + "nuc" + ".csv"; 
        saveAs("Results", outfinal + i+"_nuc_"+csvname);
     	run("Close");


        // close all windows        
   		run("Close"); 
      run("Close All"); 

}

// call function and run macro
input = getDirectory ("Choose input folder");
list = getFileList(input);
for (i = 0; i < list.length; i++)
        p62nucleiMIP(input, list[i]);