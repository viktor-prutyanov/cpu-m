.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

;timer configurartion
    movd    $a  00800000
    stsprd  $a  %tcmp
    clr     $a
    stsprd  $a  %tcnt
    movll   $a  1
    stsprd  $a  %tctr
    movll   $a  4
    stsprd  $a  %ienb
    clr     $a

    call _setup
    
    ;infinity loop
:main_loop
    jmp     _main_loop

;timer comparsion interrupt handler
:i_timer_comp
    movd    $a  00000F00
    movd    $b  00000F08
    call    _clear_memory

    ;load current head
    ldl     $g  $h

    ;load current direction
    movd    $c  000007FF
    ldl     $b  $c 

    ;input player's direction
    clr     $d
    movll   $d  0F
    in      $a
    and     $a  $a  $d

    ;determine new direction
    clr     $c
    clr     $d
    clr     $f
    movll   $f  01
    xor     $f  $f  $b
    jez     _go_right
    movll   $f  02
    xor     $f  $f  $b
    jez     _go_down
    movll   $f  04
    xor     $f  $f  $b
    jez     _go_up
    movll   $f  08
    xor     $f  $f  $b
    jez     _go_left
    movll   $a  E1
    end

    ;calculate new position
:go    
    movll   $f  01
    xor     $f  $f  $a
    jez     _right
    movll   $f  02
    xor     $f  $f  $a
    jez     _down
    movll   $f  04
    xor     $f  $f  $a
    jez     _up
    movll   $f  08
    xor     $f  $f  $a
    jez     _left
    movll   $a  E2
    end

:save_pos
    ;store new direction
    movd    $c  000007FF
    stl     $a  $c
   
    ;check self collision
    movl    $c  0800
:check_self_next
    ldl     $b  $c
    xor     $f  $g  $b
    jez     _new_game
    addb    $c  1
    xor     $f  $c  $e
    jnz     _check_self_next

    ;check food collision
    movd    $c  000007FE
    ldl     $a  $c
    xor     $f  $g  $a
    jnz     _skip0
    ;increase score
    clr     $c
    movl    $c  07FC
    ldl     $a  $c
    addb    $a  1
    stl     $a  $c
    out     $a
    ;set grow bit
    movl    $c  07FD
    clr     $a
    movll   $a  1
    stl     $a  $c
    ;generate new food
:generate
    in      $d
    shr     $d  10
    movl    $c  0800
:check_next
    ldl     $b  $c
    xor     $f  $d  $b
    jez     _generate
    addb    $c  1
    xor     $f  $c  $e
    jnz     _check_next
    movl    $c  07FE
    stl     $d  $c
:skip0

    ;move head
    mov     $f  $e
    subb    $f  1
    xor     $f  $f  $h
    jnz     _skip1
    ;check grow bit
    movl    $h  07FF
    clr     $c
    movl    $c  07FD
    ldl     $f  $c
    jez     _skip2
    ;snake grows if grow bit is set
    mov     $h  $e
    subb    $h  1
    addb    $e  1
    ;reset grow bit
    clr     $f
    stl     $f  $c
:skip2
:skip1    
    addb    $h  1
    stl     $g  $h  

    ;food rendering
    clr     $c
    movl    $c  07FE
    ldl     $g  $c
    call    _get_addr
    shl     $d  8
    stl     $d  $a

    ;snake rendering
    clr     $c
    movl    $c  0800
:draw_next
    ldl     $g  $c
    call    _get_addr
    ldl     $b  $a 
    or      $d  $d  $b
    stl     $d  $a
    addb    $c  1
    xor     $f  $c  $e
    jnz     _draw_next

    clr     $d
    stsprd  $d  %tcnt

    iret

;IN: g(position)
;OUT: a(addr), d(word)
:get_addr 
    ;word calculation
    clr     $a
    movll   $a  FF
    and     $a  $a  $g
    clr     $d
    movll   $d  80
    sh      $d  $d  $a
    ;address calculation
    mov     $a  $g
    shr     $a  8
    movlh   $a  0F
    ret

:go_right
    movll   $d  04
    xor     $f  $a  $d
    jez     _go
    movll   $d  02
    xor     $f  $a  $d
    jez     _go
    movll   $a  01
    jmp     _go

:go_left
    movll   $d  04
    xor     $f  $a  $d
    jez     _go
    movll   $d  02
    xor     $f  $a  $d
    jez     _go
    movll   $a  08
    jmp     _go

:go_up
    movll   $d  08
    xor     $f  $a  $d
    jez     _go
    movll   $d  01
    xor     $f  $a  $d
    jez     _go
    movll   $a  04
    jmp     _go

:go_down
    movll   $d  08
    xor     $f  $a  $d
    jez     _go
    movll   $d  01
    xor     $f  $a  $d
    jez     _go
    movll   $a  02
    jmp     _go

:right
    movl    $c  0007
    xor     $f  $g  $c
    movl    $c  00FF
    and     $f  $f  $c
    jez     _right_ovf
    addb    $g  1
    jmp     _save_pos
:right_ovf
    movll   $g  00
    jmp     _save_pos

:left
    movl    $c  00FF
    and     $f  $g  $c
    jez     _left_ovf
    subb    $g  1
    jmp     _save_pos
:left_ovf
    movll   $g  07
    jmp     _save_pos

:up
    movl    $c  FF00
    and     $f  $g  $c
    jez     _up_ovf
    movl    $c  0100
    sub     $g  $g  $c
    jmp     _save_pos   
:up_ovf
    movlh   $g  07
    jmp     _save_pos

:down
    movl    $c  0700
    xor     $f  $g  $c
    movl    $c  FF00
    and     $f  $f  $c
    jez     _down_ovf
    movl    $c  0100
    add     $g  $g  $c
    jmp     _save_pos   
:down_ovf
    movlh   $g  00
    jmp     _save_pos  

:setup
    ;initial score
    movd    $a  000007FC
    clr     $b
    stl     $b  $a
    ;initial grow bit & initial fail bit
    movd    $a  000007FD
    stl     $b  $a
    ;initial food
    movd    $a  000007FE
    movl    $b  0606
    stl     $b  $a 
    ;initial stop address
    movd    $e  00000803
    ;initial head
    mov     $h  $e
    subb    $h  1
    ;initial direction
    movll   $a  FF
    movll   $b  02
    stl     $b  $a
    ;initial snake
    movl    $a  0800
    movl    $b  0103
    stl     $b  $a
    addb    $a  1
    movl    $b  0104
    stl     $b  $a
    addb    $a  1
    movl    $b  0105
    stl     $b  $a
    ret

:clear_memory
    movd    $a  00000F00
    movd    $b  00000F08
    clr     $c
:clear_next
    stl     $c  $a
    addb    $a  1
    xor     $f  $a  $b
    jnz     _clear_next
    clr     $a
    clr     $b 
    clr     $c
    ret

:new_game
    clr     $a
    out     $a  
    ;wipe snake and setup again
    movd    $a  00000800
    movd    $b  00000840
    call    _clear_memory
    call    _setup
    jmp     _i_timer_comp
