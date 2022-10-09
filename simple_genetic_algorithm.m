clear all; close all; clc;
%Pradiniai duomenys

%zodynas = 'abcdef_012345';
%zodynas = 'qwertyuiopasdfghjklzxcvbnm_0123456789';
zodynas = 'qwertyuiop[]\asdfghjkl;zxcvbnm,./0123456789!?@#$%^&*()_+|`~';

tikslas = 'ld1?';

results = [];
correct = [];
best_out = '';
not_in = 0;

%randam tikslo dydį
size_do = size(tikslas);
size_do = size_do(2);

iteracijos = 10^15;

%reikšmes keičiam į dvejatainę sistemą
binary = reshape(dec2bin(tikslas, 8).'-'0',1,[]);
%str = char(bin2dec(reshape(char(binary+'0'), 8,[]).')) %atgal i teksta

for i=1:iteracijos
   out1 = ''; %pradedam nuo tuščios reikšmės
   out2 = '';
   
   %generuojame random tokio pat dydžio tekstą
   chosen_i = randi(size(zodynas,2),1,size_do);
   a = 1;
   x = 1;
   while size(out1,2) ~= size_do
       if i ~=1 && isempty(correct) ~= 1
           for s=1:size(correct)
               if correct(s) ~= a
                  not_in = 1;
               else
                  out1 = strcat(out1,best_out(a)); %reikšmę paliekame jei simbolis atitiko tai ko norim(cross over point)
               end
           end
       end
       if i == 1   
            character = zodynas(chosen_i(a));
            out1 = strcat(out1,character);  
       end
       if not_in == 1 || isempty(correct) && i ~= 1
            character = zodynas(chosen_i(a));
            out1 = strcat(out1,character);     
       end
       not_in = 0;
       a = a + 1;
   end
   
   % kartojam su out2
   a = 1;
   x = 1;
   chosen_i = randi(size(zodynas,2),1,size_do);
   while size(out2,2) ~= size_do
       if i ~=1 && isempty(correct) ~= 1
           for s=1:size(correct)
               if correct(s) ~= a
                  not_in = 1;
               else
                  out2 = strcat(out2,best_out(a));
               end
           end
       end
       if i == 1   
            character = zodynas(chosen_i(a));
            out2 = strcat(out2,character);  
       end
       if not_in == 1 || isempty(correct) && i ~= 1
            character = zodynas(chosen_i(a));
            out2 = strcat(out2,character);     
       end
       not_in = 0;
       a = a + 1;
   end
   
   %reikšmes keičiam į dvejatainę sistemą
   bin_output1 = reshape(dec2bin(out1, 8).'-'0',1,[]);
   bin_output2 = reshape(dec2bin(out2, 8).'-'0',1,[]);
   
   %nunuliname correct masyvą
   correct = [];
   
   %palyginame rezultatus
   if i == 1
       no_similar_bits_best1 = sum(binary==bin_output1);
       no_similar_bits_best2 = sum(binary==bin_output2);
       if no_similar_bits_best1 > no_similar_bits_best2    
            number_of_similar_bits_best = no_similar_bits_best1;
            current_best = bin_output1;
            
            %issaugoma geriausia iteracija
            best_out = out1;
            results = [results no_similar_bits_best1];
       else    
            number_of_similar_bits_best = no_similar_bits_best2;
            current_best = bin_output2;
            best_out = out2;
            results = [results no_similar_bits_best2];
       end
       
   else %populiacijos atranka N-to paleidimo metu
       while x < size(out1,2)
           if out1(x) == tikslas(x) 
               correct = [correct x];
           end
           if out2(x) == tikslas(x) 
               correct = [correct x];
           end
           x = x + 1;
       end
       
       %surūšiuojami teisingi spėjimai didėjimo tvarka
       correct = sort(correct);
       correct = sort(correct);
       number_of_similar_bits1 = sum(binary==bin_output1);
       number_of_similar_bits2 = sum(binary==bin_output2);
       if number_of_similar_bits1 > number_of_similar_bits_best
            number_of_similar_bits_best = number_of_similar_bits1;
            current_best = bin_output1;
            best_out = out1;
       elseif number_of_similar_bits2 > number_of_similar_bits_best
            number_of_similar_bits_best = number_of_similar_bits2;
            current_best = bin_output2;
            best_out = out2;
       end
       results = [results number_of_similar_bits1];
       results = [results number_of_similar_bits2];
       if out1 == tikslas
           break
       elseif out2 == tikslas
           break
       end
   end
end

%rezultatai
str = char(bin2dec(reshape(char(current_best+'0'), 8,[]).'));
str = reshape(str,[1,size_do]);
str = convertCharsToStrings(str);

fprintf('tikslas - %s\ngautas tekstas - %s\nreikalingas iteracijų skaičius - %d\n', tikslas, str, i);
