%% B-Spline Test
% By Chanoh Park
% copark86@gmail.com
% 12 Nov 2016

close all
clear all


% Sample data point
p = [1 1 1; 2 3 2; 4 5 5; 6 6 3; 5 4 1; 6 7 1; 9 9 8; 12 15 11];





% Number of sample points
Np = length(p)

% Number of control points
Nq = 100;

if Nq >Np
    Nq=Np;
end

% Basis matrix
M = [-1 3 -3 1;3 -6 3 0; -3 0 3 0;1 4 1 0];

N(Np,Nq)=0


%% Calculate the best control point locations
for i = 1: Np

    % float
    index_f = Nq*(i/Np);
    
    % int	
    index_i = floor(index_f);
    t = index_f -index_i;
    
    % Q-1 Q0 Q1 Q2
    indexV = index_i-1:index_i+2;
    indexV(find(indexV<1))=1;
    indexV(find(indexV>Nq))=Nq;
    
    tv = [t^3 t^2 t 1];
    
    temp=tv*M/6;
    N(i,indexV(1)) = N(i,indexV(1)) +temp(1); 
    N(i,indexV(2)) = N(i,indexV(2)) +temp(2); 
    N(i,indexV(3)) = N(i,indexV(3)) +temp(3);
    N(i,indexV(4)) = N(i,indexV(4)) +temp(4);
    
end

invNN_Nt=inv(N'*N)*N';

% Control points
Q=invNN_Nt*p;
save Q Q M

%% Draw line 

% Number of steps
Nbs = 500;
hold on
BSpline_=[0 0 0];

for i = 1:Nbs
    
    % divide Number of Control points by Nbs steps
    index_f = Nq*(i/Nbs);
    
    % current control point index
    index_int = floor(index_f);
    
    t_ = index_f-index_int;
    tv = [t_^3 t_^2 t_ 1];
    
    % saving data
    t_save(i,1)=index_f;
    t_save(i,2)=index_int;
    t_save(i,3)=t_;
    % control points index 
    indexV = index_int-1:index_int+2;
    indexV(find(indexV<1))=1;
    indexV(find(indexV>Nq))=Nq;
    
    Q_4 = Q(indexV,:); 
    pbs=tv*M*Q_4/6;
    BSpline_=[BSpline_;pbs]
end
BSpline_l = BSpline_(2:end,:) 


%% spline display
a=plot3(p(:,1),p(:,2),p(:,3),'o')
hold on
plot3(p(:,1),p(:,2),p(:,3))
title('B-Spline Test');
xlabel('X'); ylabel('Y');
plot3(BSpline_l(:,1),BSpline_l(:,2),BSpline_l(:,3),'rx');
hold on
b=plot3(BSpline_l(:,1),BSpline_l(:,2),BSpline_l(:,3),'r');
c=plot3(Q(:,1),Q(:,2),Q(:,3),'ms');
grid on

legend([a,b,c],'Original','B-Spline','Control points');

figure
plot(t_save(:,1),t_save(:,3),'rx');
hold on
plot(t_save(:,1),t_save(:,3));
title('t value visualization');
xlabel('0~Nq'); ylabel('t');


%% weight visualization
figure
weights = [0 0 0 0 0];
for t = 0:0.01:1
    tv = [t^3 t^2 t 1];
    weights = [weights; [tv*M t]];
end
weights = weights(2:end,:)

g1=plot(weights(:,5),weights(:,1),'r')
hold on
g2=plot(weights(:,5),weights(:,2),'g')
g3=plot(weights(:,5),weights(:,3),'m')
g4=plot(weights(:,5),weights(:,4),'b')
title('weights visualization');
xlabel('t = 0~1'); ylabel('Weights');
legend([g1 g2 g3 g4],'W for Q_n-1','W for Q_n','W for Q_n+1','W for Q_n+2');

figure
g1=plot(weights(:,5)+1,weights(:,1),'r')
hold on
g2=plot(weights(:,5),weights(:,2),'g')
g3=plot(weights(:,5)-1,weights(:,3),'m')
g4=plot(weights(:,5)-2,weights(:,4),'b')
title('weights visualization');
xlabel('t = 0~1'); ylabel('Weights');
legend([g1 g2 g3 g4],'W for Q_n-1','W for Q_n','W for Q_n+1','W for Q_n+2');

