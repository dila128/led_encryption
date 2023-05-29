module LED_Decoder(
    input wire clk,
    input wire reset,
    output wire blue_led
);

reg [2:0] state;
reg [3:0] count;
reg [2:0] led_duration;
reg blue_led_reg;

parameter BLUE = 1'b1;

// Yanma sürelerini tutan tablo
reg [7:0] duration_table [10:0];

initial begin
    duration_table[0] = 1;   // 'ü' için 1 saniye
    duration_table[1] = 2;   // 'v' için 2 saniye
    duration_table[2] = 14;  // 'n' için 14 saniye
    duration_table[3] = 19;  // 's' için 19 saniye
    duration_table[4] = 5;   // 'e' için 5 saniye
    duration_table[5] = 18;  // 'r' için 18 saniye
    duration_table[6] = 9;   // 'i' için 9 saniye
    duration_table[7] = 20;  // 't' için 20 saniye
    duration_table[8] = 4;   // 'd' için 4 saniye
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        count <= 4'b0000;
        led_duration <= 3'b000;
        blue_led_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin  // Initial state
                state <= 3'b001;
            end
            3'b001: begin  // Blue LED state
                if (count < 11) begin  // 'üvnseritsinede' kelimesinin uzunluğu 11
                    blue_led_reg <= 1'b1;
                    led_duration <= duration_table[count];
                    count <= count + 1;
                end else begin
                    state <= 3'b010;
                    count <= 4'b0000;
                end
            end
            3'b010: begin  // Finished
                blue_led_reg <= 1'b0;
                state <= 3'b111;
            end
            default: begin
                state <= 3'b000;
                count <= 4'b0000;
                led_duration <= 3'b000;
                blue_led_reg <= 1'b0;
            end
        endcase
    end
end

assign blue_led = (led_duration > 0) ? BLUE : ~BLUE;

endmodule
