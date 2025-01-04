//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Wed Dec 18 13:31:45 2024
//Host        : 309x6 running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=4,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,da_bram_cntlr_cnt=1,da_clkrst_cnt=10,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_100MHz);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN design_1_clk_100MHz, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_100MHz;

  wire Net;
  wire [31:0]blk_mem_gen_0_douta;
  wire [12:0]bram_controller_0_addra;
  wire [31:0]bram_controller_0_dina;
  wire bram_controller_0_ena;
  wire [31:0]bram_controller_0_sample_data;
  wire [0:0]bram_controller_0_wea;
  wire clk_100MHz_1;
  wire play_controller_0_enable;
  wire play_controller_0_reset;
  wire sample_timer_0_sample_tick;

  assign clk_100MHz_1 = clk_100MHz;
  design_1_audio_output_0_0 audio_output_0
       (.clk(Net),
        .reset(play_controller_0_reset),
        .sample_data(bram_controller_0_sample_data));
  design_1_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(bram_controller_0_addra),
        .clka(Net),
        .dina(bram_controller_0_dina),
        .douta(blk_mem_gen_0_douta),
        .ena(bram_controller_0_ena),
        .wea(bram_controller_0_wea));
  design_1_bram_controller_0_2 bram_controller_0
       (.addra(bram_controller_0_addra),
        .clk(Net),
        .dina(bram_controller_0_dina),
        .douta(blk_mem_gen_0_douta),
        .ena(bram_controller_0_ena),
        .read_address({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .reset(play_controller_0_reset),
        .sample_data(bram_controller_0_sample_data),
        .sample_tick(sample_timer_0_sample_tick),
        .wea(bram_controller_0_wea),
        .write_address({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .write_data({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .write_enable(1'b0));
  design_1_clk_wiz_1 clk_wiz
       (.clk_in1(clk_100MHz_1),
        .clk_out1(Net));
  design_1_play_controller_0_0 play_controller_0
       (.clk(Net),
        .enable(play_controller_0_enable),
        .pause(1'b0),
        .play(1'b0),
        .reset(play_controller_0_reset),
        .stop(1'b0));
  design_1_sample_timer_0_0 sample_timer_0
       (.clk(Net),
        .enable(play_controller_0_enable),
        .reset(play_controller_0_reset),
        .sample_tick(sample_timer_0_sample_tick));
endmodule
