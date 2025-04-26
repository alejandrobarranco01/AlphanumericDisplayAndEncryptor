module encrypt (
    input [7:0] ascii_in, // ASCII input character
    input [7:0] shift_value, // Shift amount
    output reg [7:0] ascii_out // Encrypted ASCII output character
);

always @(*) begin: logic
    ascii_out = ascii_in;

    // Encryption logic for digits (0-9)
    // Check if the input ASCII character is a digit (ASCII values 48 to 57)
    if ((ascii_in >= 8'd48) && (ascii_in <= 8'd57)) begin
        // Shift the input forward by the shift value (modulo 10 to wrap around the digit range)
        ascii_out = ascii_in + (shift_value % 10);
        // If the result goes above '9' (ASCII 57), wrap around the digit range
        if (ascii_out > 8'd57) ascii_out = ascii_out - 10;
    end

    // Encryption logic for uppercase letters (A-Z)
    // Check if the input ASCII character is uppercase (ASCII values 65 to 90)
    else if ((ascii_in >= 8'd65) && (ascii_in <= 8'd90)) begin
        // Shift the input forward by the shift value (modulo 26 to wrap around the alphabet)
        ascii_out = ascii_in + (shift_value % 26);
        // If the result goes above 'Z' (ASCII 90), wrap around the uppercase range
        if (ascii_out > 8'd90) ascii_out = ascii_out - 26;
    end

    // Encryption logic for lowercase letters (a-z)
    // Check if the input ASCII character is lowercase (ASCII values 97 to 122)
    else if ((ascii_in >= 8'd97) && (ascii_in <= 8'd122)) begin
        // Shift the input forward by the shift value (modulo 26 to wrap around the alphabet)
        ascii_out = ascii_in + (shift_value % 26);
        // If the result goes above 'z' (ASCII 122), wrap around the lowercase range
        if (ascii_out > 8'd122) ascii_out = ascii_out - 26;
    end
end

endmodule
