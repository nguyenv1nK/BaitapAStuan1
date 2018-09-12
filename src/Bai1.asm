.model small
.stack 100
.data                             
    inputA db 'Nhap so nhi phan A (16bit) = $'
    inputB db 'Nhap so nhi phan B (16bit) = $'
    outputResult db 'Tong 2 so A + B = $'
    CLRF db 13,10, '$' 
    num1 dw ?                  
.code

main proc         

        MOV AX, @DATA
        MOV DS, AX      
    
        MOV AH, 9         ;Hien thi "Nhap so A ="
        LEA DX, InputA  
        INT 21H 
    
            
        call input        ;Nhap so A
        call nextLine
    
       
        call inputData   ;Hien thi so vua nhap
        MOV num1, BX     ;Chuyen bx ra num1      
        call nextLine 
        
      
        MOV AH, 9        ;Hien thi "Nhap so B = "
        LEA DX, inputB  
        INT 21H 
        
        call input       ;Nhap so B
        call nextLine 
        
        
        call inputData    ;Hien thi so vua nhap
        call nextLine  
        
         
        MOV AH,9           ;Hien thi "Tong 2 so A+B"
        LEA DX,outputResult
        INT 21H 
        
        
        XOR DX, DX         ;Tinh tong 2 so
        MOV DX, num1
        ADD BX, DX
        MOV CX, 16
        MOV AH,2 
        
        
        
        output:                ;In ra ket qua
        XOR DL, DL   
        ROL BX, 1 
        ADC DL, 30H 
        INT 21H 
        LOOP output    
           
    main endp 



nextLine proc     ; CTC xuong dong
        mov ah, 9
        lea dx, CLRF
        int 21h
        ret
    nextLine endp  



input proc        ;CTC nhap vao so nhi phan roi lua vao BX
    
        MOV CX,16 
        XOR BX,BX
        MOV AH,1  
        nhap:
        INT 21H 
        AND AL, 0FH ; chuyen ma asc2 ra so    
        SHL BX,1
        OR BL, AL
        LOOP nhap
    
        ret
    input endp


inputData proc
    
        MOV CX, 16
        MOV AH,2
        hien:
        XOR DL, DL   
        ROL BX, 1 
        ADC DL, 30H 
        INT 21H 
        LOOP hien  
        ret
    inputData endp


end main