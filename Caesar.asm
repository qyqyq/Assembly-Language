DATA    SEGMENT    

;OUTPUT & INPUT OF STRING    
OUTSTR  DB  'PLEASE INPUT STRING:',0AH,0DH,'$'
BUFFER  DB  50
        DB  0
        DB  50 DUP(0) 
        
;OUTPUT & INPUT OF KEY
OUTKEY  DB  0AH,0DH,'PLEASE INPUT KEY:',0AH,0DH,'$'
INKEY   DB  0   

;OUTPUT & INPUT OF OPTION  
OUTOPT  DB  0AH,0DH,'PLEASE CHOOSE FUNCTION:',0AH,0DH
        DB  'A: ENCRYPTION / B: DECRYPTION',0AH,0DH,'$'
INOPT   DB  0

ENOUT   DB  0AH,0DH,'THE STRING AFTER ENCRYPYTION IS:',0AH,0DH,'$'
DEOUT   DB  0AH,0DH,'THE STRING AFTER DECRYPYTION IS:',0AH,0DH,'$'
                
DATA    ENDS  


CODE    SEGMENT
        ASSUME CS:CODE, DS:DATA

INTERFACE PROC
            
        ;PRINT GUIDE OF STRING        
        LEA DX,OUTSTR
        MOV AH,09H
        INT 21H 
        ;INPUT STRING INTO BUFFER        
        LEA DX,BUFFER
        MOV AH,0AH 
        INT 21H  
        ;DEAL WITH INPUT STRING
        MOV AL,BUFFER+1
        ADD AL,2
        MOV AH,0
        MOV SI,AX
        MOV BUFFER[SI],0DH
        MOV BUFFER[SI+1],0AH
        MOV BUFFER[SI+2],'$'
        
        ;PRINT GUIDE OF KEY        
        LEA DX,OUTKEY
        MOV AH,09H
        INT 21H
        ;INPUT THE KEY INTO AL->INKEY         
        MOV AH,01H
        INT 21H   
        MOV INKEY,AL
        SUB INKEY,'0'

        ;PRINT GUIDE OF FUNCTION OPTION        
        LEA DX,OUTOPT
        MOV AH,09H
        INT 21H 
        ;INPUT THE OPTION CODE INTO AL->INOPT        
        MOV AH,01H
        INT 21H
        MOV INOPT,AL 
                
        RET
        
INTERFACE ENDP

OPERATION PROC 
        
        PUSH CX
          
        MOV CL,[BUFFER+1]
        MOV CH,0 
                              
        LEA SI,BUFFER+2
        MOV AL,INKEY 
           
        CMP INOPT,'A'
        JZ  ENCRY  
              
        CMP INOPT,'B'
        JZ  DECRY
        
        JMP RETURN
        
    ENCRY: 
        ADD [SI],AL
        CMP [SI],'Z'
        JNA NEXTENCRY
        SUB [SI],1AH
    NEXTENCRY:
        INC SI
        LOOP ENCRY
        
        LEA DX,ENOUT
        MOV AH,09H
        INT 21H
        
        JMP RETURN
        
    ;;;;;;;;;;;;;;;;;;;;;;
    
    DECRY:  
        SUB [SI],AL
        CMP [SI],'A'
        JNB NEXTDECRY
        ADD [SI],1AH
    NEXTDECRY:
        INC SI
        LOOP DECRY
        
        LEA DX,ENOUT
        MOV AH,09H
        INT 21H
        
        JMP RETURN
        
    RETURN:  
        POP CX          
        RET
        
OPERATION ENDP    
    
        
OUTCOME PROC
    
    LEA DX,BUFFER+2
    MOV AH,09H
    INT 21H         
          
    RET  
    
OUTCOME ENDP
    
    
START:  MOV AX,DATA
        MOV DS,AX  
        
        MOV CX,2
    MAIN:
        CALL INTERFACE
        CALL OPERATION  
        CALL OUTCOME
        
        LOOP MAIN
    
CODE    ENDS
        END     START