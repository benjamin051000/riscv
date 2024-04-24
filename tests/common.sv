package common;

	// Must be automatic since we use `ref`
	task automatic delay(const ref logic clk, input int n);
		repeat (n) @(posedge clk);
	endtask

	task automatic pulse(const ref logic clk, ref logic signal, input int how_many_clk_pulses);
		// Must use blocking assignment since this must be an automatic task.
		signal = 1;
		delay(clk, how_many_clk_pulses);
		signal = 0;

		@(posedge clk);
	endtask

endpackage
