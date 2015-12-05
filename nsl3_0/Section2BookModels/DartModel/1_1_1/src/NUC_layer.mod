/* SCCS @(#)NUC_layer.mod	1.4---09/24/99--19:11:16 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModule NUC_layer() {
    // constants
    nslConstant double f_max  = 100.;
    nslConstant double offset = -.30;  // output = 50 for 0 input
    nslConstant double slope  = .08;
    // inports
    NslDinDouble2 pp_in();  // PP input
    NslDinDouble2 pc_in();  // PC input
    // outports
    NslDoutDouble1 nuc_out(2); 
    // variables
    NslDouble1 nuc_mp(2);
    
 public void initModule(){
     nuc_out = 50;
 }
 
 public void simTrain() {
     simRun();
 }
 
 public void simRun(){
     // Map inputs onto 2x1 array
     NslDouble2 td(2,10);
     td[0] = nslSumColumns(nslGetSector(pp_in,0,0,4,9));
     td[1] = nslSumColumns(nslGetSector(pp_in,5,0,9,9));
     nuc_mp = nslSumRows(2.0*td) + nslSumRows(-.2*pc_in);
     nuc_out = f_max * nslSigmoid(nuc_mp,slope,offset);
 }
}
