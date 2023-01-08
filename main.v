`timescale 1ns / 1ps
module main(
    input [15:0]ss,
    input [3:0]BTN,
    input clk,
    output reg [7:0]ssd,
    output reg [15:0]LED,
    output reg [7:0]EN 
    );
 
reg [11:0]cuenta = 0;
reg [11:0]saldo = 2500;
reg [11:0]monto = 0; 
reg [4:0] i = 0;
reg [27:0] shift_register = 0;
reg [3:0] temp_ones = 0;
reg [3:0] temp_tens = 0;
reg [3:0] temp_hundreds = 0;
reg [3:0] temp_thounsands = 0;
reg [11:0]old_12_bit_value = 0;
reg [2:0]state = 0;
reg [7:0]unidades; 
reg [7:0]decenas; 
reg [7:0]centenas; 
reg [7:0]miles; 
reg [7:0] Er;
reg [7:0] o;
reg [3:0]unidadesDisplay;
reg [3:0]decenasDisplay;    
reg [3:0]centenasDisplay;
reg [3:0]milesDisplay;  
reg [3:0]ErDisplay;
reg [3:0]oDisplay;  
reg [24:0]MUX;
reg [2:0]frecuencia_Mux;
reg [11:0] ssreg ;
localparam reg [11:0] limite = 12'd4095;

assign ss[11:0] = ssreg; 

always @ (posedge clk)
begin
                                                       //gfedcba
         unidades = (unidadesDisplay == 4'b0000 ) ? 7'b1000000: //0
                         (unidadesDisplay == 4'b0001 ) ? 7'b1111001: //1
                         (unidadesDisplay == 4'b0010 ) ? 7'b0100100: //2
                         (unidadesDisplay == 4'b0011 ) ? 7'b0110000: //3
                         (unidadesDisplay == 4'b0100 ) ? 7'b0011001: //4
                         (unidadesDisplay == 4'b0101 ) ? 7'b0010010: //5
                         (unidadesDisplay == 4'b0110 ) ? 7'b0000010: //6
                         (unidadesDisplay == 4'b0111 ) ? 7'b1111000: //7
                         (unidadesDisplay == 4'b1000 ) ? 7'b0000000: //8
                         (unidadesDisplay == 4'b1001 ) ? 7'b0011000: //9
                         (unidadesDisplay == 4'b1010 ) ? 7'b0111111: //-
                         7'b00000000;

        decenas =  (decenasDisplay == 4'b0000 ) ? 7'b1000000: //0
                         (decenasDisplay == 4'b0001 ) ? 7'b1111001: //1
                         (decenasDisplay == 4'b0010 ) ? 7'b0100100: //2
                         (decenasDisplay == 4'b0011 ) ? 7'b0110000: //3
                         (decenasDisplay == 4'b0100 ) ? 7'b0011001: //4
                         (decenasDisplay == 4'b0101 ) ? 7'b0010010: //5
                         (decenasDisplay == 4'b0110 ) ? 7'b0000010: //6
                         (decenasDisplay == 4'b0111 ) ? 7'b1111000: //7
                         (decenasDisplay == 4'b1000 ) ? 7'b0000000: //8
                         (decenasDisplay == 4'b1001 ) ? 7'b0011000: //9
                         (decenasDisplay == 4'b1010 ) ? 7'b0111111: //-
                         (decenasDisplay == 4'b1011 ) ? 7'b0101111: //r
                         7'b00000000;
                                                    //gfedcba
        centenas = (centenasDisplay == 4'b0000 ) ? 7'b1000000: //0
                         (centenasDisplay == 4'b0001 ) ? 7'b1111001: //1
                         (centenasDisplay == 4'b0010 ) ? 7'b0100100: //2
                         (centenasDisplay == 4'b0011 ) ? 7'b0110000: //3
                         (centenasDisplay == 4'b0100 ) ? 7'b0011001: //4
                         (centenasDisplay == 4'b0101 ) ? 7'b0010010: //5
                         (centenasDisplay == 4'b0110 ) ? 7'b0000010: //6
                         (centenasDisplay == 4'b0111 ) ? 7'b1111000: //7
                         (centenasDisplay == 4'b1000 ) ? 7'b0000000: //8
                         (centenasDisplay == 4'b1001 ) ? 7'b0011000: //9
                         (centenasDisplay == 4'b1010 ) ? 7'b0111111: //-
                         (centenasDisplay == 4'b1011 ) ? 7'b0100011: //o
                         7'b00000000;

         miles =  (milesDisplay == 4'b0000 ) ? 7'b1000000: //0
                         (milesDisplay == 4'b0001 ) ? 7'b1111001: //1
                         (milesDisplay == 4'b0010 ) ? 7'b0100100: //2
                         (milesDisplay == 4'b0011 ) ? 7'b0110000: //3
                         (milesDisplay == 4'b0100 ) ? 7'b0011001: //4
                         (milesDisplay == 4'b0101 ) ? 7'b0010010: //5
                         (milesDisplay == 4'b0110 ) ? 7'b0000010: //6
                         (milesDisplay == 4'b0111 ) ? 7'b1111000: //7
                         (milesDisplay == 4'b1000 ) ? 7'b0000000: //8
                         (milesDisplay == 4'b1001 ) ? 7'b0011000: //9
                         (milesDisplay == 4'b1010 ) ? 7'b0111111: //-
                         (milesDisplay == 4'b1011 ) ? 7'b0101111: //r
                         7'b00000000;
                                         //gfedcba
          Er = (ErDisplay == 4'b0001) ? 7'b0101111://r 
               (ErDisplay == 4'b0000 ) ? 7'b1000000: //0
                7'b00000000;
                                        //gfedcba
          o = (oDisplay == 4'b0001) ? 7'b0000110:  //E    
              (oDisplay == 4'b0000 ) ? 7'b1000000: //0  
              7'b00000000;           
                         
MUX <= MUX + 1; 
    if(MUX == 10000)
    begin
        MUX <= 0;
        frecuencia_Mux <= frecuencia_Mux + 1; 
    end
    
    if(frecuencia_Mux == 3'b001)
    begin
        ssd <= decenas;
        EN <= 8'b11111101;
    end
    
    else if(frecuencia_Mux == 3'b010)
    begin
        ssd <= unidades;
        EN <= 8'b11111110;
    end
    
    else if(frecuencia_Mux == 3'b011)
    begin
        ssd <= centenas;
        EN <= 8'b11111011;
    end
    
    else if(frecuencia_Mux == 3'b100)
    begin
        ssd <= miles;
        EN <= 8'b11110111;
        
    end
    else if(frecuencia_Mux == 3'b101)
    begin
        ssd <= Er;
        EN <= 8'b11101111;
    end
    else if(frecuencia_Mux == 3'b110)
    begin
        ssd <= o;
        EN <= 8'b11011111;
        frecuencia_Mux <= 0;
    end       
    
    cuenta = saldo + ssreg;  
    if (BTN[0])//Reset
    begin
         saldo <= 12'd2500;
         state <= 3'b000;
    end
      
    else if(state == 3'b000) //estado A
    begin
        milesDisplay = 4'b0000;
        centenasDisplay = 4'b0000;
        if (BTN[0])//Reset
        begin
             saldo <= 2500;
             state <= 3'b000;
        end 
        if ((ss == 16'b0000000000011111)&&(BTN[3])) //meter contrasena
        begin
            state = 3'b001;
        end
        else if ((ss != 16'b0000000000011111)&&(BTN[3])) //contrasena incorrecta
        begin
            state <= 3'b111;
            oDisplay = 4'b0001;//E
            ErDisplay = 4'b0001; //r
            milesDisplay = 4'b1011;//r
            decenasDisplay = 4'b1011;//o
            centenasDisplay = 4'b1011;//r
            unidadesDisplay = 4'b0001;//1
        end
    end    
    
    else if(state == 3'b001)//estado B
    begin
        if (BTN[0])//Reset
        begin
             oDisplay = 4'b0000;
             ErDisplay = 4'b0000; 
             milesDisplay = 4'b0000;
             decenasDisplay = 4'b0000;
             centenasDisplay = 4'b0000;
             unidadesDisplay = 4'b0000;
             saldo <= 12'd2500;
             state <= 3'b000;
        end
        oDisplay = 4'b0000;//E
        ErDisplay = 4'b0000; //r1
        if((ss[15:0] == 16'b0000000000000000)&&(BTN[1])) //retirar dinero
        begin
            state <= 3'b010;
        end
        
        if((ss[15:0] == 16'b0000000000000000)&&(BTN[2])) // depositar dinero
        begin
            state <= 3'b011;
        end
    end
    
    else if(state == 3'b010)//estado retirar dinero estado C
    begin
        if (BTN[0])//Reset
        begin
             oDisplay = 4'b0000;//E
             ErDisplay = 4'b0000; //r
             milesDisplay = 4'b0000;//r
             decenasDisplay = 4'b0000;//o
             centenasDisplay = 4'b0000;//r
             unidadesDisplay = 4'b0000;//1
             saldo <= 12'd2500;
             state <= 3'b000;
        end    
        if (BTN[3])
        begin
           if (ssreg <= saldo)//Si lo retirado no es mayor al saldo hacer la resta y proseguir al estado F
           begin
                    saldo = saldo - ssreg; 
                    state <= 3'b101;
           end
           if (ssreg > saldo)//Si lo retirado es mayor al saldo error
           begin
                    state <= 3'b100;
           end 
        end
    end
    
    else if(state == 3'b011)//estado depositar dinero
    begin
        if (BTN[0])//Reset
        begin
             oDisplay = 4'b0000;//E
             ErDisplay = 4'b0000; //r
             milesDisplay = 4'b0000;//r
             decenasDisplay = 4'b0000;//o
             centenasDisplay = 4'b0000;//r
             unidadesDisplay = 4'b0000;//1        
             saldo <= 12'd2500;
             state <= 3'b000;
        end   
        
            if((saldo + ssreg) > 4096 && BTN[3]==1) // si lo depositado mas el saldo no pasa de 4096 todo bien
            begin
                state <= 3'b100;
            end
            else if((saldo + ssreg) < 4096 && BTN[3]==1) // si lo depositado mas el saldo pasa de 4096 ERROR
            begin
                saldo = saldo + ssreg;
                state <= 3'b110;                 
            end  
    end
    
    else if(state == 3'b100)//estado error 2
    begin
        oDisplay = 4'b0001;//E
        ErDisplay = 4'b0001; //r
        milesDisplay = 4'b1011;//r
        decenasDisplay = 4'b1011;//o
        centenasDisplay = 4'b1011;//r
        unidadesDisplay = 4'b0011;
        if((ss == 16'b0000000000000000) && (BTN[3]))
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            milesDisplay = 4'b0000;//r
            decenasDisplay = 4'b0000;//o
            centenasDisplay = 4'b0000;//r
            unidadesDisplay = 4'b0000;//1        
            state <= 3'b001;
        end
        if (BTN[0])//Reset
        begin
             oDisplay = 4'b0000;//E
             ErDisplay = 4'b0000; //r
             milesDisplay = 4'b0000;//r
             decenasDisplay = 4'b0000;//o
             centenasDisplay = 4'b0000;//r
             unidadesDisplay = 4'b0000;//1        
             saldo <= 12'd2500;
             state <= 3'b000;
        end         
    end
    
    else if(state == 3'b101)//estado retiro confirmado
    begin
        if ((ss[15:0] == 16'b0000000000000000)&&(BTN[3]))
        begin
            state <= 3'b001;
        end
    end
    
    else if(state == 3'b110)//estado ingreso confirmado
    begin

        if ((ss == 16'b0000000000000000)&&(BTN[3]))
        begin
            state <= 3'b001;
        end    
    
    end   
     
    else if(state == 3'b111)//estado error 1 error de la contrasena incorrecta
    begin
        //LED = 16'b1111111100000000;
        oDisplay = 4'b0001;//E
        ErDisplay = 4'b0001; //r
        milesDisplay = 4'b1011;//r
        decenasDisplay = 4'b1011;//o
        centenasDisplay = 4'b1011;//r
        unidadesDisplay = 4'b0001;//1
        if (BTN[0])//Reset
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            milesDisplay = 4'b0000;//r
            decenasDisplay = 4'b0000;//o
            centenasDisplay = 4'b0000;//r
            unidadesDisplay = 4'b0000;//1        
            saldo <= 2500;
            state <= 3'b000;
        end    
        if (BTN[3])
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            milesDisplay = 4'b0000;//r
            decenasDisplay = 4'b0000;//o
            centenasDisplay = 4'b0000;//r
            unidadesDisplay = 4'b0000;//1
            state <= 3'b000;
        end
    end    
    
    case(state)//salidas
        3'b000://A
        begin//meter contrasena
       oDisplay = 4'b0000;//E
       ErDisplay = 4'b0000; //r        
       if(ss == 16'b0000000000000000)//0
       begin
        unidadesDisplay <= 4'b0000;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000001)//1
       begin
        unidadesDisplay <= 4'b0001;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000010)//2
       begin
        unidadesDisplay <= 4'b0010;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000011)//3
       begin
        unidadesDisplay <= 4'b0011;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000100)//4
       begin
        unidadesDisplay <= 4'b0100;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000101)//5
       begin
        unidadesDisplay <= 4'b0101;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000110)//6
       begin
        unidadesDisplay <= 4'b0110;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000000111)//7
       begin
        unidadesDisplay <= 4'b0111;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000001000)//8
       begin
        unidadesDisplay <= 4'b1000;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000001001)//9
       begin
        unidadesDisplay <= 4'b1001;
        decenasDisplay <= 4'b0000;
       end
       if(ss == 16'b0000000000001010)//10
       begin
        unidadesDisplay <= 4'b0000;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000001011)//11
       begin
        unidadesDisplay <= 4'b0001;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000001100)//12
       begin
       unidadesDisplay <= 4'b0010;
       decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000001101)//13
       begin
        unidadesDisplay <= 4'b0011;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000001110)//14
       begin
        unidadesDisplay <= 4'b0100;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000001111)//15
       begin
        unidadesDisplay <= 4'b0101;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000010000)//16
       begin
        unidadesDisplay <= 4'b0110;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000010001)//17
       begin
        unidadesDisplay <= 4'b0111;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000010010)//18
       begin
        unidadesDisplay <= 4'b1000;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000010011)//19
       begin
        unidadesDisplay <= 4'b1001;
        decenasDisplay <= 4'b0001;
       end
       if(ss == 16'b0000000000010100)//20
       begin
        unidadesDisplay <= 4'b0000;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000010101)//21
       begin
        unidadesDisplay <= 4'b0001;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000010110)//22
       begin
        unidadesDisplay <= 4'b0010;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000010111)//23
       begin
        unidadesDisplay <= 4'b0011;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011000)//24
       begin
        unidadesDisplay <= 4'b0100;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011001)//25
       begin
        unidadesDisplay <= 4'b0101;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011010)//26
       begin
        unidadesDisplay <= 4'b0110;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011011)//27
       begin
        unidadesDisplay <= 4'b0111;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011100)//28
       begin
        unidadesDisplay <= 4'b1000;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011101)//29
       begin
        unidadesDisplay <= 4'b1001;
        decenasDisplay <= 4'b0010;
       end
       if(ss == 16'b0000000000011110)//30
       begin
        unidadesDisplay <= 4'b0000;
        decenasDisplay <= 4'b0011;
       end
       if(ss == 16'b0000000000011111)//31
       begin
        unidadesDisplay <= 4'b0001;
        decenasDisplay <= 4'b0011;
       end

end
        3'b001://B
        begin //decidir si retirar dinero o depositar
           // LED = 16'b1111110101010101;
            if((i == 0) && (old_12_bit_value != saldo))
            begin
                shift_register = 28'd0;
                old_12_bit_value = saldo;
                shift_register [11:0] = saldo;
                temp_ones =0;//shift_register[15:12];      
                temp_tens =0;//shift_register[19:16];       
                temp_hundreds = 0;//shift_register[23:20];  
                temp_thounsands =0;//shift_register[27:24];         
                i = i+1;  
            end
            if ((i<13)&&(i>0))
            begin 
                if(temp_thounsands >= 5) temp_thounsands = temp_thounsands + 3;
                if(temp_hundreds >= 5) temp_hundreds = temp_hundreds + 3;
                if(temp_tens >= 5) temp_tens = temp_tens + 3;
                if(temp_ones >= 5) temp_ones = temp_ones + 3;
                shift_register [27:12] = {temp_thounsands,temp_hundreds,temp_tens,temp_ones};
                
                shift_register = shift_register << 1;
                
                temp_thounsands = shift_register[27:24];  
                temp_hundreds = shift_register[23:20];
                temp_tens = shift_register[19:16];    
                temp_ones = shift_register[15:12];      
                i = i+1;                      
            end 
            if (i==13)
            begin
                i = 0;
                milesDisplay = temp_thounsands;
                centenasDisplay = temp_hundreds;
                decenasDisplay = temp_tens;
                unidadesDisplay = temp_ones;
                shift_register[27:12] = 28'd0;
            end
        end
        3'b010://C
        begin // ingresar cantidad de dinero a retirar y confirmaR
            //LED = 16'b0000000000000000;
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            if((i == 0) && (old_12_bit_value != ssreg))
            begin
                shift_register = 28'd0;
                old_12_bit_value = ssreg;
                shift_register [11:0] = ssreg;
                temp_ones =      shift_register[15:12];      
                temp_tens =      shift_register[19:16];       
                temp_hundreds =  shift_register[23:20];  
                temp_thounsands =shift_register[27:24];    
                i = i+1;             
            end
            if ((i<13)&&(i>0))
            begin 
                if(temp_thounsands >= 5) temp_thounsands = temp_thounsands + 3;
                if(temp_hundreds >= 5) temp_hundreds = temp_hundreds + 3;
                if(temp_tens >= 5) temp_tens = temp_tens + 3;
                if(temp_ones >= 5) temp_ones = temp_ones + 3;
                shift_register [27:12] = {temp_thounsands,temp_hundreds,temp_tens,temp_ones};
                
                shift_register = shift_register <<1;
                
                temp_ones = shift_register[15:12];      
                temp_tens = shift_register[19:16];      
                temp_hundreds = shift_register[23:20];  
                temp_thounsands = shift_register[27:24];   
                i = i+1;                      
            end 
            if (i==13)
            begin
                i = 0;
                unidadesDisplay = temp_ones;
                decenasDisplay = temp_tens;
                centenasDisplay = temp_hundreds;
                milesDisplay = temp_thounsands;
                shift_register[27:12] = 0;
            end
        end            
        3'b011://D
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            LED = 16'b0000000000000000;
            if((i == 0) && (old_12_bit_value != ssreg))
            begin
                shift_register = 28'd0;
                old_12_bit_value = ssreg;
                shift_register [11:0] = ssreg;
                temp_ones =shift_register[15:12];      
                temp_tens =shift_register[19:16];       
                temp_hundreds = shift_register[23:20];  
                temp_thounsands =shift_register[27:24];   
                i = i+1;               

            end
            if ((i<13)&& (i>0))
            begin 
                if(temp_thounsands >= 5) temp_thounsands = temp_thounsands + 3;
                if(temp_hundreds >= 5) temp_hundreds = temp_hundreds + 3;
                if(temp_tens >= 5) temp_tens = temp_tens + 3;
                if(temp_ones >= 5) temp_ones = temp_ones + 3;
                shift_register [27:12] = {temp_thounsands,temp_hundreds,temp_tens,temp_ones};
                
                shift_register = shift_register << 1;
                
                temp_ones = shift_register[15:12];      
                temp_tens = shift_register[19:16];      
                temp_hundreds = shift_register[23:20];  
                temp_thounsands = shift_register[27:24];   
                i = i+1;                 
            end
            if (i==13)
            begin
                i = 0;
                unidadesDisplay = temp_ones;
                decenasDisplay = temp_tens; 
                centenasDisplay = temp_hundreds;
                milesDisplay = temp_thounsands;
                shift_register[27:12] = 0;
            end   
            if(((monto + saldo) >= 4096)&&(BTN[3]))
            begin
                state <= 3'b101;
            end
            else if(((monto + saldo) <= 4096) && (BTN[3]))
            begin
                state <= 3'b110;
            end            
        end    
        3'b100://E 
        begin
             oDisplay = 4'b0001;//E
             ErDisplay = 4'b0001; //r
             milesDisplay = 4'b1011;//r
             decenasDisplay = 4'b1011;//o
             centenasDisplay = 4'b1011;//r
             unidadesDisplay = 4'b0010;//2               
        end 
        3'b101://F
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r

            if((i == 0) && (old_12_bit_value != saldo))
            begin
                shift_register = 28'd0;
                old_12_bit_value = saldo;
                shift_register [11:0] = saldo;
                temp_ones =0;  
                temp_tens =0;  
                temp_hundreds = 0;
                temp_thounsands =0;       
                i = i+1;  
            end
            
            if ((i<13)&&(i>0))
            begin 
                if(temp_thounsands >= 5) temp_thounsands = temp_thounsands + 3;
                if(temp_hundreds >= 5) temp_hundreds = temp_hundreds + 3;
                if(temp_tens >= 5) temp_tens = temp_tens + 3;
                if(temp_ones >= 5) temp_ones = temp_ones + 3;
                shift_register [27:12] = {temp_thounsands,temp_hundreds,temp_tens,temp_ones};
                
                shift_register = shift_register << 1;
                
                temp_thounsands = shift_register[27:24];  
                temp_hundreds = shift_register[23:20];
                temp_tens = shift_register[19:16];    
                temp_ones = shift_register[15:12];      
                i = i+1;                      
            end 
            if (i==13)
            begin
                i = 0;
                milesDisplay = temp_thounsands;
                centenasDisplay = temp_hundreds;
                decenasDisplay = temp_tens;
                unidadesDisplay = temp_ones;
                shift_register[27:12] = 28'd0;
                if (unidadesDisplay != 4'b0000) LED [4] =1;
                if (decenasDisplay != 4'b0000) LED [5] =1;
                if (centenasDisplay != 4'b0000) LED [7] =1;
                if (milesDisplay != 4'b0000) LED [8] =1;      
                if (unidadesDisplay == 4'b0000) LED [4] =0;
                if (decenasDisplay == 4'b0000) LED [5] =0;
                if (centenasDisplay == 4'b0000) LED [7] =0;
                if (milesDisplay == 4'b0000) LED [8] =0;          
            end    
        end        
        3'b110://G
        begin
            oDisplay = 4'b0000;//E
            ErDisplay = 4'b0000; //r
            if((i == 0) && (old_12_bit_value != saldo))
            begin
                shift_register = 28'd0;
                old_12_bit_value = saldo;
                shift_register [11:0] = saldo;
                temp_ones =shift_register[15:12];      
                temp_tens =shift_register[19:16];       
                temp_hundreds = shift_register[23:20];  
                temp_thounsands =shift_register[27:24];         
                i = i+1;  
            end
            
            if ((i<13)&&(i>0))
            begin 
                if(temp_thounsands >= 5) temp_thounsands = temp_thounsands + 3;
                if(temp_hundreds >= 5) temp_hundreds = temp_hundreds + 3;
                if(temp_tens >= 5) temp_tens = temp_tens + 3;
                if(temp_ones >= 5) temp_ones = temp_ones + 3;
                shift_register [27:12] = {temp_thounsands,temp_hundreds,temp_tens,temp_ones};
                
                shift_register = shift_register << 1;
                
                temp_thounsands = shift_register[27:24];  
                temp_hundreds = shift_register[23:20];
                temp_tens = shift_register[19:16];    
                temp_ones = shift_register[15:12];      
                i = i+1;                      
            end 
            if (i==13)
            begin
                i = 0;
                milesDisplay = temp_thounsands;
                centenasDisplay = temp_hundreds;
                decenasDisplay = temp_tens;
                unidadesDisplay = temp_ones;
                shift_register[27:12] = 28'd0;
                if (unidadesDisplay != 4'b0000) LED [4] =1;
                if (decenasDisplay != 4'b0000) LED [5] =1;
                if (centenasDisplay != 4'b0000) LED [7] =1;
                if (milesDisplay != 4'b0000) LED [8] =1;       
                if (unidadesDisplay == 4'b0000) LED [4] =0;
                if (decenasDisplay == 4'b0000) LED [5] =0;
                if (centenasDisplay == 4'b0000) LED [7] =0;
                if (milesDisplay == 4'b0000) LED [8] =0;                  
            end    
        end        
        3'b111://ERROR
        begin
            oDisplay = 4'b0001;//E
            ErDisplay = 4'b0001; //r
            milesDisplay = 4'b1011;//r
            decenasDisplay = 4'b1011;//o
            centenasDisplay = 4'b1011;//r
            unidadesDisplay = 4'b0001;// 1   
        end
        default:begin
            state <= 3'b000;
        end
        endcase
        end
endmodule
