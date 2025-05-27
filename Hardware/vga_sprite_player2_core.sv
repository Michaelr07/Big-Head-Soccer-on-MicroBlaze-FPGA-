module vga_sprite_player2_core 
   #(parameter CD = 12,             // color depth
               ADDR_WIDTH = 11,     // for 64�32 sprites
               KEY_COLOR = 12'h000  // transparent color
   )
   (
    input  logic clk, reset,

    // frame counter position
    input  logic [10:0] x, y,

    // video slot interface
    input  logic cs,            // chip select
    input  logic write,         // write enable
    input  logic [13:0] addr,   // address from CPU
    input  logic [31:0] wr_data,// write data from CPU

    // RGB stream in/out
    input  logic [CD-1:0] si_rgb,    // input pixel
    output logic [CD-1:0] so_rgb     // output pixel
  );

   // Internal signals
   logic wr_en, wr_ram, wr_reg;
   logic wr_bypass, wr_x0, wr_y0;
   logic wr_sel;
   logic [CD-1:0] player2_rgb, chrom_rgb;
   logic [10:0] x0_reg, y0_reg;
   logic bypass_reg;
   logic sel_reg;

   // === Sprite Instance ===
   player2_src #(.CD(CD), .ADDR(ADDR_WIDTH), .KEY_COLOR(KEY_COLOR)) player2_src_unit (
       .clk(clk), 
       .x(x), .y(y), 
       .x0(x0_reg), .y0(y0_reg),
       .we(wr_ram), 
       .addr_w(addr[ADDR_WIDTH-1:0]),
       .sel(sel_reg),
       .pixel_in(wr_data[2:0]),  // assuming 3-bit color
       .sprite_rgb(player2_rgb)
   );

   // === Registers ===
   always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
         x0_reg <= 0;
         y0_reg <= 0;
         bypass_reg <= 0;
         sel_reg <= 0;
      end else begin
         if (wr_x0)
            x0_reg <= wr_data[10:0];
         if (wr_y0)
            y0_reg <= wr_data[10:0];
         if (wr_bypass)
            bypass_reg <= wr_data[0];
         if(wr_sel)
            sel_reg <= wr_data[1];
      end
   end

   // === Write decode logic ===
   assign wr_en     = write & cs;
   assign wr_ram    = ~addr[13] && wr_en;             // addr[13] == 0 ? RAM
   assign wr_reg    =  addr[13] && wr_en;             // addr[13] == 1 ? Register
   assign wr_bypass = wr_reg && (addr[1:0] == 2'b00);
   assign wr_sel    = wr_reg && (addr[1:0] == 2'b11);
   assign wr_x0     = wr_reg && (addr[1:0] == 2'b01);
   assign wr_y0     = wr_reg && (addr[1:0] == 2'b10);

   // === Chroma-key transparency logic ===
   assign chrom_rgb = (player2_rgb != KEY_COLOR) ? player2_rgb : si_rgb;
   assign so_rgb    = (bypass_reg) ? si_rgb : chrom_rgb;

endmodule
