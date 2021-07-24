// Author: Alex Nagy
// TWIDDLE FACTOR ROM: For a given 4-bit address, access 
// and output corresponding twiddle factor real and imaginary values. 

module Twiddle_Factor_ROM(
    output logic signed [15:0] Tw_real, Tw_imag,
    input  logic    [3:0]  Tw_addr,
    input  logic    clk
);
    
    `include "macros_twiddle_rom.v"
    
    always_comb begin
        
        case(Tw_addr)

            ADDR_0: begin     
                Tw_real = TW_REAL_0;
                Tw_imag = TW_IMAG_0;
            end

            ADDR_1: begin     
                Tw_real = TW_REAL_1;
                Tw_imag = TW_IMAG_1;
            end

            ADDR_2: begin     
                Tw_real = TW_REAL_2;
                Tw_imag = TW_IMAG_2;
            end

            ADDR_3: begin     
                Tw_real = TW_REAL_3;
                Tw_imag = TW_IMAG_3;
            end

            ADDR_4: begin     
                Tw_real = TW_REAL_4;
                Tw_imag = TW_IMAG_4;
            end

            ADDR_5: begin     
                Tw_real = TW_REAL_5;
                Tw_imag = TW_IMAG_5;
            end

            ADDR_6: begin     
                Tw_real = TW_REAL_6;
                Tw_imag = TW_IMAG_6;
            end

            ADDR_7: begin     
                Tw_real = TW_REAL_7;
                Tw_imag = TW_IMAG_7;
            end

            ADDR_8: begin     
                Tw_real = TW_REAL_8;
                Tw_imag = TW_IMAG_8;
            end

            ADDR_9: begin     
                Tw_real = TW_REAL_9;
                Tw_imag = TW_IMAG_9;
            end

            ADDR_10: begin     
                Tw_real = TW_REAL_10;
                Tw_imag = TW_IMAG_10;
            end

            ADDR_11: begin     
                Tw_real = TW_REAL_11;
                Tw_imag = TW_IMAG_11;
            end

            ADDR_12: begin     
                Tw_real = TW_REAL_12;
                Tw_imag = TW_IMAG_12;
            end

            ADDR_13: begin     
                Tw_real = TW_REAL_13;
                Tw_imag = TW_IMAG_13;
            end

            ADDR_14: begin     
                Tw_real = TW_REAL_14;
                Tw_imag = TW_IMAG_14;
            end

            ADDR_15: begin     
                Tw_real = TW_REAL_15;
                Tw_imag = TW_IMAG_15;
            end

            default: Tw_real = 16'bx;

        endcase
    end 

endmodule
