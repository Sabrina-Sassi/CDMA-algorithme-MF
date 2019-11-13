
clc
clear vars;
N = 100;                     % Nombre de bits transmis 
K = 20;                         % Nombres d'utilisateurs dans la zone de communication
Eb = 1;                         % Enérgie par bit (valeur normalisée)
%g=5;                            % ordre du registre à décalage (fonction Gold)
C =31;                       % Facteur de gain 
a = gold(C);                    % Matrice des codes (séquences de Gold)                                                            
S = a(:,(1:K))./sqrt(C);        % C x K = Matrice des codes normalisée  
% R = corrcoef(S);              
MAI_in_dB =-7;                  % Puissance relative des interférants (en dB)
MAI = 10 ^ (MAI_in_dB/10); 
A = sqrt(MAI) .* eye(K,K);      % K x K = matrice des amplitudes des utilisateurs
d= sign(ones(K,N)*2-0.5);       % K x N = matrice des données des utilisateurs
d_user_1_estimate = zeros(1,N); % 1 x N = données estimées de l'utilisateur 1
t = zeros(C,N);                 % C x N = matrice des données transmises
r = zeros(C,N);                 % C x N = matrice des données reçues
s_1 = S(:,1);                   % C x 1 = signal reçu du 1er utilisateur
SNR_in_dB = 0:1:50;             % Rapport signal à bruit 

% transmission des données sur un canal AWGN
for j=1:length(SNR_in_dB),      
    SNR = 10 ^ (SNR_in_dB(j)/10); 
    sgma = sqrt(1/(2*SNR));     % Puissance du bruit (2*sgma^2= 1/SNR)
    n = sgma * randn(C,N);      % Génération du bruit AWGN
    for i = 1 : N 
      t(:,1) = S * A * d(:,i);  % Signal transmis
      r(:,i) = t(:,i) + n(:,i); % Signal reçu
    end 
    
    % Application du Matched filter sur le signal du 1er utilisateur  
    for i = 1 : N 
      d_user_1_estimate(i) = sign(s_1'*r(:,i));  
    end 
    
    for bloc j= 1:10
    error_number = length(find(d(1,:)- d_user_1_estimate)); %calcul du nombre de bits erronés
    BER(j)=error_number/N; % calcul du BER 
    end
    %BER(j)= mean (BER_1);
end 
 semilogy(SNR_in_dB,BER, 'xr-');% Plot du BER Vs SNR
 hold on;
 title('Détection  CDMA');
 xlabel('rapport signal sur bruit (SNR)'); 
 ylabel('BER') 
 %legend('k=10','k=20','k=30');
 grid on; 