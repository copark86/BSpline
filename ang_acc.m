clear all
close all

%% Draw line 
load Q
% Number of control points
Nq = 8;
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
    BSpline_=[BSpline_;pbs];
end
BSpline_l = BSpline_(2:end,:) 


%% spline display



title('B-Spline Test');
xlabel('X'); ylabel('Y');
plot3(BSpline_l(:,1),BSpline_l(:,2),BSpline_l(:,3),'rx');
hold on
hold on
b=plot3(BSpline_l(:,1),BSpline_l(:,2),BSpline_l(:,3),'r');

grid on

%legend([b,c],'Original','B-Spline','Control points');


diff_line = diff(BSpline_l)
% figure 
% b=plot3(diff_line(:,1),diff_line(:,2),diff_line(:,3),'r');
dt = 0.05
for i = 2:10:Nbs-1
    t1=BSpline_l(i-1,:);
    t2=BSpline_l(i,:);
    t3=BSpline_l(i+1,:);
    
    v1 = (t2-t1)/dt;    
    v2 = (t3-t2)/dt;
    
    acc = (v2 - v1)/dt;
    
    acc = (t1-2*t2+t3)/(dt^2);
    
    quiver3(t2(1),t2(2),t2(3),acc(1),acc(2),acc(3),'g');
    quiver3(t2(1),t2(2),t2(3),v1(1),v1(2),v1(3),'m');
    quiver3(t2(1),t2(2),t2(3),v2(1),v2(2),v2(3),'b');
    
end