`timescale 1ns / 1ps

module upCounter(
    input i_clk,
    input i_reset,

    output [3:0] o_fndDigit,
    output [7:0] o_fndData
    );

    wire w_clk_1kHz, w_clk_10Hz;
    wire [1:0] w_counter;
    wire [13:0] w_value;
    wire [3:0] w_1000, w_100, w_10, w_1, w_data;

    clockDivider clkDiv(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk_1kHz(w_clk_1kHz)
    );

    counterFND cntFnd(
        .i_clk_1k(w_clk_1kHz),
        .i_reset(i_reset),
        .o_counter(w_counter)
    );

    decoder2x4 deco2x4(
        .i_counter(w_counter),
        .o_fndDigit(o_fndDigit)
    );

    clockDivider_10Hz clkDiv10(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk_10Hz(w_clk_10Hz)
    );

    counterData cntData(
        .i_data(w_clk_10Hz),
        .i_reset(i_reset),
        .o_value(w_value)
    );

    digitDivider digDiv(
        .i_value(w_value),
        .o_1(w_1),
        .o_10(w_10),
        .o_100(w_100),
        .o_1000(w_1000)
    );

    MUX4 mux(
        .i_1(w_1),
        .i_10(w_10),
        .i_100(w_100),
        .i_1000(w_1000),
        .i_counter(w_counter),
        .o_data(w_data)
    );

    BCDtoFNDdecoder bcdFndDeco(
        .i_data(w_data),
        .o_fndData(o_fndData)
    );
endmodule
