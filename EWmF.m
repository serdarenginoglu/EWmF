%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% Enginoğlu, S., Erkan, U., Memiş, S. (2022). Exponentially Weighted Mean 
% Filter for Salt-and-Pepper Noise Removal. In: Dang, N.H.T., Zhang, YD., 
% Tavares, J.M.R.S., Chen, BH. (eds) Artificial Intelligence in Data and 
% Big Data Processing. ICABDE 2021. Lecture Notes on Data Engineering and 
% Communications Technologies, vol 124. Springer, Cham, pp. 435-446.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abbreviation of Journal Title: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://doi.org/10.1007/978-3-030-97610-1_34 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.researchgate.net/profile/Serdar_Enginoglu2
% https://www.researchgate.net/profile/Ugur_Erkan
% https://www.researchgate.net/profile/Samet_Memis2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Demo: 
% clc;
% clear all;
% io=imread("lena.tif");
% Noise_Image=imnoise(io,'salt & pepper',0.8);
% Denoised_Image=EWMF(Noise_Image);
% psnr_results=4snr(io,uint8(Denoised_Image));
% ssim_results=ssim(io,uint8(Denoised_Image));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ResA=EWmF(A)
A=double(A);
A(A==255)=0;
nd=noise_density(A);                        % possibly noise density
th=round(20/((50*nd-1)^(1/3)));             % threshold value 
W4=ewm(4,th+1);                             % exponential weighted matrix 
V=[0, 1, 0; 1, 1, 1; 0, 1, 0];              % exponential weighted matrix 
V1=V.*W4(4:6,4:6);                          % for Von Neumann neighbourhood
pA=padarray(A,[4 4],'symmetric');           % 4-symmetric pad of A
[m,n]=size(A);
for i=1:m
  for j=1:n        
    if (pA(i+4,j+4)==0)
       for k=1:4
           Aij=pA(i+4-k:i+4+k,j+4-k:j+4+k); % k-approximate matrix of a_ij
           Bij=sign(Aij);                   % binary matrix (signum)  
           Wk=W4(5-k:5+k,5-k:5+k);
           if (k==1 && sum(sum(V.*Bij))>=3)  
              ResA(i,j)=ewmean(Aij,Bij,V1);
              break;
           elseif (sum(sum(Bij))>=th)                    
              ResA(i,j)=ewmean(Aij,Bij,Wk); 
              break;
           end
       end          
    else
       ResA(i,j)=pA(i+4,j+4);   
    end
  end
end

clear i j k Aij Bij Wk V th;
  
% if (nd>=30)
pResA=padarray(ResA,[2 2],'symmetric');
W1=W4(4:6,4:6);
W2=W4(3:7,3:7);
   for i=1:m
       for j=1:n
           if (nd<80 && pA(i+4,j+4)==0)
              Aij=pResA(i+1:i+3,j+1:j+3);
              Bij=sign(Aij);
              ResA(i,j)=ewmean(Aij,Bij,V1);  
           elseif (nd<90 && pA(i+4,j+4)==0)
              Aij=pResA(i+1:i+3,j+1:j+3);
              Bij=sign(Aij);
              ResA(i,j)=ewmean(Aij,Bij,W1);
           elseif (nd>=90 && pA(i+4,j+4)==0)
              Aij=pResA(i:i+4,j:j+4);
              Bij=sign(Aij);
              ResA(i,j)=ewmean(Aij,Bij,W2);
           end
       end
   end
% end
ResA=uint8(ResA);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nd=noise_density(A)
[m,n]=size(A);
B=(~(A==0 | A==255));
T=sum(sum(B));
nd=round(100-(100*T)/(m*n));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w=ewm(k,th)
  for s=1:2*k+1
     for t=1:2*k+1
         w(s,t)=(1/th)^(abs(k+1-s)+abs(k+1-t));
     end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out=ewmean(Aij,Bij,W) % exponential weighted mean
out=sum(sum(W.*Aij))/sum(sum(W.*Bij));                                                  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%