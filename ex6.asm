# ex4.asm
# Verifica paridade usando operacao AND com 1 (checar bit LSB).
# Marcadores: [Q4.Leitura], [Q4.TesteParidade]

.data
msg_in: .asciiz "Digite um numero inteiro: "
msg_par: .asciiz "O numero eh PAR\n"
msg_impar: .asciiz "O numero eh IMPAR\n"

.text
main:
    # [Q4.Leitura] pedir e ler inteiro
    li $v0, 4
    la $a0, msg_in
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # [Q4.TesteParidade] andi $t1, $t0, 1 -> se zero é par, senão ímpar
    andi $t1, $t0, 1
    beq $t1, $zero, eh_par

    # ímpar
    li $v0, 4
    la $a0, msg_impar
    syscall
    j fim

eh_par:
    li $v0, 4
    la $a0, msg_par
    syscall

fim:
    li $v0, 10
    syscall
