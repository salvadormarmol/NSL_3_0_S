/* SCCS @(#)DART_UI_module.mod	1.4---09/24/99--19:11:15 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslOutModule DART_UI_module()
{
    // inports
    NslDinDouble0 throw_in();  // Throw direction
    NslDinDouble0 p_in();      // Prism angle [0:30]
    NslDinDouble0 s_in();      // Strategy: [0:1] over/under 
    // variables
    NslDouble1 throw_dart(4); // graph parameter

    NslDartGraphCanvas dumy;  // for compilation only

 public void initModule(){
     nslAddUserCanvas(throw_dart,0,1,"DartGraph");
     initTrainEpoch();
 }

 public void initTrainEpoch() {
     nslRemoveFromLocalProtocols("manual");
     nslRemoveFromLocalProtocols("basic");
     nslRemoveFromLocalProtocols("transfer");
     nslRemoveFromLocalProtocols("calibration");
 }  

 public void initRunEpoch() {
     nslAddProtocolRecursiveUp("basic");
     nslAddProtocolRecursiveUp("transfer");
     nslAddProtocolRecursiveUp("calibration");     
 }

 public void initRun() {
     throw_dart = -1;
 }
   
 public void endRun(){
     throw_dart[0] = system.getFinishedEpochs();
     throw_dart[1] = throw_in;
     throw_dart[2] = p_in;
     throw_dart[3] = s_in;
 }  
}
