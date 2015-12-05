/* SCCS @(#)CEREB_module.mod	1.3---09/24/99--17:21:20 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModule CEREB_module() {
    // children
    GC_layer gc_l();
    IO_layer io_l();
    PC_layer pc_l();
    NUC_layer nuc_l();
    // inports
    NslDinDouble1 sens_in();  // SENS input (2x1)
    NslDinDouble2 pp_in();    // Parietal input (10x10)
    NslDinDouble2 fcx_in();   // Frontal cortex input (10x4)
    // outports
    NslDoutDouble1 cereb_out(2); 
    NslDoutDouble2 pc_out(2,5); 
    NslDoutDouble1 io_out(2); 

    public void makeConn(){
	// Module inputs to leaf node inputs
	nslRelabel(this.pp_in, gc_l.pp_in);
	nslRelabel(this.fcx_in, gc_l.fcx_in);
	nslRelabel(this.sens_in, io_l.sens_in);
	nslRelabel(this.pp_in, nuc_l.pp_in);
	// leaf output to module output
	//nslRelabel(nuc_l.nuc_out, this.cereb_out);
	//nslRelabel(pc_l.pc_out, this.pc_out);
	//nslRelabel(io_l.io_out, this.io_out);
	nslRelabel(this.cereb_out, nuc_l.nuc_out);
	nslRelabel(this.pc_out, pc_l.pc_out);
	nslRelabel(this.io_out, io_l.io_out);
	// leaf input and outputs
	nslConnect(gc_l.gc_out, pc_l.gc_in);
	nslConnect(io_l.io_out, pc_l.io_in);
	nslConnect(pc_l.pc_out, nuc_l.pc_in);
	nslConnect(nuc_l.nuc_out, io_l.nuc_in);
    } 
}
