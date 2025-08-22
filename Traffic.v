// Traffic Light Controller FSM
// Supports Vehicle: Green, Yellow, Red
// Pedestrian phase is included when requested
// Synthesizable in Cadence Genus (Verilog-2001 style)

module traffic_light_controller (
    input  wire clk,
    input  wire reset,         // synchronous active high reset
    input  wire ped_request,   // pedestrian button input
    output reg  car_green,
    output reg  car_yellow,
    output reg  car_red,
    output reg  ped_walk
);

    // State encoding
    parameter S_CAR_GREEN  = 3'b000;
    parameter S_CAR_YELLOW = 3'b001;
    parameter S_CAR_RED    = 3'b010;
    parameter S_PED_GREEN  = 3'b011; // pedestrian walk

    reg [2:0] current_state, next_state;

    // Sequential state transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S_CAR_GREEN;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (current_state)
            S_CAR_GREEN: begin
                if (ped_request)
                    next_state = S_CAR_YELLOW;
                else
                    next_state = S_CAR_GREEN;
            end

            S_CAR_YELLOW: begin
                next_state = S_CAR_RED;
            end

            S_CAR_RED: begin
                if (ped_request)
                    next_state = S_PED_GREEN;
                else
                    next_state = S_CAR_GREEN;
            end

            S_PED_GREEN: begin
                next_state = S_CAR_GREEN;
            end

            default: next_state = S_CAR_GREEN;
        endcase
    end

    // Moore Output logic (depends only on state)
    always @(*) begin
        // default off
        car_green  = 1'b0;
        car_yellow = 1'b0;
        car_red    = 1'b0;
        ped_walk   = 1'b0;

        case (current_state)
            S_CAR_GREEN:  car_green  = 1'b1;
            S_CAR_YELLOW: car_yellow = 1'b1;
            S_CAR_RED:    car_red    = 1'b1;
            S_PED_GREEN:  ped_walk   = 1'b1;
        endcase
    end

endmodule
