module safecontrol(
    input wire clk,
    input wire rst,
    input wire [3:0] invalue,
    /* key
    0-9 digits
    10 = hash or enter
    11 = star

    13 = no command

    */
    output reg lock,
    //0 is open, 1 is closed


    //for user communication, connected to RGB LEDs
    output reg green,
    output reg blue
    );

    reg [2:0] xcord = 3'd0;
    reg ycord = 0;

    /*
    #   0   1   2   3   4
    0   d00 d01 d02 d03 # to confirm
    1   d10 d11 d12 d13 # to confirm

    the d1s are used to store the password
    the d2s are used to store attempt
    */

    reg [2:0] state; // current state
    /*
    3'b000 = the open state
    3'b001 = has a code and is in normal operation mode
    */

    reg [3:0] d00;
    reg [3:0] d01;
    reg [3:0] d02;
    reg [3:0] d03;
    reg [3:0] d10;
    reg [3:0] d11;
    reg [3:0] d12;
    reg [3:0] d13;

    
        //reset all values
  
    

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
                lock <= 1'b0;
                green <= 1;
                blue <= 0;  

                xcord <= 3'd0;
                ycord <= 1'b0;

                state <= 3'b000;

                d00 <= 4'd0;
                d01 <= 4'd0;
                d02 <= 4'd0;
                d03 <= 4'd0;
                d10 <= 4'd0;
                d11 <= 4'd0;
                d12 <= 4'd0;
                d13 <= 4'd0;
            end else if (invalue != 4'd13) begin
                // process key press
                if (state == 3'b000) begin
                    //the open state
                    if (invalue == 4'd11) begin //handles the clear button case or star case
                            ycord <= 1'b0;
                            xcord <= 3'd0;

                    end else if (ycord == 0) begin 
                        if (invalue == 4'd10) begin //handles the enter row case or hashtag case
                            if (xcord == 3'd4) begin 
                                ycord <= 1'b1;
                                xcord <= 3'd0;
                            end
                        end else if (xcord != 3'd4) begin //handles all other cases, or all digit cases (ignore if already have 4 digits)
                            if (xcord == 3'd0) begin
                                d00 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd1) begin
                                d01 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd2) begin
                                d02 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd3) begin
                                d03 <= invalue;
                                xcord <= xcord + 3'd1;
                            end
                        end
                    end else if (ycord == 1) begin
                        if (invalue == 4'd10) begin //hashtag or confirm codes match case
                            if (xcord == 3'd4) begin 
                                //compare codes
                                if ( (d00 == d10) && (d01 == d11) && (d02 == d12) && (d03 == d13) ) begin
                                    //codes match
                                    lock <= 1'b1; //locks the safe
                                    green <= 0;
                                    blue <= 1; //sets light to blue

                                    state <= 3'b001; //move to normal operation state
                                    xcord <= 3'd0;
                                    ycord <= 1'b1;

                                end else begin
                                    //codes dont match
                                    ycord <= 1'b0;
                                    xcord <= 3'd0;
                                end

                            end
                            // If xcord < 4, repeated # does nothing (stay in same state)
                        end else if (xcord != 3'd4) begin //handles all other cases, or all digit cases (ignore if already have 4 digits)
                            if (xcord == 3'd0) begin
                                d10 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd1) begin
                                d11 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd2) begin
                                d12 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd3) begin
                                d13 <= invalue;
                                xcord <= xcord + 3'd1;
                            end
                        end
                        
                    end
                    
                end else if (state == 3'b001) begin
                    //the normal operation state
                    if (invalue == 4'd11) begin //handles the clear button case or star case
                        xcord <= 3'd0;
                    end else if (invalue == 4'd10) begin //hashtag or confirm codes match case
                            if (xcord == 3'd4) begin 
                                //compare codes
                                if ( (d00 == d10) && (d01 == d11) && (d02 == d12) && (d03 == d13) ) begin
                                    //codes match
                                    lock <= 1'b0; //unlocks the safe
                                    green <= 1; //sets light to green
                                    blue <= 0; 
                                    state <= 3'b000; //move to open state
                                    xcord <= 3'd0;
                                    ycord <= 1'b0;

                                end else begin
                                    //codes dont match
                                    ycord <= 1'b1;
                                    xcord <= 3'd0;
                                end

                            end
                            // If xcord < 4, repeated # does nothing (stay in same state)
                        end else if (xcord != 3'd4) begin //handles all other cases, or all digit cases (ignore if already have 4 digits)
                            if (xcord == 3'd0) begin
                                d10 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd1) begin
                                d11 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd2) begin
                                d12 <= invalue;
                                xcord <= xcord + 3'd1;
                            end else if (xcord == 3'd3) begin
                                d13 <= invalue;
                                xcord <= xcord + 3'd1;
                            end
                        end
                end
                end 

                
            
        end
endmodule

