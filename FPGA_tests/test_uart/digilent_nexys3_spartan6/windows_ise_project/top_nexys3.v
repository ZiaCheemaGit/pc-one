`timescale 1ns / 1ps

module top_nexys3(
    input  wire clk_100MHz,
    input  wire rst,
    output wire rst_on,
    output wire uart_tx
);

    assign rst_on = rst;

    // ==================================================
    // UART
    // ==================================================
    reg  [7:0] uart_data;
    reg        write_en;
    wire       uart_busy;

    uart_tx uart_instance (
        .clk(clk_100MHz),
        .rst(rst),
        .write_en(write_en),
        .data(uart_data),
        .tx(uart_tx),
        .uart_busy(uart_busy)
    );

    // ==================================================
    // CPU <-> Memory wires
    // ==================================================
    wire [31:0] instr_add;
    wire [31:0] instruction;
    wire        mem_write;
    wire        mem_read;
    wire [31:0] mem_add;
    wire [31:0] cpu_data_to_mmu;
    wire [31:0] mmu_data_to_cpu;

    // ==================================================
    // CPU
    // ==================================================
    core core_instance (
        .clk(clk_100MHz),
        .rst(rst),
        .instruction_address(instr_add),
        .instruction(instruction),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_address(mem_add),
        .mem_data_from_mem(mmu_data_to_cpu),
        .mem_data_to_mem(cpu_data_to_mmu)
    );

    // ==================================================
    // ROM
    // ==================================================
    rom rom_instance (
        .pc(instr_add),
        .instruction(instruction),
        .addr(32'b0),
        .data()
    );

    // ==================================================
    // RAM
    // ==================================================
    ram ram_instance (
        .clk(clk_100MHz),
        .data_address(mem_add),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .data_in(cpu_data_to_mmu),
        .data_out(mmu_data_to_cpu)
    );

    // ==================================================
    // Logger FSM
    // ==================================================
    reg [3:0]  log_sel;
    reg [4:0]  char_idx;
    reg [3:0]  nibble_idx;
    reg [31:0] log_latched;

    localparam SEND_LABEL = 1'b0;
    localparam SEND_DATA  = 1'b1;
    reg state;

    // ==================================================
    // Select logged signal
    // ==================================================
    wire [31:0] log_data =
        (log_sel == 0) ? instr_add :
        (log_sel == 1) ? instruction :
        (log_sel == 2) ? core_instance.reg_file_instance.reg_write_control :
        (log_sel == 3) ? core_instance.reg_file_instance.reg_write_data :
        (log_sel == 4) ? core_instance.reg_file_instance.dest_reg :
        (log_sel == 5) ? {31'b0, mem_write} :
        (log_sel == 6) ? {31'b0, mem_read} :
        (log_sel == 7) ? mem_add :
        (log_sel == 8) ? cpu_data_to_mmu :
        (log_sel == 9) ? mmu_data_to_cpu :
                         32'hDEADBEEF;

    // ==================================================
    // Label ROM (Verilog-2001 / ISE safe)
    // ==================================================
    function [7:0] label_char;
        input [3:0] sel;
        input [4:0] idx;
        begin
            label_char = 8'h00;
            case (sel)

                0: case (idx) 0:label_char=8'h50;1:label_char=8'h43;2:label_char=8'h3D; endcase // PC=
                1: case (idx) 0:label_char=8'h49;1:label_char=8'h4E;2:label_char=8'h53;3:label_char=8'h54;4:label_char=8'h3D; endcase // INST=
                2: case (idx) 0:label_char=8'h52;1:label_char=8'h45;2:label_char=8'h47;3:label_char=8'h5F;4:label_char=8'h57;5:label_char=8'h45;6:label_char=8'h3D; endcase // REG_WE=
                3: case (idx) 0:label_char=8'h52;1:label_char=8'h45;2:label_char=8'h47;3:label_char=8'h5F;4:label_char=8'h57;5:label_char=8'h44;6:label_char=8'h41;7:label_char=8'h54;8:label_char=8'h41;9:label_char=8'h3D; endcase // REG_WDATA=
                4: case (idx) 0:label_char=8'h44;1:label_char=8'h45;2:label_char=8'h53;3:label_char=8'h54;4:label_char=8'h3D; endcase // DEST=
                5: case (idx) 0:label_char=8'h4D;1:label_char=8'h45;2:label_char=8'h4D;3:label_char=8'h5F;4:label_char=8'h57;5:label_char=8'h3D; endcase // MEM_W=
                6: case (idx) 0:label_char=8'h4D;1:label_char=8'h45;2:label_char=8'h4D;3:label_char=8'h5F;4:label_char=8'h52;5:label_char=8'h3D; endcase // MEM_R=
                7: case (idx) 0:label_char=8'h4D;1:label_char=8'h45;2:label_char=8'h4D;3:label_char=8'h5F;4:label_char=8'h41;5:label_char=8'h44;6:label_char=8'h44;7:label_char=8'h52;8:label_char=8'h3D; endcase // MEM_ADDR=
                8: case (idx) 0:label_char=8'h44;1:label_char=8'h41;2:label_char=8'h54;3:label_char=8'h41;4:label_char=8'h5F;5:label_char=8'h49;6:label_char=8'h4E;7:label_char=8'h3D; endcase // DATA_IN=
                9: case (idx) 0:label_char=8'h44;1:label_char=8'h41;2:label_char=8'h54;3:label_char=8'h41;4:label_char=8'h5F;5:label_char=8'h4F;6:label_char=8'h55;7:label_char=8'h54;8:label_char=8'h3D; endcase // DATA_OUT=

            endcase
        end
    endfunction

    // ==================================================
    // Hex encoder
    // ==================================================
    function [7:0] hex_char;
        input [3:0] nib;
        begin
            if (nib < 10)
                hex_char = 8'h30 + nib;
            else
                hex_char = 8'h41 + (nib - 10);
        end
    endfunction

    // ==================================================
    // FSM (UART-safe)
    // ==================================================
    always @(posedge clk_100MHz) begin
        if (rst) begin
            state      <= SEND_LABEL;
            log_sel    <= 0;
            char_idx   <= 0;
            nibble_idx <= 0;
            write_en   <= 0;
        end else begin
            write_en <= 0;

            if (!uart_busy) begin
                case (state)

                    SEND_LABEL: begin
                        if (label_char(log_sel, char_idx) != 0) begin
                            uart_data <= label_char(log_sel, char_idx);
                            write_en  <= 1;
                            char_idx  <= char_idx + 1;
                        end else begin
                            log_latched <= log_data;
                            nibble_idx  <= 0;
                            state       <= SEND_DATA;
                        end
                    end

                    SEND_DATA: begin
                        case (nibble_idx)
                            0: uart_data <= hex_char(log_latched[31:28]);
                            1: uart_data <= hex_char(log_latched[27:24]);
                            2: uart_data <= hex_char(log_latched[23:20]);
                            3: uart_data <= hex_char(log_latched[19:16]);
                            4: uart_data <= hex_char(log_latched[15:12]);
                            5: uart_data <= hex_char(log_latched[11:8 ]);
                            6: uart_data <= hex_char(log_latched[7 :4 ]);
                            7: uart_data <= hex_char(log_latched[3 :0 ]);
                            8: uart_data <= 8'h0D;
                            9: uart_data <= 8'h0A;
                        endcase

                        write_en <= 1;

                        if (nibble_idx == 9) begin
                            nibble_idx <= 0;
                            char_idx   <= 0;
                            log_sel    <= (log_sel == 9) ? 0 : log_sel + 1;
                            state      <= SEND_LABEL;
                        end else begin
                            nibble_idx <= nibble_idx + 1;
                        end
                    end

                endcase
            end
        end
    end

endmodule


// `timescale 1ns / 1ps

// module top_nexys3(
//     input  wire clk_100MHz,
//     input  wire rst,
//     output wire rst_on,
//     output wire uart_tx
// );

//     assign rst_on = rst;

//     pc_one pc_one_instance(
// 		 .clk_from_FPGA_100MHz(clk_100MHz),
// 		 .rst_from_FPGA(rst),
// 		 .uart_tx_pin_for_FPGA(uart_tx)
//     );
    

// endmodule
