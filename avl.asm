%include "io.inc"

CEXTERN malloc
CEXTERN free

section .bss
op resd 1
key resd 1
val resd 1
root resd 1

section .text
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
get_int:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    mov ebx, dword[ebp + 8]; &x
    
    mov dword[esp + 4], ebx
    mov dword[esp], .rd
    call scanf
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
 
section .rodata
    .rd db "%d", 0
    
    
get_char:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    mov ebx, dword[ebp + 8]; &c
    
    mov dword[esp + 4], ebx
    mov dword[esp], .rc
    call scanf
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
 
section .rodata
    .rc db "%c", 0
       
print_int:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    mov ebx, dword[ebp + 8]; x
    
    mov dword[esp + 4], ebx
    mov dword[esp], .wd
    call printf
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

section .rodata
    .wd db "%d ", 0
    
print_endl:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    mov dword[esp], .endl
    call printf
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

section .rodata
    .endl db 10, 0
   
new_node:
    push ebp
    mov ebp, esp
    push ebx
    
    ;dword[ebp + 8] - key
    ;dword[ebp + 12] - data
    
    sub esp, 20
    
    mov dword[esp], 20
    call malloc
    ;eax - v0
    
    mov ebx, dword[ebp + 8]; key
    mov dword[eax], ebx; v->key = key
    
    mov ebx, dword[ebp + 12]; data
    mov dword[eax + 4], ebx; v->data = data
    
    mov dword[eax + 8], 0; v->left = null
    mov dword[eax + 12], 0; v->right = null
    mov dword[eax + 16], 1; v->h = 1
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
    
free_node:
    push ebp
    mov ebp, esp
    push ebx
    
    ;dword[ebp + 8] - v
    
    sub esp, 20
    
    cmp dword[ebp + 8], 0; if (v == NULL) return;
    je .exit
    
    mov ebx, dword[ebp + 8]; v
    mov dword[esp], ebx
    call free
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
    
is_leaf:
    push ebp
    mov ebp, esp
    push ebx
    
    ;dword[ebp + 8] - v
    
    mov eax, 0; ans = 0
    
    cmp dword[ebp + 8], 0; if (v == null) return 0;
    je .exit
    
    mov ebx, dword[ebp + 8];v
    
    cmp dword[ebx + 8], 0
    jne .exit; if (v->left != null) return 0;
    
    cmp dword[ebx + 12], 0
    jne .exit; if (v->right != null) return 0;
    
    mov eax, 1; ans = 1
    
    .exit:
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
    
get_h:
    push ebp
    mov ebp, esp
    push ebx
    
    ;dword[ebp + 8] - v
    
    mov eax, 0; h = 0
    
    cmp dword[ebp + 8], 0; if (v == null) return 0;
    je .exit
    
    mov ebx, dword[ebp + 8];v
    mov eax, dword[ebx + 16]; v->h
    
    .exit:
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
update:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    ;dword[ebp + 8] - v
    
    mov eax, 0
    
    cmp dword[ebp + 8], 0; if (v == null) return 0;
    je .exit
    
    mov ecx, dword[ebp + 8];v
    mov ecx, dword[ecx + 8]; v->left
    
    mov dword[esp], ecx
    call get_h
    
    mov ebx, eax; save v->left->h
    
    mov ecx, dword[ebp + 8];v
    mov ecx, dword[ecx + 12]; v->right
    
    mov dword[esp], ecx 
    call get_h
    
    mov edx, eax; v->right->h
    cmp ebx, edx
    jnl .skip
         mov ebx, edx
    .skip:
    inc ebx
    mov eax, dword[ebp + 8]; v
    mov dword[eax + 16], ebx; v->h = max(h[L], h[R]) + 1
    mov eax, dword[ebp + 8]; return v
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

    
get_diff:
    push ebp
    mov ebp, esp
    push ebx
    
    ;dword[ebp + 8] - v
    
    mov eax, 0; diff = 0
    
    cmp dword[ebp + 8], 0; if (v == null) return 0;
    je .exit
    
    mov ecx, dword[ebp + 8];v
    
    push dword[ecx + 8]; v->left
    call get_h
    pop edx
    
    mov ebx, eax; save v->left->h
    
    mov ecx, dword[ebp + 8];v
    
    push dword[ecx + 12]; v->right
    call get_h
    pop edx
    
    mov edx, eax; v->right->h
    sub ebx, edx; diff
    mov eax, ebx
        
    .exit:
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret    

    
add_node:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    ;dword[ebp + 8] - v
    ;dword[ebp + 12] - key
    ;dword[ebp + 16] - data
    
    cmp dword[ebp + 8], 0   
    jne .skip1
        ;if (v == null)
        mov ebx, dword[ebp + 16]; data
        mov dword[esp + 4], ebx
        
        mov ebx, dword[ebp + 12]; key
        mov dword[esp], ebx
        
        call new_node; return new_node
        jmp .exit
    
    .skip1:
    mov ebx, dword[ebp + 8]; v
    mov ebx, dword[ebx]; v->key
    cmp ebx, dword[ebp + 12]
    jl .R
        cmp ebx, dword[ebp + 12]
        jne .L
            ;if (v->key == key)
            ;   v->data = data
            mov ebx, dword[ebp + 8]; v
            mov ecx, dword[ebp + 16]; data
            mov dword[ebx + 4], ecx; v->data = data
            
            mov eax, dword[ebp + 8]; return v
            
            jmp .exit
        .L:
        ;if (v->key > key)
        ;   v->left = add_node(v->left, key, data)
        
        mov ebx, dword[ebp + 8]; v
        mov ebx, dword[ebx + 8]; v->left
        
        mov ecx, dword[ebp + 16]; data
        mov dword[esp + 8], ecx
        
        mov ecx, dword[ebp + 12]; key
        mov dword[esp + 4], ecx
        
        mov dword[esp], ebx; v->left
        
        call add_node
        
        mov ebx, dword[ebp + 8]; v
        mov dword[ebx + 8], eax; v->left = add_node(v->left, key, data);
        
        mov eax, dword[ebp + 8]; v
        mov dword[esp], eax
        call update
        
        mov eax, dword[ebp + 8]; return v;
        jmp .exit
    
    .R:
        ;if (v->key < key)
        ;   v->right = add_node(v->right, key, data)
        mov ebx, dword[ebp + 8]; v
        mov ebx, dword[ebx + 12]; v->right
        
        mov ecx, dword[ebp + 16]; data
        mov dword[esp + 8], ecx
        
        mov ecx, dword[ebp + 12]; key
        mov dword[esp + 4], ecx
        
        mov dword[esp], ebx; v->right
        
        call add_node
        
        
        mov ebx, dword[ebp + 8]; v
        mov dword[ebx + 12], eax; v->right = add_node(v->right, key, data);
        
        mov eax, dword[ebp + 8]; v
        mov dword[esp], eax
        call update
        
        mov eax, dword[ebp + 8]; return v;
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

find_max:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    cmp dword[ebp + 8], 0
    je .exit
    
    mov eax, dword[ebp + 8]; v
    mov eax, dword[eax + 12]; v->right
    cmp eax, 0
    jne .rec
        ;if (v->right == NULL)
        ;   return v
        mov eax, dword[ebp + 8]
        jmp .exit
    .rec:
    mov dword[esp], eax
    call find_max
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

del_max:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    cmp dword[ebp + 8], 0
    je .exit
    
    mov eax, dword[ebp + 8]; v
    mov eax, dword[eax + 12]; v->right
    cmp eax, 0
    jne .rec
        ;if (v->right == NULL)
        ;   free(v)
        ;   return v->left
        mov eax, dword[ebp + 8]; v
        mov ebx, dword[eax + 8]; v->left
        mov dword[esp], eax; free(v)
        call free_node
        mov eax, ebx; return v->left
        jmp .exit
    .rec:
    mov dword[esp], eax
    call del_max
    mov ebx, dword[ebp + 8]; v
    mov dword[ebx + 12], eax; v->right = del_max(v->right)
    mov eax, dword[ebp + 8]
    
    mov dword[esp], eax
    call update
    
    mov eax, dword[ebp + 8]; return v;
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret

del_node:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    mov eax, 0
    cmp dword[ebp + 8], 0; if (v == null) return;
    je .exit
    
    mov eax, dword[ebp + 8];v
    mov eax, dword[eax]; v->key
    cmp eax, dword[ebp + 12]
    jl .R
        cmp eax, dword[ebp + 12]
        jne .L
            ;if (v->key == key)
            ; DEL :)
            mov eax, dword[ebp + 8];v
            mov dword[esp], eax
            call is_leaf
            
            cmp eax, 0
            je .not_leaf
                ;if (is_leaf(v))
                ;   free(v)
                ;   return NULL
                mov eax, dword[ebp + 8]; v
                mov dword[esp], eax
                call free_node
                mov dword[ebp + 8], 0
                mov eax, 0; return NULL
                jmp .exit
            .not_leaf:
            mov eax, dword[ebp + 8]; v
            mov eax, dword[eax + 8]; v->left
            
            cmp eax, 0
            je .no_left
                ;if (v->left)
                mov eax, dword[ebp + 8]; v
                mov eax, dword[eax + 12]; v->right
                cmp eax, 0
                je .only_left
                    ;if (v->left && v->right)
                    ; DIFFICULT !
                    mov eax, dword[ebp + 8]; v
                    mov eax, dword[eax + 8]; v->left
                    mov dword[esp], eax
                    call find_max
                    
                    mov ebx, dword[eax]; v_max->key
                    mov ecx, dword[ebp + 8];v
                    mov dword[ecx], ebx; v->key = v_max->key
                    
                    mov ebx, dword[eax + 4]; v_max->data
                    mov ecx, dword[ebp + 8];v
                    mov dword[ecx + 4], ebx; v->data = v_max->data
                    
                    mov eax, dword[ebp + 8]; v
                    mov eax, dword[eax + 8]; v->left
                    mov dword[esp], eax
                    call del_max
                    
                    mov ebx, dword[ebp + 8]; v
                    mov dword[ebx + 8], eax; v->left = del_max(v->left)
                    
                    mov eax, dword[ebp + 8]
                    mov dword[esp], eax
                    call update
                    
                    mov eax, dword[ebp + 8];return v
                    
                    jmp .exit
                .only_left:
                ;free(v)
                ;return v->left
                mov ebx, dword[ebp + 8]; v
                mov ebx, dword[ebx + 8]; v->left
                mov eax, dword[ebp + 8]; v
                mov dword[esp], eax
                call free_node
                
                mov eax, ebx; return v->left
                jmp .exit
            .no_left:
            ;free(v)
            ;return v->right
            
            
            mov ebx, dword[ebp + 8]; v
            mov ebx, dword[ebx + 12]; v->right
            mov eax, dword[ebp + 8]; v
            mov dword[esp], eax
            call free_node
                
            mov eax, ebx; return v->right
            jmp .exit
        .L:
        ;if (v->key > key)
        ;   v->left = del_node(v->left, key)
        mov eax, dword[ebp + 8]; v
        mov eax, dword[eax + 8]; v->left
        
        mov ebx, dword[ebp + 12]; key
        mov dword[esp + 4], ebx; key
        mov dword[esp], eax; v->left
        
        call del_node
        mov ebx, dword[ebp + 8]; v
        mov dword[ebx + 8], eax; v->left = del_node(v->left, key)
        
        mov eax, dword[ebp + 8];v
        mov dword[esp], eax
        call update
        
        mov eax, dword[ebp + 8];return v
        
        jmp .exit
    .R:
        ;if (v->key < key)
        ;   v = del_node(v->right, key)
        mov eax, dword[ebp + 8]; v
        mov eax, dword[eax + 12]; v->right
        
        mov ebx, dword[ebp + 12]; key
        mov dword[esp + 4], ebx; key
        mov dword[esp], eax; v->right
        
        call del_node
        mov ebx, dword[ebp + 8]; v
        mov dword[ebx + 12], eax; v->right = del_node(v->right, key)
        
        mov eax, dword[ebp + 8];v
        mov dword[esp], eax
        call update
        
        mov eax, dword[ebp + 8];return v
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
    
find_node:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    ; dword[ebp + 8] - v
    ; dword[ebp + 12] - key
     
    cmp dword[ebp + 8], 0
    je .exit; if (v == null) return;
    
    mov eax, dword[ebp + 8]; v
    mov eax, dword[eax]; v->key
    cmp eax, dword[ebp + 12]; key
    jl .R
        cmp eax, dword[ebp + 12]; key
        jne .L
            ;if (v->key == key)
            ;   print_node(v)
            
            mov eax, dword[ebp + 8]; v
            mov eax, dword[eax]; v->key
            
            mov dword[esp], eax
            call print_int
            
            mov eax, dword[ebp + 8]; v
            mov eax, dword[eax + 4]; v->data
            
            mov dword[esp], eax
            call print_int
            
            call print_endl
            
            jmp .exit
        .L:
        ;if (v->key > key)
        ;   find_node(v->left, key, data)
        mov eax, dword[ebp + 8]; v
        mov eax, dword[eax + 8]; v->left
            
        mov ebx, dword[ebp + 12]; key
        mov dword[esp + 4], ebx
            
        mov dword[esp], eax
        call find_node
        jmp .exit
    .R:
        ;if (v->key < key)
        ;   find_node(v->right, key, data)
        mov eax, dword[ebp + 8]; v
        mov eax, dword[eax + 12]; v->right
           
        mov ebx, dword[ebp + 12]; key
        mov dword[esp + 4], ebx
           
        mov dword[esp], eax
        call find_node
          
    .exit:
    
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
    
    
print_tree:
    push ebp
    mov ebp, esp
    push ebx
    
    sub esp, 20
    
    cmp dword[ebp + 8], 0; if (v == null) return
    je .exit
    
    mov ebx, dword[ebp + 8]; v
    mov ebx, dword[ebx + 8]; v->left
    
    mov dword[esp], ebx
    call print_tree
    
    mov ebx, dword[ebp + 8]; v
    mov ebx, dword[ebx]; v->key
    
    mov dword[esp], ebx
    call print_int
    
    
    ;mov ebx, dword[ebp + 8]; v
    ;PRINT_STRING "("
    ;PRINT_DEC 4, [ebx + 16]
    ;PRINT_STRING ") "
    
    mov ebx, dword[ebp + 8]; v
    mov ebx, dword[ebx + 12]; v->right
    
    mov dword[esp], ebx
    call print_tree
    
    .exit:
    add esp, 20
    
    pop ebx
    mov esp, ebp
    pop ebp
    ret
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp
    sub esp, 24
    
    .loop:
        mov dword[esp], op
        call get_char
        
        cmp eax, 0
        je .break

        cmp dword[op], "A"
        jne .skip1
            ;if (op == 'A')
            mov dword[esp], key
            call get_int
            
            mov dword[esp], val
            call get_int
            
            mov eax, dword[val]
            mov dword[esp + 8], eax
            mov eax, dword[key]
            mov dword[esp + 4], eax
            mov eax, dword[root]
            mov dword[esp], eax
            call add_node
            
            mov dword[root], eax
            
            jmp .end
        .skip1:
        
        cmp dword[op], "D"
        jne .skip2
            ;if (op == 'D')
            mov dword[esp], key
            call get_int
            
            mov eax, dword[key]
            mov dword[esp + 4], eax
            mov eax, dword[root]
            mov dword[esp], eax
            call del_node
            
            mov dword[root], eax
            
            jmp .end
        .skip2:   
        
        cmp dword[op], "S"
        jne .skip3
            ;if (op == 'S')
            mov dword[esp], key
            call get_int
            
            mov eax, dword[key]
            mov dword[esp + 4], eax
            mov eax, dword[root]
            mov dword[esp], eax
            call find_node
            
            jmp .end
             
        .skip3:     
        cmp dword[op], "F"
        jne .end
            ;if (op == 'F')
            jmp .break
        .end:
        
        ;PRINT_STRING "tree:"
        ;NEWLINE
        ;push dword[root]
        ;call print_tree
        ;pop edx
        ;NEWLINE
        ;NEWLINE
       
        
        ;read "\n"
        mov dword[esp], op
        call get_char
        
        jmp .loop
    
    .break:
    
    add esp, 24
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret