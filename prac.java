import edu.stanford.nlp.ie.AbstractSequenceClassifier;
import edu.stanford.nlp.ie.crf.*;
import edu.stanford.nlp.io.IOUtils;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.sequences.DocumentReaderAndWriter;
import edu.stanford.nlp.util.Triple;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.ObjectOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeSet;

public class prac {
	public static void main(String[] args) throws Exception{
		// TODO Auto-generated method stub
		String serializedClassifier = "classifiers/english.muc.7class.distsim.crf.ser.gz";
		
	    AbstractSequenceClassifier<CoreLabel> classifier = CRFClassifier.getClassifier(serializedClassifier);

	    if (args.length > 1) {
	    	String input = args[0];
//	    	System.out.println("input file name:"+ input);
	    	String output = args[1];
//	    	System.out.println("output file name:"+ output);
		      Set<String> content = new TreeSet<String>();
		      BufferedReader br = null;
		      br = new BufferedReader(new FileReader(new File(input)));
		         String line;
		         while((line = br.readLine()) != null) {
		             content.add(line); 
		         }
		      String[] example = content.toArray(new String[content.size()]);
		      	      
		      PrintStream console = System.out;
		      File file = new File(output);
		      FileOutputStream fos = new FileOutputStream(file);
		      // Creating a print object using the file object created above
			  PrintStream ps = new PrintStream(fos);
			  // Assign ps to output stream
			  System.setOut(ps);
		      for (String str : example) {
		
		        List<Triple<String,Integer,Integer>> triples = classifier.classifyToCharacterOffsets(str);
		        for (Triple<String,Integer,Integer> trip : triples) {
		        	if (trip.first() .equals ("LOCATION")) {
		          System.out.println(str.substring(trip.second(), trip.third())+ "\t" + trip.first());
		        	}
		        } 
		     }
	    } 
	}
	
}






