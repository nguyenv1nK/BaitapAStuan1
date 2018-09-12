.model small
.stack 100
.data
    inputA db 'Nhap so A = $'
    inputB db 'Nhap so B = $'
    outputResult db 'Tong A + B = $' 
    CLRF db 13, 10, '$'
.code
    main proc
    mov ax, @data
    mov ds, ax
               
    mov ah, 9         ; hien thi "Nhap so A = "
    lea dx, inputA
    int 21h
     
    call inputDec     ; goi CTC nhap so thu nhat he so 10
    push ax           ; luu ax da nhap vao stack
    xor ax,ax         ; gan ax bang 0  
    call nextLine     ; xuong dong
     
    mov ah, 9         ; hien thi "Nhap so B = " 
    lea dx, inputB
    int 21h
     
    call inputDec     ;goi CTC nhap so thu 2 he so 10
    mov bx, ax
    call nextLine              
     
    pop ax            ; goi ax tu Stack ra
    call sum          ; goi ham tinh tong 2 so (trong ax va bx)
    push ax           ; luu ax lai
                       
    mov ah, 9         ; hien thi KQ
    lea dx, outputResult
    int 21h
     
    pop ax
    call outputDec    ; goi CTC hien thi KQ
     
    mov ah, 4ch
    int 21h
     
     
    main endp
     
    sum proc          ; CTC con tinh tong 2 so
        add ax, bx
        ret
    sum endp 
                                                            
    nextLine proc     ; CTC xuong dong
        mov ah, 9
        lea dx, CLRF
        int 21h
        ret
    nextLine endp
     
inputDec proc      ;Nhap vao 1 so he so 10 va luu ket qua vao Ax
       
        push bx
        push cx
        push dx 
        
        batDau:
            mov ah, 2
            xor bx, bx
            xor cx, cx
            mov ah, 1
            int 21h
            cmp al, '-'       ; Kiem tra am duong
            je dauTru
            cmp al, '+'
            je dauCong
            jmp tiepTuc
            
            dauTru:
                mov cx, 1
            
            dauCong:
                int 21h
            
            tiepTuc:
                cmp al, '0'
                jnge nhapSai    ; khong lop hon hoac bang
                cmp al, '9'
                jnle nhapSai    ; Khong nho hon hoac bang 
                and ax, 000fh       ; doi thanh chu so
                push ax             ; cat vao ngan xep
                mov ax, 10
                
                mul bx              ; ax = tong*10
                mov bx, ax          
                pop ax
                add bx, ax          ; tong = tong*10 + so
                mov ah, 1
                int 21h
                cmp al, 13          ; da enter chua?
                jne tiepTuc         ; nhap tiep
                
                mov ax, bx          ; chuyen KQ ra ax
                or cx, cx           ; co phai so am khong
                je ra
                neg ax              ; neu la so am thi doi ax ra so am
                
            ra:
                pop dx
                pop cx
                pop bx  
                
                ret
                
            nhapSai:
                mov ah, 2
                mov dl, 0dh
                int 21h
                mov dl, 0ah
                int 21
                jmp batDau
                
                
inputDec endp  





outputDec proc
        push bx
        push cx
        push dx
        
        cmp ax, 0   ;   neu ax > 0 ta doi ra day
        jge doiRaDay
        push ax
        mov dl, '-'
        mov ah, 2
        int 21h
        pop ax
        neg ax  ; ax = -ax
        
        doiRaDay:
            xor cx, cx  ; gan cx = 0
            mov bx, 10  ; so chia la 10
            chia:
                xor dx, dx  ; gan dx = 0
                div bx      ; ax = ax / bx; dx = ax % bx
                push dx
                inc cx
                cmp ax, 0   ; kiem tra xem thuong bang khong chua?
                jne chia    ; neu khong bang thi lai chia
                mov ah, 2
            hien:
                pop dx
                or dl, 30h
                int 21h
                loop hien
                
                pop dx
                pop cx
                pop bx
               
ret
        
outputDec endp
end main
        
        
        