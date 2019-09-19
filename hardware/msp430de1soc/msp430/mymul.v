module  mymul (
	       output [15:0] per_dout,
	       input 	     mclk,
	       input [13:0]  per_addr,
	       input [15:0]  per_din,
	       input 	     per_en,
	       input [1:0]   per_we,
	       input 	     puc_rst
	       );
   
   reg [31:0] 		     hw_a;
   reg [31:0] 		     hw_b;
   reg [63:0] 		     hw_retval;
   reg 			     hw_ctl;
   reg 			     hw_ctl_old;
   wire [63:0] 		     mulresult;
   
   wire 		     write_alo, write_ahi;
   wire 		     write_blo, write_bhi;
   wire 		     write_retval;
   wire 		     write_ctl;	
   
   always @(posedge mclk or posedge puc_rst)
     if (puc_rst)
       begin
	  hw_a        <= 32'h0;
	  hw_b        <= 32'h0;
	  hw_retval   <= 64'h0;
	  hw_ctl      <= 1'h0;
	  hw_ctl_old  <= 1'h0;
       end
     else
       begin
	  hw_a[15: 0] <= write_alo    ? per_din[15:0]   : hw_a[15: 0];
	  hw_a[31:16] <= write_ahi    ? per_din[15:0]   : hw_a[31:16];
	  hw_b[15: 0] <= write_blo    ? per_din[15:0]   : hw_b[15: 0];
	  hw_b[31:16] <= write_bhi    ? per_din[15:0]   : hw_b[31:16];
	  hw_retval   <= write_retval ? mulresult       : hw_retval;
	  hw_ctl      <= write_ctl    ? per_din[0]      : hw_ctl;
	  hw_ctl_old  <= hw_ctl;
       end
   
   assign mulresult = hw_a * hw_b;
   
   assign write_alo    = (per_en & (per_addr == 14'hA0) & (per_we == 2'h3));
   assign write_ahi    = (per_en & (per_addr == 14'hA1) & (per_we == 2'h3));
   assign write_blo    = (per_en & (per_addr == 14'hA2) & (per_we == 2'h3));
   assign write_bhi    = (per_en & (per_addr == 14'hA3) & (per_we == 2'h3));

   assign write_ctl    = (per_en & (per_addr == 14'hA8) & per_we[0] & per_we[1]);
   assign write_retval = ((hw_ctl == 1'h1) & (hw_ctl ^ hw_ctl_old));
   
   assign per_dout = (per_en & (per_addr == 14'hA4) & (per_we == 2'h0)) ? hw_retval[15: 0] : 
                     (per_en & (per_addr == 14'hA5) & (per_we == 2'h0)) ? hw_retval[31:16] : 
                     (per_en & (per_addr == 14'hA6) & (per_we == 2'h0)) ? hw_retval[47:32] : 
                     (per_en & (per_addr == 14'hA7) & (per_we == 2'h0)) ? hw_retval[63:47] : 16'h0;
   
   
endmodule					   
