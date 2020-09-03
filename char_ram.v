
module char_ram (address, dataIn, update, dataOut);
//parameter definition
parameter NUM_OF_CHARS = 5;


// Port definition
input [5:0] address;
input [7:0] dataIn;
input update;

output [7:0] dataOut;

// Reg definition
reg [3:0] counterOut = 'b0;
reg [3:0] counterIn = 'b0;
reg [7:0] memory [0:31];

always@(*)
	case (address)
		'd0: begin 
	 
		end 
		'd1: begin 
		 
		end 
		'd2: begin 
		 
		end 
		'd3: begin 
		 
		end 
		'd4: begin 
		 
		end 
		'd5: begin 
		 
		end 
		'd6: begin 
		 
		end 
		'd7: begin 
		 
		end 
		'd8: begin 
		 
		end 
		'd9: begin 
		 
		end 
		'd10: begin 
		 
		end 
		'd11: begin 
		 
		end 
		'd12: begin 
		 
		end 
		'd13: begin 
		 
		end 
		'd14: begin 
		 
		end 
		'd15: begin 
		 
		end 
		'd16: begin 
		 
		end 
		'd17: begin 
		 
		end 
		'd18: begin 
		 
		end 
		'd19: begin 
		 
		end 
		'd20: begin 
		 
		end 
		'd21: begin 
		 
		end 
		'd22: begin 
		 
		end 
		'd23: begin 
		 
		end 
		'd24: begin 
		 
		end 
		'd25: begin 
		 
		end 
		'd26: begin 
		 
		end 
		'd27: begin 
		 
		end 
		'd28: begin 
		 
		end 
		'd29: begin 
		 
		end 
		'd30: begin 
		 
		end 
		'd31: begin 
	 
		end 
	endcase

endmodule