/* SCCS @(#)PP_layer.mod	1.4---09/24/99--19:11:17 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */


nslModule PP_layer() {
    // constants
    nslConstant double sx2 = 12.25; // 3.5*3.5
    nslConstant double sy2 = 9.;    // 3*3
    // inports
    // outports
    NslDoutDouble0 s_out();    // Strategy: [0:1] over/under 
    NslDoutDouble2 pp_out(10,10); // PP population coding
    // variables
    NslDouble0 a_out();       // Aim direction [-30:30]
    NslDouble0 pp_noise();
    NslDouble0 pp_sep();

 public void initModule(){
     pp_noise = (NslDouble0)nslGetValue("dartModel.pp_noise");
     pp_sep   = (NslDouble0)nslGetValue("dartModel.pp_sep");
 }
 
 public void simTrain() {
     simRun();
 }
 
 public void simRun(){
     int i,j;
     NslDouble0 mx(), my();
     NslDouble0 dx(), dy();

     s_out = (NslDouble0)nslGetValue("dartModel.s_out");
     a_out = (NslDouble0)nslGetValue("dartModel.d_out");
     
     my = 4.5 + nslStep(s_out,.5,-1,1)*pp_sep/2.; // throw = over/under
     mx = 4.5 + 4.5*a_out/30.;
     
     for(i=0;i<10;i++){
	 dx = mx - i;
	 for(j=0;j<10;j++){
	     dy = my - j;
	     pp_out[i][j] = pp_noise * nslRandom() + 
		 (1.-pp_noise) * nslExp(-1.*(dx*dx/sx2 + dy*dy/sy2));
	 }
     }
 }
}
