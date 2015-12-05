/* SCCS @(#)DART_out.mod	1.4---09/24/99--19:11:15 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslOutModule DART_out() {

    NslDinDouble1 nuc_out(2);
    NslDinDouble2 pc_out(2,5);
    NslDinDouble1 io_out(2);
    NslDinDouble1 sens_out(2);
    
    public void initModule() {
    	nslAddAreaCanvas(nuc_out,0,50);
    	nslAddAreaCanvas(pc_out,0,100);
    	nslAddAreaCanvas(io_out,0,10);
     	nslAddAreaCanvas(sens_out,0,1);
    }
} 
