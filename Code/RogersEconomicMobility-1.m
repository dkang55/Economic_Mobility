%Jordan Rogers
%AM115 Project 2 - Economic Mobility 

%Transition matrix (row = parents' bracket, column = child's bracket
%Zeros exclude
T1 = [0.421 0.245 0.153 0.102 0.079;
     0.194 0.284 0.208 0.174 0.140;
     0.194 0.186 0.256 0.202 0.162;
     0.125 0.182 0.198 0.252 0.243;
     0.095 0.122 0.189 0.234 0.360];
 
 numBuckets = 5;
 agentsPer = 10000;
 population = ones(numBuckets, agentsPer);
 population(2,:) = 2;
 population(3,:) = 3;
 population(4,:) = 4;
 population(5,:) = 5;
 
 savings = [.0 .0 .02 .06 .12]; %percent of income saved per quintile
 %https://www.financialsamurai.com/the-average-savings-rates-by-income-wealth-class/
 incomes = [15000 35000 55000 90000 160000];%annual houshold income/quint 
 %https://en.wikipedia.org/wiki/Household_income_in_the_United_States#Distribution_of_household_income
 investReturns = .07;%annual SP500 returns adjusted for inflation
 
 wealth = zeros(numBuckets, agentsPer);%matrix to track family wealth

 edges = [.5 1.5 2.5 3.5 4.5 5.5];
 barwidth = .9;
 
 figure(1)
 subplot(3,2,1)
 histogram(population(1,:),edges, 'FaceAlpha', .2)
 xlim([0.5 5.5])
 title('Starting from 1st quintile')
 xlabel('Quintile')
 legend('Generation 0')
 subplot(3,2,3)
 histogram(population(2,:),edges, 'FaceAlpha', .4)
 xlim([0.5 5.5])
 title('Starting from 2nd quintile')
 xlabel('Quintile')
 legend('Generation 0')
 subplot(3,2,5)
 histogram(population(3,:),edges, 'FaceAlpha', .6)
 xlim([0.5 5.5])
 title('Starting from 3rd quintile')
 xlabel('Quintile')
 legend('Generation 0')
 subplot(3,2,2)
 histogram(population(4,:),edges, 'FaceAlpha', .8)
 xlim([0.5 5.5])
 title('Starting from 4th quintile')
 xlabel('Quintile')
 legend('Generation 0')
 subplot(3,2,4)
 histogram(population(5,:),edges, 'FaceAlpha', 1)
 xlim([0.5 5.5])
 title('Starting from 5th quintile')
 xlabel('Quintile')
 legend('Generation 0')
 subplot(3,2,6)
 scatter([1 2 3 4 5], mean(wealth,2), 'filled')
 title('Accumulated Wealth')
 xlabel('Original Quintile')
 ylabel('Average Wealth')
 legend('Generation 0', 'location', 'northwest')
 
 
 %simulation for T1 - transition matrix without zeros 
 maxGens = 20;
 for i = 1:maxGens
     for r = 1:numBuckets
         for a = 1:agentsPer
            %run 20 investment cycles per generation
%           for j = 1:20 
%               %add generations wealth (income + interest on previous wealth
%               %at 7% 
%               wealth(r,a) = wealth(r,a)*(1 + investReturns) + ...
%                             incomes(population(r,a))*savings(population(r,a));
%           end
%
            %run 1 investment cycle per generation
            wealth(r,a) = wealth(r,a)*(1 + investReturns) + ...
                          incomes(population(r,a))*savings(population(r,a));
                       
            %Make jump to new generation based on transition prob from
            %current state
            population(r,a) = randsample([1 2 3 4 5], 1, true,... 
                                         T1(population(r,a),:));
         end
     end
     %plot new generations when applicable
     if ismember(i,[1, 2, 3, 5, 10, 15, 20])
         pause(.5)
         tstring = sprintf('Generation %d', i);
         subplot(3,2,1)
         histogram(population(1,:),edges, 'FaceAlpha', .2)
         xlim([0.5 5.5])
         title('Starting from 1st quintile')
         xlabel('Quintile')
         legend(tstring)
         subplot(3,2,3)
         histogram(population(2,:),edges, 'FaceAlpha', .4)
         xlim([0.5 5.5])
         title('Starting from 2nd quintile')
         xlabel('Quintile')
         legend(tstring)
         subplot(3,2,5)
         histogram(population(3,:),edges, 'FaceAlpha', .6)
         xlim([0.5 5.5])
         title('Starting from 3rd quintile')
         xlabel('Quintile')
         legend(tstring)
         subplot(3,2,2)
         histogram(population(4,:),edges, 'FaceAlpha', .8)
         xlim([0.5 5.5])
         title('Starting from 4th quintile')
         xlabel('Quintile')
         legend(tstring)
         subplot(3,2,4)
         histogram(population(5,:),edges, 'FaceAlpha', 1)
         xlim([0.5 5.5])
         title('Starting from 5th quintile')
         xlabel('Quintile')
         legend(tstring)
         
         %Plot of accumulated wealth 
         subplot(3,2,6)
         scatter([1 2 3 4 5], mean(wealth,2), 'filled')
         hold on
         err = std(wealth,0,2);
         m = mean(wealth,2);
         q05 = quantile(wealth, .05, 2);%.05 quintile of each row
         q95 = quantile(wealth, .95, 2);%.95 quintile of each row
         errorbar([1 2 3 4 5], m, m - q05, q95 - m, '.')
         title('Accumulated Wealth')
         xlabel('Original Quintile')
         ylabel('Average Wealth')
         hold off
         legend(tstring, 'location', 'northwest')
     end   
 end
 
 

     