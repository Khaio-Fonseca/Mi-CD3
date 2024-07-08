// Declaração do Módulo Combinacional
module pbl1(
    input H, M, L, T, Us, Ua, clock,
    output Bs, Vs, Ve, Al, E, working, segA, segB, segC, segD, segE, segF, segG,
    output [3:0] seven_seg_digit,
    output [4:0] column,
    output [6:0] lines
);

    // Declaração dos Fios
    wire w0, w1, notL, notM, w4, w5, w6, w7, lowUs, lowUa, w10, w11, lowTemp, w13, w14, w15, w16, w17, notErro, notH;

    // Circuito de Erro de Medição
    not Not0 (notL, L);
    not Not1 (notM, M);
    and And0 (w0, M, notL);
    and And1 (w1, H, notM);
    or Or0 (E, w0, w1);
    not Not2 (notErro, E); // Inversor do Erro para Fechar os Acionamentos

    // Circuito de Acionamento da Válvula de Entrada
    not Not3 (notH, H);
    and And2 (w4, notH, notM, notL, notErro);
    and And3 (w5, notH, L, notErro);
    or Or1 (Ve, w4, w5);

    // Circuito de Acionamento do Alarme
    and And4 (w6, notH, notM, L); // Nível mínimo
    and And5 (w7, notH, notM, notL); // Nível crítico
    or Or2 (Al, w6, w7, E); // Nível mínimo, crítico ou erro de medição

    // Circuito de Acionamento do Sistema de Aspersão
    not Not4 (lowUs, Us);
    not Not5 (lowUa, Ua);
    and And7 (w10, lowUs, lowUa);
    and And8 (w11, lowUs, Ua, T, M);
    or Or4 (w16, w10, w11);
    and And9 (Bs, w16, notErro); // Fechar o Acionamento em Caso de Erro

    // Circuito de Acionamento do Sistema de Gotejamento
    not Not6 (lowTemp, T);
    and And10 (w13, lowUs, Ua, lowTemp);
    and And11 (w14, lowUs, Ua, T, notM, L);
    or Or5 (w17, w13, w14);
    and And12 (Vs, w17, notErro); // Fechar o Acionamento em Caso de Erro

    // Acionamento dos LEDs de status de funcionamento
    assign working = notErro; // LED verde que indica o funcionamento correto


endmodule
