// File: encrypt.v
module encrypt (
    input [7:0] ascii_in,
    input [7:0] shift_value, // Use shift_value instead of leds
    output reg [7:0] ascii_out
);

always @(*) begin: encryption_logic
    ascii_out = ascii_in;

    // Digits (0-9)
    if ((ascii_in >= 8'd48) && (ascii_in <= 8'd57)) begin
        ascii_out = ascii_in + shift_value;
        if (ascii_out > 8'd57) ascii_out = ascii_out - 10;
    end
    // Uppercase (A-Z)
    else if ((ascii_in >= 8'd65) && (ascii_in <= 8'd90)) begin
        ascii_out = ascii_in + shift_value;
        if (ascii_out > 8'd90) ascii_out = ascii_out - 26;
    end
    // Lowercase (a-z)
    else if ((ascii_in >= 8'd97) && (ascii_in <= 8'd122)) begin
        ascii_out = ascii_in + shift_value;
        if (ascii_out > 8'd122) ascii_out = ascii_out - 26;
    end
end

endmodule