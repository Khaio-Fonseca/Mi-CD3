// Máquina de Estados
module state_machine(
    input H, M, L, Bs, Vs, Ve, Al, E, working, clock,
    output reg Ag, led
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
					 if(E) next_state = ERROR;
                else if (L && !E) next_state = CLEANING;
                else next_state = SPRINKLER; // Ajuste para permanecer em SPRINKLER até a condição ser satisfeita
            end
            DRIP: begin
					 if(E) next_state = ERROR; 
                else if (L && !E) next_state = CLEANING;
                else next_state = DRIP; // Ajuste para permanecer em DRIP até a condição ser satisfeita
					 
            end
            CLEANING: begin
                if (Ve) next_state = FILLING;
                else next_state = CLEANING; // Ajuste para permanecer em CLEANING até a condição ser satisfeita
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
            end
            FULL_BOX: begin
                Ag = 0;
                led = 0;
            end
            SPRINKLER: begin
                Ag = 1;
                led = 1;
            end
            DRIP: begin
                Ag = 0;
                led = 0;
            end
            CLEANING: begin
                Ag = 0;
                led = 0;
            end
            ERROR: begin
                Ag = 0;
                led = 0;
            end
            default: begin
                Ag = 0;
                led = 0;
            end
        endcase
    end
endmodule
