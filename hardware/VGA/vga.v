`timescale 1ns / 1ps

module vga_framebuffer(
    input  wire clk,        
    input  wire rst,
    input  wire we,
    input  wire [18:0] write_addr,
    input  wire [2:0] write_data,
    output reg vga_r,
    output reg vga_g,
    output reg vga_b,
    output reg vga_hsync,
    output reg vga_vsync
);

    parameter H_VISIBLE = 640;
    parameter H_FRONT   = 16;
    parameter H_SYNC    = 96;
    parameter H_BACK    = 48;
    parameter V_VISIBLE = 480;
    parameter V_FRONT   = 10;
    parameter V_SYNC    = 2;
    parameter V_BACK    = 33;

    localparam H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;  
    localparam V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;  

    reg [2:0] framebuffer [0:307199];

    always @(posedge clk) begin
        if (we) begin
            framebuffer[write_addr] <= write_data;
        end
    end

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    always @(posedge clk or posedge rst) begin
        if (rst)
            h_counter <= 0;
        else if (h_counter == H_TOTAL - 1)
            h_counter <= 0;
        else
            h_counter <= h_counter + 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            v_counter <= 0;
        else if (h_counter == H_TOTAL - 1) begin
            if (v_counter == V_TOTAL - 1)
                v_counter <= 0;
            else
                v_counter <= v_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (h_counter >= (H_VISIBLE + H_FRONT) &&
            h_counter <  (H_VISIBLE + H_FRONT + H_SYNC))
            vga_hsync <= 0;
        else
            vga_hsync <= 1;

        if (v_counter >= (V_VISIBLE + V_FRONT) &&
            v_counter <  (V_VISIBLE + V_FRONT + V_SYNC))
            vga_vsync <= 0;
        else
            vga_vsync <= 1;
    end

    wire visible_area =
        (h_counter < H_VISIBLE) &&
        (v_counter < V_VISIBLE);

    reg [18:0] read_addr;

    always @(posedge clk or posedge rst) begin
        if (rst)
            read_addr <= 0;
        else if (h_counter == H_TOTAL - 1) begin
            if (v_counter == V_TOTAL - 1)
                read_addr <= 0;
            else
                read_addr <= read_addr + H_VISIBLE;
        end
        else if (visible_area)
            read_addr <= read_addr + 1;
    end

    reg [2:0] pixel_data;

    always @(posedge clk) begin
        if (visible_area)
            pixel_data <= framebuffer[read_addr];
        else
            pixel_data <= 3'd0;
    end

    always @(posedge clk) begin
        if (visible_area) begin
            vga_r <= pixel_data[0];
            vga_g <= pixel_data[1];
            vga_b <= pixel_data[2];
        end else begin
            vga_r <= 0;
            vga_g <= 0;
            vga_b <= 0;
        end
    end

endmodule
