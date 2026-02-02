module clockboss(
    input wire clk,
    input wire rst,
    output reg c1,
    output reg c2
    );

    reg toggle;
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            toggle <= 1'b0;
        end else begin
            toggle <= ~toggle;
        end
    end
    always @* begin
        c1 = toggle;
        c2 = ~toggle;
    end

endmodule


