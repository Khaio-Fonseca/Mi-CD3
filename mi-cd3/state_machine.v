module state_machine(
    input H, M, L, Bs, Vs, Ve, Al, E, working, clock,
    output reg Ag, led,
    output reg a, b, c, d, e, f, g, // Saídas para os displays de 7 segmentos
    output reg d01, d02, d03, d04, // Saídas para os dígitos dos displays
    output reg [4:0] coluna,       // Saída das colunas da matriz de LEDs
    output reg [6:0] linha         // Saída das linhas da matriz de LEDs
);

    // Declaração dos estados
    reg [2:0] state, next_state;
    parameter FILLING = 3'b000, FULL_BOX = 3'b001, SPRINKLER = 3'b010, DRIP = 3'b011, CLEANING = 3'b100, ERROR = 3'b101;

    // Inicialização do estado
    initial begin
        state = FULL_BOX;  // Alterei para um estado que pode iniciar adequadamente
        Ag = 0;
        led = 0;
    end

    // Lógica de Transição de Estados
    always @(posedge clock or posedge E) begin
        if (E)
            state <= ERROR;
        else
            state <= next_state;
    end

    // Lógica de Próximo Estado
    always @(*) begin
        case (state)
            FILLING: begin
                if (E) next_state = ERROR;
                else if (H && !E) next_state = FULL_BOX;
                else next_state = FILLING;
            end
            FULL_BOX: begin
                if (Bs) next_state = SPRINKLER;
                else if (Vs) next_state = DRIP;
                else next_state = FULL_BOX;
            end
            SPRINKLER: begin
                if (E) next_state = ERROR;
                else if (L && !E) next_state = CLEANING;
                else next_state = SPRINKLER;
            end
            DRIP: begin
                if (E) next_state = ERROR;
                else if (L && !E) next_state = CLEANING;
                else next_state = DRIP;
            end
            CLEANING: begin
                if (Ve) next_state = FILLING;
                else next_state = CLEANING;
            end
            ERROR: begin
                if (!E) next_state = FILLING;
                else next_state = ERROR;
            end
            default: next_state = FILLING;
        endcase
    end

    // Lógica de Saída
    always @(state) begin
        case (state)
            FILLING: begin
                Ag = 0;
                led = 0;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b0000001; // Exemplo: Exibe '1'
                {d01, d02, d03, d04} = 4'b1000;
                linha = 7'b0000001;
                coluna = 5'b00001;
            end
            FULL_BOX: begin
                Ag = 0;
                led = 0;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b1001111; // Exemplo: Exibe 'L'
                {d01, d02, d03, d04} = 4'b0100;
                linha = 7'b0000010;
                coluna = 5'b00010;
            end
            SPRINKLER: begin
                Ag = 1;
                led = 1;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b1110111; // Exemplo: Exibe 'H'
                {d01, d02, d03, d04} = 4'b0010;
                linha = 7'b0000100;
                coluna = 5'b00100;
            end
            DRIP: begin
                Ag = 0;
                led = 0;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b0111111; // Exemplo: Exibe 'O'
                {d01, d02, d03, d04} = 4'b0001;
                linha = 7'b0001000;
                coluna = 5'b01000;
            end
            CLEANING: begin
                Ag = 0;
                led = 0;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b0000110; // Exemplo: Exibe 'C'
                {d01, d02, d03, d04} = 4'b1111;
                linha = 7'b0010000;
                coluna = 5'b10000;
            end
            ERROR: begin
                Ag = 0;
                led = 0;
                // Configurações para displays e LEDs
                {a, b, c, d, e, f, g} = 7'b1111110; // Exemplo: Exibe 'E'
                {d01, d02, d03, d04} = 4'b0000;
                linha = 7'b0100000;
                coluna = 5'b11111;
            end
            default: begin
                Ag = 0;
                led = 0;
                // Configurações padrão
                {a, b, c, d, e, f, g} = 7'b0000000;
                {d01, d02, d03, d04} = 4'b0000;
                linha = 7'b0000000;
                coluna = 5'b00000;
            end
        endcase
    end
endmodule
