%% S曲线规划
% 边界条件
clear all
% q0 = 0; q1 = 39;  报错
% v0 = -1; v1 = 0;
q0 = 0; q1 =110; 
v0 = -1; v1 = 0;
vmax = 10; amax = 10; jmax = 30;
sigma = sign(q1 - q0);
% 得到规划参数Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin

fun=CalcFun_s();


para = fun.STrajectoryPara(q0, q1, v0, v1, vmax, amax, jmax)
i = 1; 
T = para(1) + para(2) + para(3)
for t = 0: 0.001: T
   time(i) = 0.001*i;
   q(i) = fun.S_position(t, para(1), para(2), para(3), para(4), para(5), para(6), para(7), para(8), para(9), para(10), para(11), para(12), para(13), para(14), para(15), para(16));
   qd(i) = fun.S_velocity(t, para(1), para(2), para(3), para(4), para(5), para(6), para(7), para(8), para(9), para(10), para(11), para(12), para(13), para(14), para(15), para(16));
   qdd(i) = fun.S_acceleration(t, para(1), para(2), para(3), para(4), para(5), para(6), para(7), para(8), para(9), para(10), para(11), para(12), para(13), para(14), para(15), para(16));
   qddd(i) = fun.S_jerk(t, para(1), para(2), para(3), para(4), para(5), para(6), para(7), para(8), para(9), para(10), para(11), para(12), para(13), para(14), para(15), para(16));
   i = i + 1;
end
q = sigma*q;
qd = sigma*qd;
qdd = sigma*qdd;
qddd = sigma*qddd;
figure(1)
subplot(4, 1, 1)
plot(time, q, 'r', 'LineWidth', 1.5)
grid on
subplot(4, 1, 2)
plot(time, qd, 'b', 'LineWidth', 1.5)
grid on
subplot(4, 1, 3)
plot(time, qdd, 'g', 'LineWidth', 1.5)
grid on
subplot(4, 1, 4)
plot(time, qddd, 'LineWidth', 1.5)
grid on

% ————————————————
% 版权声明：本文为CSDN博主「xuuyann」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
% 原文链接：https://blog.csdn.net/qq_26565435/article/details/94657852