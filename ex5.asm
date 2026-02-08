# ex3.asm
# Autenticacao por senha: senha fixa no registrador $s0.
# A comparacao deve ser feita bit-a-bit (usamos XOR e verificamos se resultado == 0).
# Marcadores: [Q3.SenhaDefinida], [Q3.Leitura], [Q3.ComparaBitwise], [Q3.SairOpcional]

.data
msg_intro: .asciiz "=== Autenticacao por Senha (XOR bit a bit) ===\n"
msg_prompt: .asciiz "Digite a senha numerica (ou -1 para sair): "
msg_ok: .asciiz "Senha CORRETA.\n"
msg_bad: .asciiz "Senha INCORRETA.\n"
msg_bye: .asciiz "Encerrando...\n"

.text
main:
    # [Q3.SenhaDefinida] definir senha embutida no codigo
    li $s0, 12345        # senha correta (altere se quiser)

    # imprime introducao
    li $v0, 4
    la $a0, msg_intro
    syscall

loop_tentativas:
    # [Q3.Leitura] solicita e le a tentativa do usuario
    li $v0, 4
    la $a0, msg_prompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0        # tentativa em $t0

    # [Q3.SairOpcional] se usuario digitar -1 => encerra
    li $t1, -1
    beq $t0, $t1, sair

    # [Q3.ComparaBitwise] comparar via XOR bit-a-bit
    xor $t2, $t0, $s0    # se iguais -> xor=0
    beq $t2, $zero, senha_correta

    # senha incorreta
    li $v0, 4
    la $a0, msg_bad
    syscall
    j loop_tentativas

senha_correta:
    li $v0, 4
    la $a0, msg_ok
    syscall
    j loop_tentativas    # permite novas tentativas até -1

sair:
    li $v0, 4
    la $a0, msg_bye
    syscall
    li $v0, 10
    syscall
