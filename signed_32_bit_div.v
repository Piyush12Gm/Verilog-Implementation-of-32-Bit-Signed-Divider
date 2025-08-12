`timescale 1ns / 1ps

`define Acc Dividend[31:16]

module sdiv (CLK, St, Dbus, Quotient, Remainder, V, Rdy);
    input CLK;
    input St;
    input [15:0] Dbus;
    output [15:0] Quotient;
    output [15:0] Remainder;
    output V;
    output Rdy;

    reg V;
    reg [2:0] State;
    reg [3:0] Count;
    reg Sign;

    wire C;
    wire Cm2;
    reg [15:0] Divisor;
    wire [15:0] Sum;
    wire [15:0] Compout;
    reg [31:0] Dividend;

    assign Cm2 = ~Divisor[15];
    assign Compout = (Cm2 == 1'b0) ? Divisor : ~Divisor;
    assign Sum = `Acc + Compout + Cm2;
    assign C = ~Sum[15];
    assign Quotient = Dividend[15:0];
    assign Remainder = Dividend[31:16];
    assign Rdy = (State == 0) ? 1'b1 : 1'b0;

    initial begin
        State = 0;
    end

    always @(posedge CLK) begin
        case (State)
            0: begin
                if (St == 1'b1) begin
                    `Acc <= Dbus;
                    Sign <= Dbus[15];
                    State <= 1;
                    V <= 1'b0;
                    Count <= 4'b0000;
                end
            end

            1: begin
                Dividend[15:0] <= Dbus;
                State <= 2;
            end

            2: begin
                Divisor <= Dbus;
                if (Sign == 1'b1) begin
                    Dividend <= ~Dividend + 1;
                end
                State <= 3;
            end

            3: begin
                Dividend <= {Dividend[30:0], 1'b0};
                Count <= Count + 1;
                State <= 4;
            end

            4: begin
                if (C == 1'b1) begin
                    V <= 1'b1;
                    State <= 0;
                end else begin
                    Dividend <= {Dividend[30:0], 1'b0};
                    Count <= Count + 1;
                    State <= 5;
                end
            end

            5: begin
                if (C == 1'b1) begin
                    `Acc <= Sum;
                    Dividend[0] <= 1'b1;
                end else begin
                    Dividend <= {Dividend[30:0], 1'b0};
                    if (Count == 15) begin
                        State <= 6;
                    end
                    Count <= Count + 1;
                end
            end

            6: begin
                State <= 0;
                if (C == 1'b1) begin
                    `Acc <= Sum;
                    Dividend[0] <= 1'b1;
                    State <= 6;
                end else if ((Sign ^ Divisor[15]) == 1'b1) begin
                    Dividend[15:0] <= ~Dividend[15:0] + 1;
                    if (Sign == 1) begin
                        Dividend[31:16] <= ~Dividend[31:16] + 1;
                    end
                end else begin
                    if (Sign && Divisor[15]) begin
                        Dividend[31:16] <= ~Dividend[31:16] + 1;
                    end
                end
            end
        endcase
    end
endmodule
