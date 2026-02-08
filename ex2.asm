.data
  menu:               .asciiz "\n1. Inserir novo item\n2. Excluir item por codigo\n3. Buscar item por codigo\n4. Atualizar quantidade por codigo\n5. Imprimir estoque completo\n6. Sair\n> Opcao: "
  msg_invalida:       .asciiz "Opcao invalida!\n"
  msg_codigo:         .asciiz "Digite o codigo do produto: "
  msg_qtd:            .asciiz "Digite a quantidade: "
  msg_ok:             .asciiz "Item inserido com sucesso!\n"
  msg_removido:       .asciiz "Item removido com sucesso!\n"
  msg_nao_encontrado: .asciiz "Produto nao encontrado.\n"
  msg_encontrado:     .asciiz "Produto codigo "
  msg_qtd_disp:       .asciiz " encontrado. Quantidade: "
  msg_atualizado:     .asciiz "Quantidade atualizada com sucesso.\n"
  msg_vazio:          .asciiz "Estoque vazio.\n"
  msg_codigo_str:     .asciiz "codigo:  "
  msg_qtd_str:        .asciiz "\nQuantidade: "
  sep:                .asciiz "\n--------------------\n"

.text
.globl main

# main
# - Exibe menu e trata as opções do usuário
# - Cada opção chama uma função correspondente
main:
    li      $s0, 0                # ponteiro da lista (início = NULL)

menu_loop:
    # mostra menu
    li      $v0, 4
    la      $a0, menu
    syscall

    # lê opção do usuário
    li      $v0, 5
    syscall
    move    $t0, $v0

    # decide qual função chamar
    li      $t1, 1
    beq     $t0, $t1, inserir_item
    li      $t1, 2
    beq     $t0, $t1, excluir_item
    li      $t1, 3
    beq     $t0, $t1, buscar_item
    li      $t1, 4
    beq     $t0, $t1, atualizar_item
    li      $t1, 5
    beq     $t0, $t1, imprimir_estoque
    li      $t1, 6
    beq     $t0, $t1, sair

    # opção inválida
    li      $v0, 4
    la      $a0, msg_invalida
    syscall
    j       menu_loop

# inserir_item
# - Lê código e quantidade
# - Cria novo nó
# - Insere no final da lista
inserir_item:
    # lê código
    li      $v0, 4
    la      $a0, msg_codigo
    syscall
    li      $v0, 5
    syscall
    move    $t1, $v0

    # lê quantidade
    li      $v0, 4
    la      $a0, msg_qtd
    syscall
    li      $v0, 5
    syscall
    move    $t2, $v0

    # aloca memória para nó (12 bytes)
    li      $a0, 12
    li      $v0, 9
    syscall
    move    $t3, $v0

    # grava valores no nó
    sw      $t1, 0($t3)           # código
    sw      $t2, 4($t3)           # quantidade
    sw      $zero, 8($t3)         # próximo = NULL

    # se lista vazia, insere no início
    beq     $s0, $zero, inserir_primeiro

    # senão, percorre até o final e insere lá
    move    $t5, $s0
ins_loop:
    lw      $t6, 8($t5)
    beq     $t6, $zero, inserir_fim
    move    $t5, $t6
    j       ins_loop

inserir_fim:
    sw      $t3, 8($t5)
    j       inserir_ok

inserir_primeiro:
    move    $s0, $t3

inserir_ok:
    li      $v0, 4
    la      $a0, msg_ok
    syscall
    j       menu_loop

# excluir_item
# - Busca nó pelo código
# - Remove da lista
excluir_item:
    li      $v0, 4
    la      $a0, msg_codigo
    syscall
    li      $v0, 5
    syscall
    move    $t1, $v0

    move    $t2, $s0
    move    $t3, $zero

ex_loop:
    beq     $t2, $zero, ex_nao
    lw      $t4, 0($t2)
    beq     $t1, $t4, ex_achou
    move    $t3, $t2
    lw      $t2, 8($t2)
    j       ex_loop

ex_achou:
    beq     $t3, $zero, ex_head
    lw      $t5, 8($t2)
    sw      $t5, 8($t3)
    j       ex_ok

ex_head:
    lw      $t5, 8($t2)
    move    $s0, $t5

ex_ok:
    li      $v0, 4
    la      $a0, msg_removido
    syscall
    j       menu_loop

ex_nao:
    li      $v0, 4
    la      $a0, msg_nao_encontrado
    syscall
    j       menu_loop

# buscar_item
# - Busca um item pelo código e exibe quantidade
buscar_item:
    li      $v0, 4
    la      $a0, msg_codigo
    syscall
    li      $v0, 5
    syscall
    move    $t1, $v0

    move    $t2, $s0
bus_loop:
    beq     $t2, $zero, bus_nao
    lw      $t3, 0($t2)
    beq     $t1, $t3, bus_ok
    lw      $t2, 8($t2)
    j       bus_loop

bus_ok:
    li      $v0, 4
    la      $a0, msg_encontrado
    syscall
    li      $v0, 1
    move    $a0, $t3
    syscall
    li      $v0, 4
    la      $a0, msg_qtd_disp
    syscall
    lw      $t4, 4($t2)
    li      $v0, 1
    move    $a0, $t4
    syscall
    li      $v0, 4
    la      $a0, sep
    syscall
    j       menu_loop

bus_nao:
    li      $v0, 4
    la      $a0, msg_nao_encontrado
    syscall
    j       menu_loop

# atualizar_item
# - Atualiza a quantidade de um item existente
atualizar_item:
    # lê código
    li      $v0, 4
    la      $a0, msg_codigo
    syscall
    li      $v0, 5
    syscall
    move    $t1, $v0

    # lê nova quantidade
    li      $v0, 4
    la      $a0, msg_qtd
    syscall
    li      $v0, 5
    syscall
    move    $t2, $v0

    # busca e atualiza
    move    $t3, $s0
att_loop:
    beq     $t3, $zero, att_nao
    lw      $t4, 0($t3)
    beq     $t1, $t4, att_ok
    lw      $t3, 8($t3)
    j       att_loop

att_ok:
    sw      $t2, 4($t3)
    li      $v0, 4
    la      $a0, msg_atualizado
    syscall
    j       menu_loop

att_nao:
    li      $v0, 4
    la      $a0, msg_nao_encontrado
    syscall
    j       menu_loop

# imprimir_estoque
# - Percorre a lista e imprime código e quantidade de cada item
imprimir_estoque:
    beq     $s0, $zero, est_vazio
    move    $t1, $s0

imp_loop:
    li      $v0, 4
    la      $a0, sep
    syscall

    li      $v0, 4
    la      $a0, msg_codigo_str
    syscall
    lw      $t2, 0($t1)
    li      $v0, 1
    move    $a0, $t2
    syscall

    li      $v0, 4
    la      $a0, msg_qtd_str
    syscall
    lw      $t3, 4($t1)
    li      $v0, 1
    move    $a0, $t3
    syscall

    lw      $t1, 8($t1)
    bne     $t1, $zero, imp_loop
    j       menu_loop

est_vazio:
    li      $v0, 4
    la      $a0, msg_vazio
    syscall
    j       menu_loop

# sair
# - Finaliza execução
sair:
    li      $v0, 10
    syscall
