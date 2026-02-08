# ex2.asm
# Lê três inteiros diferentes, valida duplicatas e imprime Maior, Intermediário e Menor.
# Marcadores: [Q2.LerN1], [Q2.LerN2], [Q2.LerN3], [Q2.ValidaDiferentes], [Q2.Ordena3],
# [Q2.PrintMaior], [Q2.PrintInter], [Q2.PrintMenor]

.data
msg_n1:  .asciiz "Digite o 1o numero (inteiro e diferente dos outros): "
msg_n2:  .asciiz "Digite o 2o numero (inteiro e diferente dos outros): "
msg_n3:  .asciiz "Digite o 3o numero (inteiro e diferente dos outros): "
msg_dup: .asciiz "Os numeros devem ser diferentes. Tente novamente.\n"
msg_maior: .asciiz "Maior valor: "
msg_inter: .asciiz "Valor intermediario: "
msg_menor: .asciiz "Menor valor: "
newline: .asciiz "\n"

.text
main:
    # [Q2.LerN1] ler primeiro numero
    li $v0, 4
    la $a0, msg_n1
    syscall
    li $v0, 5
    syscall
    move $s0, $v0   # a = $s0

ler_n2:
    # [Q2.LerN2] ler segundo numero
    li $v0, 4
    la $a0, msg_n2
    syscall
    li $v0, 5
    syscall
    move $s1, $v0   # b = $s1

    # [Q2.ValidaDiferentes] se b == a -> erro e repete desde N2
    beq $s1, $s0, numeros_iguais

ler_n3:
    # [Q2.LerN3] ler terceiro numero
    li $v0, 4
    la $a0, msg_n3
    syscall
    li $v0, 5
    syscall
    move $s2, $v0   # c = $s2

    # valida diferente de a e b
    beq $s2, $s0, numeros_iguais
    beq $s2, $s1, numeros_iguais

    # [Q2.Ordena3] ordenar usando trocas simples
    move $t0, $s0    # t0 = a
    move $t1, $s1    # t1 = b
    move $t2, $s2    # t2 = c

    # if t0 > t1 : swap
    ble $t0, $t1, cmp12_done
    move $t3, $t0
    move $t0, $t1
    move $t1, $t3
cmp12_done:

    # if t1 > t2 : swap
    ble $t1, $t2, cmp23_done
    move $t3, $t1
    move $t1, $t2
    move $t2, $t3
cmp23_done:

    # repetir comparacao 1 e 2 para garantir ordenacao
    ble $t0, $t1, sorted
    move $t3, $t0
    move $t0, $t1
    move $t1, $t3
sorted:
    # agora: t0 = menor, t1 = intermediario, t2 = maior

    # [Q2.PrintMaior]
    li $v0, 4
    la $a0, msg_maior
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # [Q2.PrintInter]
    li $v0, 4
    la $a0, msg_inter
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # [Q2.PrintMenor]
    li $v0, 4
    la $a0, msg_menor
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # fim do programa
    li $v0, 10
    syscall

numeros_iguais:
    # [Q2.ValidaDiferentes] mostra erro e volta para ler_n2
    li $v0, 4
    la $a0, msg_dup
    syscall
    j ler_n2
