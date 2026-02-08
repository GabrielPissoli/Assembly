# ex1.asm
# Calculadora MIPS com menu repetitivo, tratamento de divisao por zero e opcoes invalidas.
# Marcadores usados: [Q1.Menu], [Q1.LeOpcao], [Q1.Sair], [Q1.ValidaOpcao],
# [Q1.LerOperandos], [Q1.ValidaDivZero], [Q1.ErroDivZero], [Q1.Operacoes],
# [Q1.Soma], [Q1.Subtracao], [Q1.Multiplicacao], [Q1.Divisao], [Q1.Loop]

.data
menu_str:       .asciiz "\n===== CALCULADORA MIPS =====\n1) Somar\n2) Subtrair\n3) Multiplicar\n4) Dividir\n5) Sair\nEscolha uma opcao (1-5): "
opt_invalida:   .asciiz "Opcao invalida. Tente novamente.\n"
prompt_n1:      .asciiz "Digite o 1o inteiro: "
prompt_n2:      .asciiz "Digite o 2o inteiro: "
erro_div_zero:  .asciiz "Erro: divisao por zero nao permitida. Informe outro N2.\n"
res_soma:       .asciiz "Resultado (soma): "
res_sub:        .asciiz "Resultado (subtracao): "
res_mul:        .asciiz "Resultado (multiplicacao): "
res_div_q:      .asciiz "Quociente: "
res_div_r:      .asciiz "  Resto: "
newline:        .asciiz "\n"

.text
main:
    # [Q1.Loop] Loop principal: reapresenta menu até usuário escolher Sair (5)
menu_loop:
    # [Q1.Menu] imprimir menu
    li $v0, 4
    la $a0, menu_str
    syscall

    # [Q1.LeOpcao] ler opção do usuário (int)
    li $v0, 5
    syscall
    move $t7, $v0      # guardamos opção em $t7

    # [Q1.Sair] se for 5 -> encerra
    li $t0, 5
    beq $t7, $t0, fim

    # [Q1.ValidaOpcao] validar 1..4
    li $t0, 1
    blt $t7, $t0, opcao_invalida
    li $t0, 4
    bgt $t7, $t0, opcao_invalida

    # [Q1.LerOperandos] ler N1
    li $v0, 4
    la $a0, prompt_n1
    syscall
    li $v0, 5
    syscall
    move $s0, $v0      # N1 em $s0

    # ler N2 (pode ser refeito se for divisao e N2==0)
ler_n2:
    li $v0, 4
    la $a0, prompt_n2
    syscall
    li $v0, 5
    syscall
    move $s1, $v0      # N2 em $s1

    # [Q1.ValidaDivZero] se op = 4 (divisao) e N2 == 0 -> erro e pede novamente
    li $t0, 4
    bne $t7, $t0, faz_operacao   # se nao for divisao, pula validacao
    beq $s1, $zero, div_zero     # se N2==0 -> mensagem e repete ler_n2

faz_operacao:
    # [Q1.Operacoes] despacha conforme opcao (1..4)
    li $t0, 1
    beq $t7, $t0, do_soma
    li $t0, 2
    beq $t7, $t0, do_sub
    li $t0, 3
    beq $t7, $t0, do_mul
    li $t0, 4
    beq $t7, $t0, do_div

    j menu_loop   # fallback (não esperado)

# [Q1.Soma]
do_soma:
    addu $t1, $s0, $s1    # t1 = N1 + N2
    li $v0, 4
    la $a0, res_soma
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

# [Q1.Subtracao]
do_sub:
    subu $t1, $s0, $s1    # t1 = N1 - N2
    li $v0, 4
    la $a0, res_sub
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

# [Q1.Multiplicacao]
do_mul:
    mult $s0, $s1         # produto no hi/lo
    mflo $t1              # pega parte baixa do produto (assumindo que cabe)
    li $v0, 4
    la $a0, res_mul
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

# [Q1.Divisao]
do_div:
    div $s0, $s1          # divide N1 por N2
    mflo $t1              # quociente
    mfhi $t2              # resto
    # imprime quociente
    li $v0, 4
    la $a0, res_div_q
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    # imprime resto
    li $v0, 4
    la $a0, res_div_r
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

opcao_invalida:
    # [Q1.ErroOpcao] mensagem para opção inválida
    li $v0, 4
    la $a0, opt_invalida
    syscall
    j menu_loop

div_zero:
    # [Q1.ErroDivZero] mensagem e volta para ler_n2
    li $v0, 4
    la $a0, erro_div_zero
    syscall
    j ler_n2

fim:
    # [Q1.Sair] encerra o programa
    li $v0, 10
    syscall
