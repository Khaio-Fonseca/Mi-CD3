`timescale 1ns / 1ps

module testbench;

    // Declaração das entradas do módulo como registradores (reg)
    reg H, M, L, T, Us, Ua, clock;

    // Declaração das saídas do módulo como fios (wire)
    wire Bs, Vs, Ve, Al, E, working, Ag, led;
    wire segA, segB, segC, segD, segE, segF, segG;
    wire [3:0] seven_seg_digit;
    wire [4:0] column;
    wire [6:0] lines;

    // Instanciação do módulo principal (sistema de rega)
    sistemaRega uut (
        .H(H), .M(M), .L(L), .T(T), .Us(Us), .Ua(Ua), .clock(clock),
        .Bs(Bs), .Vs(Vs), .Ve(Ve), .Al(Al), .E(E), .working(working), .Ag(Ag), .led(led),
        .segA(segA), .segB(segB), .segC(segC), .segD(segD), .segE(segE), .segF(segF), .segG(segG),
        .seven_seg_digit(seven_seg_digit), .column(column), .lines(lines)
    );

    // Gerar clock
    initial begin
        clock = 0;
    end

    // Testes de Transição de Estados
    initial begin
        // Inicialização das entradas
        H = 0; M = 0; L = 0; T = 0; Us = 0; Ua = 0;

        // Teste: Estado inicial (FULL_BOX)
        #10;
        H = 1; M = 0; L = 0; #10;
        H = 0; M = 1; L = 0; #10;
        H = 0; M = 0; L = 1; #10;

        // Transição para FILLING
        H = 0; M = 0; L = 0; #10;

        // Simular estado FULL_BOX -> SPRINKLER
        H = 0; M = 0; L = 0; Us = 0; Ua = 1; T = 1; #10;

        // Simular estado SPRINKLER -> CLEANING
        H = 0; M = 0; L = 1; Us = 0; Ua = 0; T = 0; #10;

        // Simular estado CLEANING -> FILLING
        H = 0; M = 0; L = 0; #10;

        // Simular estado FILLING -> FULL_BOX
        H = 1; #10;

        // Simular estado FULL_BOX -> DRIP
        H = 0; M = 0; L = 0; Us = 0; Ua = 1; T = 0; #10;

        // Simular estado DRIP -> CLEANING
        H = 0; M = 0; L = 1; Us = 0; Ua = 0; T = 0; #10;

        // Simular estado CLEANING -> FILLING
        H = 0; M = 0; L = 0; #10;

        // Simular estado FILLING -> ERROR (provocar erro nas entradas)
        H = 1; M = 1; L = 1; #10;  // Isso deve causar um erro de medição (E = 1)

        // Simular estado ERROR -> FILLING (recuperação)
        H = 0; M = 0; L = 0; #10;  // Reset das entradas para recuperar do erro

        // Fim da simulação
        $finish;
    end

endmodule
