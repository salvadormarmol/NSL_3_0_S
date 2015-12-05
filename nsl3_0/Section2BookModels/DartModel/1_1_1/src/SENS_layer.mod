/* SCCS @(#)SENS_layer.mod	1.4---09/24/99--19:11:17 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */


nslModule SENS_layer() {
    // inports
    NslDinDouble0 t_in();       // Throw direction [-50:50]
    // outports
    NslDoutDouble0 p_out();     // Prism angle [0:30]
    NslDoutDouble1 sens_out(2); // Error sensors 
    // variables
    

 public void simTrain() {
     simRun();
 }
 
 public void simRun(){
     double Derror;

     p_out = (NslDouble0)nslGetValue("dartModel.p_out");
     Derror = (double)(p_out - t_in);
     /* go leftward or rightward */
     sens_out[0] = nslStep(Derror,0,.1-Derror/10.,0.1);
     sens_out[1] = nslStep(Derror,0,0.1,.1+Derror/10.);
 }
}
