`timescale 1ns / 1ps

module vga_framebuffer #(
    parameter H_VISIBLE = 640,
    parameter H_FRONT   = 16,
    parameter H_SYNC    = 96,
    parameter H_BACK    = 48,
    parameter V_VISIBLE = 480,
    parameter V_FRONT   = 10,
    parameter V_SYNC    = 2,
    parameter V_BACK    = 33
)(
    input  wire        clk,        // 25 MHz
    input  wire        rst,

    // Write interface (external logic writes pixels)
    input  wire        we,
    input  wire [18:0] write_addr,
    input  wire [11:0] write_data,

    output reg  [3:0]  vga_r,
    output reg  [3:0]  vga_g,
    output reg  [3:0]  vga_b,
    output reg         vga_hsync,
    output reg         vga_vsync
);

    // ----------------------------------------------------
    // Timing Parameters
    // ----------------------------------------------------

    localparam H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;  // 800
    localparam V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;  // 525

    // ----------------------------------------------------
    // Framebuffer Memory
    // 640 x 480 = 307200 pixels
    // Address width = 19 bits
    // ----------------------------------------------------

    reg [11:0] framebuffer [0:307199];

    always @(posedge clk) begin
        if (we)
            framebuffer[write_addr] <= write_data;
    end

    // ----------------------------------------------------
    // Counters
    // ----------------------------------------------------

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

    // ----------------------------------------------------
    // Sync Signals (Negative Polarity)
    // ----------------------------------------------------

    always @(posedge clk) begin
        // HSYNC
        if (h_counter >= (H_VISIBLE + H_FRONT) &&
            h_counter <  (H_VISIBLE + H_FRONT + H_SYNC))
            vga_hsync <= 0;
        else
            vga_hsync <= 1;

        // VSYNC
        if (v_counter >= (V_VISIBLE + V_FRONT) &&
            v_counter <  (V_VISIBLE + V_FRONT + V_SYNC))
            vga_vsync <= 0;
        else
            vga_vsync <= 1;
    end

    // ----------------------------------------------------
    // Visible Area
    // ----------------------------------------------------

    wire visible_area =
        (h_counter < H_VISIBLE) &&
        (v_counter < V_VISIBLE);

    // Framebuffer read address
    wire [18:0] read_addr;
    assign read_addr = v_counter * H_VISIBLE + h_counter;

    reg [11:0] pixel_data;

    always @(posedge clk) begin
        if (visible_area)
            pixel_data <= framebuffer[read_addr];
        else
            pixel_data <= 12'd0;
    end

    // ----------------------------------------------------
    // Output RGB
    // ----------------------------------------------------

    always @(posedge clk) begin
        if (visible_area) begin
            vga_r <= pixel_data[11:8];
            vga_g <= pixel_data[7:4];
            vga_b <= pixel_data[3:0];
        end else begin
            vga_r <= 0;
            vga_g <= 0;
            vga_b <= 0;
        end
    end

endmodule
