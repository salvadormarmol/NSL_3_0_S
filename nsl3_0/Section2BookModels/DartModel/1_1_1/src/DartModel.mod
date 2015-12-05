/* SCCS @(#)DartModel.mod	1.3---09/24/99--19:11:15 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModel DartModel() {
    // inports
    // outports
    // variables
    NslDouble0 pp_noise();
    NslDouble0 pp_sep();
    NslDouble0 fcx_noise();
    NslDouble0 gc_offset();
    NslDouble0 gc_slope();
    NslInt0 gc_nd();
    NslDouble0 gc_dist();
    NslDouble0 alpha();
    NslInt0 protocol();
    NslDouble0 p_out();    // Prism angle [0:30]
    NslDouble0 d_out();    // Target direction [-30:30]
    NslDouble0 s_out();    // Strategy: [0:1] over/under 
    int state;
    // children
    CEREB_module cereb_m();
    THROW_module throw_m();
    SENS_layer sens_l();
    PP_layer pp_l();
    FCX_layer fcx_l();
	
    // graph modules
    DART_UI_module gui_m();
    DART_out out();

 public void initModule(){

     system.setTrainEndTime(.07);
     system.nslSetTrainDelta(.01);
     
     system.setRunEndTime(.07);
     system.nslSetRunDelta(.01);
     
     system.nslSetApproximationDelta(.01);

     pp_noise = .05;
     pp_sep = 4.0;
     fcx_noise = .05;
     gc_offset = .5;
     gc_slope = 50.;
     gc_nd = 4;
     gc_dist = .9;
     alpha = -0.0005;
     protocol = 0;

     nslDeclareProtocol("basic", "Basic on/off");
     nslDeclareProtocol("transfer", "Overarm/Underarm transfer");
     nslDeclareProtocol("calibration", "Two gaze-throw calibrations");
          
     system.addProtocolToAll("basic");
     system.addProtocolToAll("transfer");
     system.addProtocolToAll("calibration");     
 }
 
 public void basicProtocol() {
     nslPrintln("Basic on/off protocol selected");
     protocol = 0; 	
 }
 
 public void transferProtocol() {
     nslPrintln("Overarm/Underarm transfer protocol selected");
     protocol = 1;
 }
 
 public void calibrationProtocol() {
     nslPrintln("Two gaze-throw calibrations protocol selected");
     protocol = 2;
 }

 public void makeConn(){
     // Top outputs to leaf node inputs
     nslConnect(sens_l.p_out, fcx_l.p_in);
     nslConnect(pp_l.s_out, gui_m.s_in);
     nslConnect(sens_l.p_out, gui_m.p_in);
     nslConnect(throw_m.throw_out, gui_m.throw_in);
     // leaf outputs to top inputs
     // leaf input and outputs
     nslConnect(pp_l.pp_out, cereb_m.pp_in);
     nslConnect(fcx_l.fcx_out, cereb_m.fcx_in);
     nslConnect(cereb_m.cereb_out, throw_m.nuc_in);
     nslConnect(throw_m.throw_out, sens_l.t_in);
     nslConnect(sens_l.sens_out, cereb_m.sens_in);
     // leaf outputs to graphic inputs
     nslConnect(cereb_m.cereb_out, out.nuc_out);
     nslConnect(cereb_m.pc_out,out.pc_out);
     nslConnect(cereb_m.io_out,out.io_out);
     nslConnect(sens_l.sens_out,out.sens_out);
  }
  
  public void setValues() {
     // Define outputs given current state
     switch(state){
	 case 0:       // over, no prisms
	     p_out = 0.;
	     d_out = 0.;
	     s_out = 0.;
	     break;
	 case 1:       // over, prisms
	     p_out = 30.;
	     d_out = 0.;
	     s_out = 0.;
	     break;
	 case 2:       // under, no prisms
	     p_out = 0.;
	     d_out = 0.;
	     s_out = 1.;
	     break;
	 case 3:       // under, prisms
	     p_out = 30.;
	     d_out = 0.;
	     s_out = 1.;
	     break;
     }  
  }

  public void initTrainEpoch() {
	nslPrintln("The first 100 throws are for warm-up. Please be patient");    
	state = 0; // Over-arm, no prisms      	      
	system.setNumTrainEpochs(100);
  }

  public void initTrain() {
            
      switch (system.getFinishedEpochs()) {  
      	  case 10:
      	      state = 3;      	  
      	      break;
      	  case 30:
      	      state = 1;      	  
      	      break;
      	  case 50:
      	      state = 2;      	  
      	      break;
      	  case 70:
      	      state = 0;      	  
      	      break;
      }       

     setValues(); 
  }
   
  public void initRunEpoch() {
     state = 0; // Over-arm, no prisms
     	
     switch ((int)protocol) {
	case 0:
            system.setNumRunEpochs(60);
            break;
        case 1:
            system.setNumRunEpochs(1500);
            break;
        case 2:
            system.setNumRunEpochs(100);
            break;
     }
  }
 
  public void initRun(){
     
     int epoch = system.getFinishedEpochs();
     

     switch ((int)protocol) {
            case 0:
                switch (epoch) {
                    case 20:
                        state = 1;
                        break;
                    case 40:
                        state = 0;
                        break;
                }
                break;                
            case 1:
                switch (epoch) {
                    case 0:
                        state = 2;
                        break;
                    case 20:
                        state = 0;
                        break;
                    case 40:
                        state = 1;
                        break;
                    case 60:
                        state = 2;
                        break;
                    case 80:
                        state = 0;
                        break;
                }
                break;                
            case 2:
	        if(epoch==0){
		    state = 0;
	        } else if(epoch % 20 == 0) {     // state transition
		     switch(state){
		     case 0:
			 state = 1;
			 break;
		     case 1:
			 state = 0;
			 break;
		     case 2:
			 state = 1;
			 break;
		     case 3:
			 state = 0;
			 break;
		     }
		}
	        break;
     }
     
     setValues(); 
  } 
}
