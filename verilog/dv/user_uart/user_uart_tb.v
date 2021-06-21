//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Standalone User validation Test bench                       ////
////                                                              ////
////  This file is part of the YIFive cores project               ////
////  http://www.opencores.org/cores/yifive/                      ////
////                                                              ////
////  Description                                                 ////
////   This is a standalone test bench to validate the            ////
////   Digital core.                                              ////
////   1. User Risc core is booted using  compiled code of        ////
////      user_risc_boot.c                                        ////
////   2. User Risc core uses Serial Flash and SDRAM to boot      ////
////   3. After successful boot, Risc core will check the UART    ////
////      RX Data, If it's available then it loop back the same   ////
////      data in uart tx                                         ////
////   4. Test bench send random 40 character towards User uart   ////
////      and expect same data to return back                     ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
////  Revision :                                                  ////
////    0.1 - 16th Feb 2021, Dinesh A                             ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`default_nettype none

`timescale 1 ns / 1 ps

`include "uprj_netlists.v"
`include "spiflash.v"
`include "mt48lc8m8a2.v"
`include "uart_agent.v"


`define ADDR_SPACE_UART = 32'h3001_0000;


task user_uart_tb;

reg            clock         ;
reg            RSTB          ;
reg            power1, power2;
reg            power3, power4;

reg            wbd_ext_cyc_i ;  // strobe/request
reg            wbd_ext_stb_i ;  // strobe/request
reg [31:0]     wbd_ext_adr_i ;  // address
reg            wbd_ext_we_i  ;  // write
reg [31:0]     wbd_ext_dat_i ;  // data output
reg [3:0]      wbd_ext_sel_i ;  // byte enable

wire [31:0]    wbd_ext_dat_o ;  // data input
wire           wbd_ext_ack_o ;  // acknowlegement
wire           wbd_ext_err_o ;  // error

// User I/O
wire [37:0]    io_oeb        ;
wire [37:0]    io_out        ;
wire [37:0]    io_in         ;

wire [37:0]    mprj_io       ;
wire [7:0]     mprj_io_0     ;
reg            test_fail     ;
reg [31:0]     read_data     ;
//----------------------------------
// Uart Configuration
// ---------------------------------
reg [1:0]      uart_data_bit        ;
reg	       uart_stop_bits       ; // 0: 1 stop bit; 1: 2 stop bit;
reg	       uart_stick_parity    ; // 1: force even parity
reg	       uart_parity_en       ; // parity enable
reg	       uart_even_odd_parity ; // 0: odd parity; 1: even parity

reg [7:0]      uart_data            ;
reg [15:0]     uart_divisor         ;	// divided by n * 16
reg [15:0]     uart_timeout         ;// wait time limit

reg [15:0]     uart_rx_nu           ;
reg [15:0]     uart_tx_nu           ;
reg [7:0]      uart_write_data [0:39];
reg 	       uart_fifo_enable     ;	// fifo mode disable

integer i,j;



initial
begin
   uart_data_bit           = 2'b11;
   uart_stop_bits          = 0; // 0: 1 stop bit; 1: 2 stop bit;
   uart_stick_parity       = 0; // 1: force even parity
   uart_parity_en          = 0; // parity enable
   uart_even_odd_parity    = 1; // 0: odd parity; 1: even parity
   uart_divisor            = 15;// divided by n * 16
   uart_timeout            = 500;// wait time limit
   uart_fifo_enable        = 0;	// fifo mode disable

   #200; // Wait for reset removal
   repeat (10) @(posedge clock);
   $display("Monitor: Standalone User Risc Boot Test Started");
   
   #1;
   //------------ SDRAM Config - 2
   wb_user_core_write('h3000_0014,'h100_019E);
   
   repeat (2) @(posedge clock);
   #1;
   //------------ SDRAM Config - 1
   wb_user_core_write('h3000_0010,'h2F17_2242);
   
   repeat (2) @(posedge clock);
   #1;
   // Remove all the reset
   wb_user_core_write('h3000_0000,'h7);

   repeat (2000) @(posedge app_clk);  // wait for Processor Get Ready
   tb_uart.uart_init;
   wb_user_core_write(`ADDR_SPACE_UART+8'h0,{3'h0,2'b00,1'b1,1'b1,1'b1});  
   
   
   for (i=0; i<40; i=i+1)
   	uart_write_data[i] = $random;
   
   
     tb_top.tb_uart.control_setup (uart_data_bit, uart_stop_bits, uart_parity_en, uart_even_odd_parity, 
	                          uart_stick_parity, uart_timeout, uart_divisor, uart_fifo_enable);
   
      fork
      begin
         for (i=0; i<40; i=i+1)
         begin
           $display ("\n... UART Agent Writing char %x ...", write_data[i]);
            tb_top.tb_uart.write_char (uart_write_data[i]);
         end
      end
   
      begin
         for (j=0; j<40; j=j+1)
         begin
           tb_top.tb_uart.read_char_chk(uart_write_data[j]);
         end
      end
      join
   
      #100
      tb_top.tb_uart.report_status(rx_nu, tx_nu);
   
      test_fail = 0;
      wb_user_core_read(32'h30000018,read_data);

      // Check 
      // if all the 40 byte transmitted
      // if all the 40 byte received
      // if no error 
      if(tx_nu != 40) test_fail = 1;
      if(rx_nu != 40) test_fail = 1;
      if(tb_top.tb_uart.err_cnt != 0) test_fail = 1;

      $display("###################################################");
      if(test_fail == 0) begin
         `ifdef GL
             $display("Monitor: Standalone User UART Test (GL) Passed");
         `else
             $display("Monitor: Standalone User UART Test (RTL) Passed");
         `endif
      end else begin
          `ifdef GL
              $display("Monitor: Standalone User UART Test (GL) Failed");
          `else
              $display("Monitor: Standalone User UART Test (RTL) Failed");
          `endif
       end
      $display("###################################################");
      #100
      $finish;
end


digital_core u_core(
`ifdef USE_POWER_PINS
    .vdda1(),	// User area 1 3.3V supply
    .vdda2(),	// User area 2 3.3V supply
    .vssa1(),	// User area 1 analog ground
    .vssa2(),	// User area 2 analog ground
    .vccd1(),	// User area 1 1.8V supply
    .vccd2(),	// User area 2 1.8v supply
    .vssd1(),	// User area 1 digital ground
    .vssd2(),	// User area 2 digital ground
`endif
    .wb_clk_i        (clock),  // System clock
    .rtc_clk         (1'b1),  // Real-time clock
    .wb_rst_i        (RSTB),  // Regular Reset signal

    .wbd_ext_cyc_i   (wbd_ext_cyc_i),  // strobe/request
    .wbd_ext_stb_i   (wbd_ext_stb_i),  // strobe/request
    .wbd_ext_adr_i   (wbd_ext_adr_i),  // address
    .wbd_ext_we_i    (wbd_ext_we_i),  // write
    .wbd_ext_dat_i   (wbd_ext_dat_i),  // data output
    .wbd_ext_sel_i   (wbd_ext_sel_i),  // byte enable

    .wbd_ext_dat_o   (wbd_ext_dat_o),  // data input
    .wbd_ext_ack_o   (wbd_ext_ack_o),  // acknowlegement
    .wbd_ext_err_o   (wbd_ext_err_o),  // error

 
    // Logic Analyzer Signals
    .la_data_in      ('0) ,
    .la_data_out     (),
    .la_oenb         ('0),
 

    // IOs
    .io_in          (io_in)  ,
    .io_out         (io_out) ,
    .io_oeb         (io_oeb) ,

    .user_irq       () 

);

//------------------------------------------------------
//  Integrate the Serial flash with qurd support to
//  user core using the gpio pads
//  ----------------------------------------------------

   wire flash_clk = io_out[30];
   wire flash_csb = io_out[31];
   tri  flash_io0 = (io_oeb[32]== 1'b0) ? io_out[32] : 1'bz;
   tri  flash_io1 = (io_oeb[33]== 1'b0) ? io_out[33] : 1'bz;
   tri  flash_io2 = (io_oeb[34]== 1'b0) ? io_out[34] : 1'bz;
   tri  flash_io3 = (io_oeb[35]== 1'b0) ? io_out[35] : 1'bz;

   assign io_in[32] = flash_io0;
   assign io_in[33] = flash_io1;
   assign io_in[34] = flash_io2;
   assign io_in[35] = flash_io3;


   // Quard flash
	spiflash #(
		.FILENAME("user_uart.hex")
	) u_user_spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)	
	);


//------------------------------------------------
// Integrate the SDRAM 8 BIT Memory
// -----------------------------------------------

wire [7:0]    Dq                 ; // SDRAM Read/Write Data Bus
wire [0:0]    sdr_dqm            ; // SDRAM DATA Mask
wire [1:0]    sdr_ba             ; // SDRAM Bank Select
wire [12:0]   sdr_addr           ; // SDRAM ADRESS
wire          sdr_cs_n           ; // chip select
wire          sdr_cke            ; // clock gate
wire          sdr_ras_n          ; // ras
wire          sdr_cas_n          ; // cas
wire          sdr_we_n           ; // write enable        
wire          sdram_clk         ;      

assign  Dq[7:0]           =  (io_oeb[7:0] == 8'h0) ? io_out [7:0] : 8'hZZ;
assign  sdr_addr[12:0]    =    io_out [20:8]     ;
assign  sdr_ba[1:0]       =    io_out [22:21]    ;
assign  sdr_dqm[0]        =    io_out [23]       ;
assign  sdr_we_n          =    io_out [24]       ;
assign  sdr_cas_n         =    io_out [25]       ;
assign  sdr_ras_n         =    io_out [26]       ;
assign  sdr_cs_n          =    io_out [27]       ;
assign  sdr_cke           =    io_out [28]       ;
assign  sdram_clk         =    io_out [29]       ;
assign  io_in[29]         =    sdram_clk;
assign  #(1) io_in[7:0]   =    Dq;

// to fix the sdram interface timing issue
wire #(1) sdram_clk_d   = sdram_clk;

	// SDRAM 8bit
mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (Dq                 ) , 
          .Addr               (sdr_addr[11:0]     ), 
          .Ba                 (sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (sdr_cke            ), 
          .Cs_n               (sdr_cs_n           ), 
          .Ras_n              (sdr_ras_n          ), 
          .Cas_n              (sdr_cas_n          ), 
          .We_n               (sdr_we_n           ), 
          .Dqm                (sdr_dqm            )
     );


//---------------------------
//  UART Agent integration
// --------------------------
wire uart_txd,uart_rxd;

assign uart_txd   = io_out[37];
assign io_in[36]  = uart_rxd ;
 
uart_agent tb_uart(
	.mclk                (clock              ),
	.txd                 (uart_rxd           ),
	.rxd                 (uart_txd           )
	);


task wb_user_core_write;
input [31:0] address;
input [31:0] data;
begin
  repeat (1) @(posedge clock);
  wbd_ext_adr_i =address;  // address
  wbd_ext_we_i  ='h1;  // write
  wbd_ext_dat_i =data;  // data output
  wbd_ext_sel_i ='hF;  // byte enable
  wbd_ext_cyc_i ='h1;  // strobe/request
  wbd_ext_stb_i ='h1;  // strobe/request
  wait(wbd_ext_ack_o == 1);
  repeat (1) @(posedge clock);
  wbd_ext_cyc_i ='h0;  // strobe/request
  wbd_ext_stb_i ='h0;  // strobe/request
  wbd_ext_adr_i ='h0;  // address
  wbd_ext_we_i  ='h0;  // write
  wbd_ext_dat_i ='h0;  // data output
  wbd_ext_sel_i ='h0;  // byte enable
  $display("DEBUG WB USER ACCESS WRITE Address : %x, Data : %x",address,data);
  repeat (2) @(posedge clock);
end
endtask

task  wb_user_core_read;
input [31:0] address;
output [31:0] data;
reg    [31:0] data;
begin
  repeat (1) @(posedge clock);
  wbd_ext_adr_i =address;  // address
  wbd_ext_we_i  ='h0;  // write
  wbd_ext_dat_i ='0;  // data output
  wbd_ext_sel_i ='hF;  // byte enable
  wbd_ext_cyc_i ='h1;  // strobe/request
  wbd_ext_stb_i ='h1;  // strobe/request
  wait(wbd_ext_ack_o == 1);
  data  = wbd_ext_dat_o;  
  repeat (1) @(posedge clock);
  wbd_ext_cyc_i ='h0;  // strobe/request
  wbd_ext_stb_i ='h0;  // strobe/request
  wbd_ext_adr_i ='h0;  // address
  wbd_ext_we_i  ='h0;  // write
  wbd_ext_dat_i ='h0;  // data output
  wbd_ext_sel_i ='h0;  // byte enable
  $display("DEBUG WB USER ACCESS READ Address : %x, Data : %x",address,data);
  repeat (2) @(posedge clock);
end
endtask




////-----------------------------------------------------------------------------
//// RISC IMEM amd DMEM Monitoring TASK
////-----------------------------------------------------------------------------
//logic [`SCR1_DMEM_AWIDTH-1:0]           core2imem_addr_o_r;           // DMEM address
//logic [`SCR1_DMEM_AWIDTH-1:0]           core2dmem_addr_o_r;           // DMEM address
//logic                                   core2dmem_cmd_o_r;
//
//`define RISC_CORE  user_uart_tb.u_core.u_riscv_top.i_core_top
//
//always@(posedge `RISC_CORE.clk) begin
//    if(`RISC_CORE.imem2core_req_ack_i && `RISC_CORE.core2imem_req_o)
//          core2imem_addr_o_r <= `RISC_CORE.core2imem_addr_o;
//
//    if(`RISC_CORE.dmem2core_req_ack_i && `RISC_CORE.core2dmem_req_o) begin
//          core2dmem_addr_o_r <= `RISC_CORE.core2dmem_addr_o;
//          core2dmem_cmd_o_r  <= `RISC_CORE.core2dmem_cmd_o;
//    end
//
//    if(`RISC_CORE.imem2core_resp_i !=0)
//          $display("RISCV-DEBUG => IMEM ADDRESS: %x Read Data : %x Resonse: %x", core2imem_addr_o_r,`RISC_CORE.imem2core_rdata_i,`RISC_CORE.imem2core_resp_i);
//    if((`RISC_CORE.dmem2core_resp_i !=0) && core2dmem_cmd_o_r)
//          $display("RISCV-DEBUG => DMEM ADDRESS: %x Write Data: %x Resonse: %x", core2dmem_addr_o_r,`RISC_CORE.core2dmem_wdata_o,`RISC_CORE.dmem2core_resp_i);
//    if((`RISC_CORE.dmem2core_resp_i !=0) && !core2dmem_cmd_o_r)
//          $display("RISCV-DEBUG => DMEM ADDRESS: %x READ Data : %x Resonse: %x", core2dmem_addr_o_r,`RISC_CORE.dmem2core_rdata_i,`RISC_CORE.dmem2core_resp_i);
//end
endmodule
`default_nettype wire
