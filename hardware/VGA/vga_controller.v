`timescale 1ns / 1ps

module vga_controller(
    input wire clk_25MHz,     
    input wire reset,
    input wire [2:0] pixel_data,  // From VRAM
    output wire red,         
    output wire green,       
    output wire blue,         
    output reg hsync,
    output reg vsync,
    output wire [17:0] mem_address  // 18 bits for 153,600 addresses
);

    // Timing parameters for 640x480 @ 60Hz
    parameter H_DISPLAY = 640;
    parameter H_FP = 16;
    parameter H_SYNC = 96; 
    parameter H_BP = 48;
    parameter H_TOTAL = 800;
    
    parameter V_DISPLAY = 480;
    parameter V_FP = 10;
    parameter V_SYNC = 2;
    parameter V_BP = 33; 
    parameter V_TOTAL = 525;
    
    // Counters
    reg [9:0] h_count, v_count;
    
    // Registered memory address
    reg [17:0] address_reg;
    
    // Horizontal and vertical counters 
    always @(posedge clk_25MHz or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            // Horizontal counter
            if (h_count == H_TOTAL-1) 
                h_count <= 0;
            else 
                h_count <= h_count + 1;
            
            // Vertical counter
            if (h_count == H_TOTAL-1) begin
                if (v_count == V_TOTAL-1) 
                    v_count <= 0;
                else 
                    v_count <= v_count + 1;
            end
		end
    end
	 
    // Memory address calculation (640/2 = 320 pixels per line in memory)
    always @(posedge clk_25MHz) begin
        if (h_count < H_DISPLAY && v_count < V_DISPLAY) 
            address_reg <= (v_count * 320) + h_count[9:1]; 
        else
            address_reg <= 0;
    end
    assign mem_address = address_reg;
    
    // Sync signals
    always @(*) begin
        hsync = ~((h_count >= (H_DISPLAY + H_FP)) && 
                  (h_count < (H_DISPLAY + H_FP + H_SYNC)));
        vsync = ~((v_count >= (V_DISPLAY + V_FP)) && 
                  (v_count < (V_DISPLAY + V_FP + V_SYNC)));
    end
    
    // Active video region
    wire active_video = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    
    wire r_bit = pixel_data[2]; // Red
    wire g_bit = pixel_data[1]; // Green
    wire b_bit = pixel_data[0]; // Blue
    
    assign red   = active_video && (r_bit);
    assign green = active_video && (g_bit);
    assign blue  = active_video && (b_bit);

endmodule

