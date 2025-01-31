dule tb_state_machine;

    // Declara sinais para o testbench
    reg H, M, L, Bs, Vs, Ve, Al, E, working, clock;
    wire Ag, led;

    // Instancia o módulo state_machine
    state_machine uut (
        .H(H),
        .M(M),
        .L(L),
        .Bs(Bs),
        .Vs(Vs),
        .Ve(Ve),
        .Al(Al),
        .E(E),
        .working(working),
        .clock(clock),
        .Ag(Ag),
        .led(led)
    );

    // Gera o clock e controla o número de ciclos
    reg [8:0] cycle_count; // Contador para 0 a 250 ciclos

    initial begin
        clock = 0;
        cycle_count = 0;

        // Gera o clock e conta os ciclos
        forever begin
            cycle_count = cycle_count + 1;
            if (cycle_count == 249) begin
                $finish; // Finaliza a simulação após 250 ciclos
            end
				cycle_count = cycle_count + 1;
        end
    end

    // Inicializa sinais e aplica estímulos
    initial begin
        // Inicializa sinais
        H = 0;
        M = 0;
        L = 0;
        Bs = 0;
        Vs = 0;
        Ve = 0;
        Al = 0;
        E = 0;
        working = 0;

        // Teste com diferentes combinações de entradas
        #10;
        H = 1;
        #10;
        H = 0;
        Bs = 1;
        #10;
        Bs = 0;
        Vs = 1;
        #10;
        Vs = 0;
        L = 1;
        #10;
        L = 0;
        Ve = 1;
        #10;
        Ve = 0;
        E = 1; // Simula erro
        #10;
        E = 0; // Retorna ao estado FILLING
    end

    // Monitoramento dos sinais
    initial begin
        $monitor("Time: %0t | H: %b | M: %b | L: %b | Bs: %b | Vs: %b | Ve: %b | Al: %b | E: %b | working: %b | clock: %b | Ag: %b | led: %b | state: %b",
                 $time, H, M, L, Bs, Vs, Ve, Al, E, working, clock, Ag, led, uut.state);
    end
endmodule
