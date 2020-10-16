%% S曲线规划
% 边界条件
clear all
% q0 = 0; q1 = 39;  报错
% v0 = -1; v1 = 0;
q0 = 0; q1 =39; 
v0 = -1; v1 = 0;
vmax = 10; amax = 10; jmax = 30;
sigma = sign(q1 - q0);
% 得到规划参数Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin

fun=CalcFun_s();


para = fun.STrajectoryPara(q0, q1, v0, v1, vmax, amax, jmax)
i = 1; 
T = para(1) + para(2) + para(3)
for t = 0: 0.001: T
   q(i) = fun.S_position(t, para(1), para(2), para(3), para(4), para(5), para(6), para(7), para(8), para(9), para(10), para(11), para(12), para(13), para(14), para(15), para(16));

  
end

t, Ta=para(1), Tv=para(2), Td=para(3), Tj1=para(4), Tj2=para(5), q0=para(6), q1=para(7), v0=para(8), v1=para(9), vlim=para(10)
amax=para(11), amin=para(12), alima=para(13), alimd=para(14), jmax=para(15), jmin=para(16)
