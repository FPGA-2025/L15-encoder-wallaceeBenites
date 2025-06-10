module Encoder (
    input wire clk,
    input wire rst_n, 

    input wire horario,     
    input wire antihorario, 

    output reg A, 
    output reg B  
);


    reg [1:0] current_ab;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            current_ab <= 2'b00;
        end else begin
    
            if (horario && !antihorario) begin

                case (current_ab)
                    2'b00: current_ab <= 2'b10;
                    2'b10: current_ab <= 2'b11;
                    2'b11: current_ab <= 2'b01;
                    2'b01: current_ab <= 2'b00;
                    default: current_ab <= 2'b00; 
                endcase
            end else if (antihorario && !horario) begin

                case (current_ab)
                    2'b00: current_ab <= 2'b01;
                    2'b01: current_ab <= 2'b11;
                    2'b11: current_ab <= 2'b10;
                    2'b10: current_ab <= 2'b00;
                    default: current_ab <= 2'b00; 
                endcase
            end

        end
    end

    always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           A <= 1'b0;
           B <= 1'b0;
       end else begin

           A <= current_ab[1];
           B <= current_ab[0];
       end
    end
    

endmodule
