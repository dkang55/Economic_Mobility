%Economic Mobility: Markov Chains
%Daniel Kang 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% r = [0,5] s = [0,5]

% % racial integration high 
% % schooling high 
%  r = 4.5; %***
%  s = 5; %***

% %racial integration high 
% %schooling low 
%  r = 4.2;
%  s = 1.15;

% %racial integration low 
% %schooling high 
% r = 1.1;
% s = 4.3;  

% %racial integrationlow
% %schooling low 
r = 1.3; 
s = 1.8;  

%%%%%%%setting parameters for matrix%%%%%%%%
p = ((r*s)^2 + r^2)/(50);
q = (r^2 + s^2)/(50);

A=[[1-p p];[1-q q]];

%%%%%%%%simulating after every generation%%%%%%
N = 300; %initial population 
nsim = 500; % number of simulations 
gens = 50; %number of generations 
demog = zeros(2,nsim);

%%recording simulation data%% 
stage1 = zeros(gens, nsim);
stage2 = zeros(gens, nsim); 

for i = 1:nsim
    pop = zeros(gens,N);
    pop(1,1:150) = 1;
    pop(1,151:300) = 2;
    
    t = 1;

    while t < gens
        B = A;
        for j = 1:N 
            rnd = rand(1);
            if (pop(t,j) == 1)
                if (rnd < B(1,2))
                    pop(t+1,j) = 2;
                else 
                    pop(t+1,j) = 1;
                end 
            end
            rnd = rand(1);
            if (pop(t,j) == 2)
                if (rnd < B(2,2))
                    pop(t+1,j) = 2;
                else 
                    pop(t+1,j) = 1;
                end
            end
        end
       
%         if mod(t-1,5) == 0
%         histogram(pop(t,:));
%         %hold on
%         xlabel('Population');
%         ylabel('Frequency');
%         pause(.5)
%         end
         
        stage1(t,i) = sum(pop(t,:) == 1);
        stage2(t,i) = sum(pop(t,:) == 2);
        t = t+1;
    end

end

avgs1 = mean(stage1,2);
avgs2 = mean(stage2,2);

for i = 1:gens
   legendstring = sprintf('Generation %d', i);
   bar([1 2], [avgs1(i)/N avgs2(i)/N], 'r')
   legend(legendstring, 'Location', 'northwest')
   xlabel('Stage')
   ylabel('Frequency')
   title('Low Racial Integration & Bad Schools') 
   
   pause(.05)
end



                




