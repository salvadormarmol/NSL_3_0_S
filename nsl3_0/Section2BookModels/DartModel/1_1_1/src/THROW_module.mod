/* SCCS @(#)THROW_module.mod	1.4---09/24/99--19:11:17 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModule THROW_module() {
    // inports
    NslDinDouble1 nuc_in();
    // outports
    NslDoutDouble0 throw_out();
    // variables

 
 public void simTrain() {
     simRun();
 }
 
 public void simRun(){
     throw_out = (.5 - (1.+nuc_in[0])/(2.+nuc_in[1] + nuc_in[0]))*100.;
 }
}
