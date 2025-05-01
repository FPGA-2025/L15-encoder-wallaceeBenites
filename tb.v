`timescale 1ns/1ps

module tb();

    reg clk = 0;
    reg rst_n = 0;
    reg horario = 0;
    reg antihorario = 0;

    wire A, B;
    wire [1:0] dir;

    // DUTs
    Encoder dut_encoder (
        .clk(clk),
        .rst_n(rst_n),
        .horario(horario),
        .antihorario(antihorario),
        .A(A),
        .B(B)
    );

    Read_Encoder dut_reader (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .dir(dir)
    );

    // Clock: 10ns período
    always #5 clk = ~clk;

    // Memória de testes
    reg [3:0] memoria [0:255]; // 4 bits por linha
    integer i;

    initial begin
        // Inicialização
        $readmemb("teste.txt", memoria);
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        // Reset
        rst_n = 0;
        #12;
        rst_n = 1;

        // Aplicação de estímulos
        for (i = 0; i < 256; i = i + 1) begin
            if (^memoria[i] === 1'bx) begin
                $display("Fim da memória em linha %0d", i);
                $finish;
            end

            // Sinais de entrada
            {horario, antihorario} = memoria[i][3:2];
            #10; // espera 1 ciclo de clock

            // Verifica resultado
            if (dir !== memoria[i][1:0]) begin
                $display("=== ERRO linha %0d: horario=%b, antihorario=%b, esperado dir=%b, obtido dir=%b",
                          i, horario, antihorario, memoria[i][1:0], dir);
            end else begin
                $display("=== OK linha %0d: horario=%b, antihorario=%b, dir=%b",
                          i, horario, antihorario, dir);
            end
        end

        $finish;
    end

endmodule
