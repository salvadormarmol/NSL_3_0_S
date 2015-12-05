/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol


//
// NslFile.java
//
//////////////////////////////////////////////////////////////////////

import java.io.*;
import java.util.*;

public class NslFile {

    private static Vector files = new Vector();;

    private Vector fileLines;
    private String fileName;

    public NslFile(String fileName) {
        this.fileName = fileName;
	fileLines = new Vector(50);	
	String line;
	try {
	    BufferedReader in = new BufferedReader(new FileReader(fileName));	 
	    while ((line=in.readLine())!=null) {
		fileLines.addElement(line);
	    }
	} catch (Exception ex) {
	    System.err.println("NSlFile [error]: An error occured while reading file "+fileName);
	}   
    }
 
    public String getFileName() {
	return fileName;
    }

    public String getLine(int line) {
	return (String)fileLines.elementAt(line-1);
    }

    public static void loadFile(String fileName) {	
	NslFile file = new NslFile(fileName);
	files.addElement(file);
    }

    public static NslFile getFile(String fileName) {
	Enumeration enum = files.elements();
	NslFile fileTmp;
	while (enum.hasMoreElements()) {
	    fileTmp = (NslFile)enum.nextElement();
	    if (fileName.equals(fileTmp.getFileName())) {
		return fileTmp;
	    }
	}
	return null;
    }

    public static String getLine(String fileName, int line) {
	Enumeration enum = files.elements();
	NslFile fileTmp;
	while (enum.hasMoreElements()) {
	    fileTmp = (NslFile)enum.nextElement();
	    if (fileName.equals(fileTmp.getFileName())) {
		return fileTmp.getLine(line);
	    }
	}
	return null;
    }

}