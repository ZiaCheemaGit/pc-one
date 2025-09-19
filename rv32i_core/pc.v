module pc(
    input clk,
    input rst,
    input [31:0] jump_address,
    output reg [31:0] pc_next
);

    reg [31:0] pc_value;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_value <= 32'b0;   
        end else begin
            pc_value <= jump_address;
        end
    end

    always @(*) begin
        pc_next = pc_value;  
    end

endmodule