.data
  prompt_n:     .asciiz "Digite o numero de elementos (N > 0): "
  error_n:      .asciiz "N deve ser maior que 0. Tente novamente.\n"
  prompt_num:   .asciiz "Digite um numero: "
  sorted_msg:   .asciiz "Numeros ordenados: "
  swaps_msg:    .asciiz "Total de trocas realizadas: "
  comma_space:  .asciiz ", "
  nl:           .asciiz "\n"

.text
.globl main

# main
# - Lê a quantidade de números (N)
# - Aloca dinamicamente espaço para N elementos
# - Lê os N números
# - Ordena com Bubble Sort
# - Exibe vetor ordenado e total de trocas
main:
    li      $v0, 4
    la      $a0, prompt_n
    syscall

# Leitura de N
read_n:
    li      $v0, 5
    syscall
    move    $s0, $v0
    blez    $s0, invalid_n

    sll     $a0, $s0, 2
    li      $v0, 9
    syscall
    move    $s1, $v0
    beqz    $s1, exit

# Leitura dos N números
    li      $t0, 0
    move    $t1, $s1

read_loop:
    bge     $t0, $s0, end_read

    li      $v0, 4
    la      $a0, prompt_num
    syscall

    li      $v0, 5
    syscall
    sw      $v0, 0($t1)

    addi    $t0, $t0, 1
    addi    $t1, $t1, 4
    j       read_loop

# Chama Bubble Sort (ordenação crescente)
end_read:
    move    $a0, $s1
    move    $a1, $s0
    jal     bubble_sort
    move    $s2, $v0

# Impressão do vetor ordenado e total de trocas
    li      $v0, 4
    la      $a0, sorted_msg
    syscall

    li      $t0, 0
    move    $t1, $s1

print_loop:
    bge     $t0, $s0, end_print
    lw      $a0, 0($t1)
    li      $v0, 1
    syscall

    addi    $t0, $t0, 1

    beq     $t0, $s0, end_print
    li      $v0, 4
    la      $a0, comma_space
    syscall

    addi    $t1, $t1, 4
    j       print_loop

end_print:
    li      $v0, 4
    la      $a0, nl
    syscall

    li      $v0, 4
    la      $a0, swaps_msg
    syscall

    li      $v0, 1
    move    $a0, $s2
    syscall

    j       exit

# Caso N seja inválido, exibe mensagem e pede novamente
invalid_n:
    li      $v0, 4
    la      $a0, error_n
    syscall
    j       read_n

# Finaliza execução
exit:
    li      $v0, 10
    syscall

# bubble_sort
# - Ordena o vetor em ordem crescente
# - Conta quantas trocas foram feitas
# - Retorna número de trocas em $v0
bubble_sort:
    addi    $sp, $sp, -16
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)

    move    $s0, $a0
    move    $s1, $a1
    li      $s2, 0

    addi    $t0, $s1, -1

outer:
    blez    $t0, done
    li      $t1, 0

inner:
    addi    $t2, $t1, 1
    bge     $t2, $s1, next_i

    sll     $t3, $t1, 2
    add     $t3, $s0, $t3
    lw      $t4, 0($t3)
    lw      $t5, 4($t3)

    ble     $t4, $t5, noswap
    sw      $t5, 0($t3)
    sw      $t4, 4($t3)
    addi    $s2, $s2, 1

noswap:
    addi    $t1, $t1, 1
    j       inner

next_i:
    addi    $t0, $t0, -1
    j       outer

done:
    move    $v0, $s2

    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    addi    $sp, $sp, 16
    jr      $ra