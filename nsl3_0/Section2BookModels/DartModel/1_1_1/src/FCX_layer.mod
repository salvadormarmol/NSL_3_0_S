/* SCCS @(#)FCX_layer.mod	1.4---09/24/99--19:11:15 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModule FCX_layer() {
    // constants
    nslConstant double sx2 = 100.;  // 10*10
    nslConstant double sy2 = 2.25;  // 1.5*1.5 
    // inports
    NslDinDouble0 p_in();    // Prism angle [0:30]
    // outports
    NslDoutDouble2 fcx_out(10,4); 
    // variables
    NslDouble0 fcx_noise();

 public void initModule(){
    fcx_out=0.;
    fcx_noise=(NslDouble0)nslGetValue("dartModel.fcx_noise");
 }
   
 public void simTrain() {
     simRun();
 }  
 
 public void simRun(){
     int i,j;
     NslDouble0 mx(), my(), dx(), dy();
     
     mx = 1. + 9.*p_in/50.;
     my = 1.5;
     
     for(i=0;i<10;i++){
	 dx = mx-i;
	 for(j=0;j<4;j++){
	     dy = my - j;
	     fcx_out[i][j] = fcx_noise * nslRandom() + 
		 (1.-fcx_noise)*nslExp(-1.*(dx*dx/sx2 + dy*dy/sy2));
	 }
     }
 }
}


