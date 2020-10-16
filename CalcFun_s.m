% ���ؽڿռ�滮
%% S���߲������㣨S���ٶȹ滮���ֳ��߶�ʽ�켣��

function fun=CalcFun_s
fun.STrajectoryPara=@STrajectoryPara;
fun.S_position=@S_position;
fun.S_velocity=@S_velocity;
fun.S_acceleration=@S_acceleration;
fun.S_jerk=@S_jerk;

end

function para = STrajectoryPara(q0, q1, v0, v1, vmax, amax, jmax)
% �õ��滮����Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin
% �û���������
% �߽�����q0 = 10, q1 = 0, v0 = -7, v1 = 0
% Լ������vmax = 10, amax = 10, jamx = 30
% q0 = 0; q1 = 10; 
% v0 = 7.5; v1 = 0;
% vmax = 10; amax = 10; jmax = 30;
vmin = -vmax; amin = -amax; jmin = -jmax;

%% ���ù�ʽ��3.31����3.32��ת���õ�ʵ�ʵ�q_0��q_1��v_max��a_max
sigma = sign(q1 - q0);  
q_0 = sigma*q0;
q_1 = sigma*q1;
v_0 = sigma*v0;
v_1 = sigma*v1;
v_max = ((sigma+1)/2)*vmax + ((sigma-1)/2)*vmin;
v_min = ((sigma+1)/2)*vmin + ((sigma-1)/2)*vmax;
a_max = ((sigma+1)/2)*amax + ((sigma-1)/2)*amin;
a_min = ((sigma+1)/2)*amin + ((sigma-1)/2)*amax;
j_max = ((sigma+1)/2)*jmax + ((sigma-1)/2)*jmin;
j_min = ((sigma+1)/2)*jmin + ((sigma-1)/2)*jmax;

%% �ж��Ƿ�ﵽ����ٶ�
if ((v_max - v_0)*j_max < a_max^2) 
    Tj1 = sqrt((v_max - v_0) / j_max); % �ﲻ��a_max
    Ta = 2*Tj1;
    a_lima = j_max * Tj1;
else
    Tj1 = a_max / j_max; % �ܹ��ﵽa_max
    Ta = Tj1 + (v_max - v_0) / a_max;
    a_lima = a_max;
end
if ((v_max - v_1)*j_max < a_max^2)
    Tj2 = sqrt((v_max - v_1) / j_max); % �ﲻ��a_min
    Td = 2*Tj2;
    a_limd =  -j_max * Tj2;
else
    Tj2 = a_max / j_max; % �ܹ��ﵽa_min
    Td = Tj2 + (v_max - v_1) / a_max;
    a_limd = -a_max;
end
% ���ݣ�3.25���������ٶ�ʱ��
Tv = (q_1 - q_0)/v_max - (Ta/2)*(1 + v_0/v_max) - (Td/2)*(1 + v_1/v_max);

%% ��Tv��������
if (Tv > 0)
    % �ﵽ����ٶ�v_max�����������ٽ׶�
    vlim = v_max;
    T = Ta + Tv + Td;
    para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
    return;
else
    % �ﲻ������ٶȣ������ٽ׶�Tv=0
    % ���������ٶȺ���С���ٶȾ��ܴﵽ
    Tv = 0;
    Tj = a_max / j_max;
    Tj1 = Tj;
    Tj2 = Tj;
    delta = (a_max^4/j_max^2) + 2*(v_0^2 + v_1^2) + a_max*(4*(q_1 - q_0) - 2*(a_max/j_max)*(v_0 + v_1));
    Ta = ((power(a_max, 2)/j_max) - 2.0*v_0 + sqrt(delta)) / (2.0*a_max);
    Td = ((power(a_max, 2)/j_max) - 2.0*v_1 + sqrt(delta)) / (2.0*a_max);
    % ��Ta��Td��������
    if (Ta < 0 || Td < 0)
        if (Ta < 0)
            % û�м��ٶΣ�ֻ�м��ٶ�
            Ta = 0; Tj1 = 0;
            Td = 2*(q_1 - q_0) / (v_0 + v_1);
            Tj2 = (j_max*(q_1 - q_0) - sqrt(j_max*(j_max*power(q_1 - q_0, 2) + power(v_1 + v_0, 2)*(v_1 - v_0)))) / (j_max*(v_1 + v_0));
            a_lima = 0;
            a_limd = -j_max*Tj2;
            vlim = v0;
            para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
            return;
        elseif (Td < 0)
            % û�м��ٶΣ�ֻ�м��ٶ�
            Td = 0; Tj2 = 0;
            Ta = 2*(q_1 - q_0) / (v_0 + v_1);
            Tj1 = (j_max*(q_1 - q_0) - sqrt(j_max*(j_max*power(q_1 - q_0, 2)) - power(v_1 + v_0, 2)*(v_1 - v_0))) / (j_max*(v_1 + v_0));
            a_lima = j_max*Tj1;
            a_limd = 0;
            vlim = v_0 + a_lima*(Ta - Tj1);
            para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
            return;
        end
    elseif (Ta >= 2*Tj && Td >= 2*Tj)
        % ���ٶκͼ��ٶζ��ܴﵽ�����ٶ�
        a_lima = a_max;
        a_limd = -a_max;
        vlim = v0 + a_lima*(Ta - Tj1);
        para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
        return;
    else
        % ���ٺͼ��ٽ׶�������һ�β��ܴﵽ�����ٶ�
        lambda = 0.99; % ϵͳȡ0<lambda<1
        while (Ta < 2*Tj || Td < 2*Tj)
            % ѭ��
            a_max = lambda*a_max;
            Tv = 0;
            Tj = a_max / j_max;
            Tj1 = Tj;
            Tj2 = Tj;
            delta = (a_max^4/j_max^2) + 2*(v_0^2 + v_1^2) + a_max*(4*(q_1 - q_0) - 2*(a_max/j_max)*(v_0 + v_1));
            Ta = ((power(a_max, 2)/j_max) - 2.0*v_0 + sqrt(delta)) / (2.0*a_max);
            Td = ((power(a_max, 2)/j_max) - 2.0*v_1 + sqrt(delta)) / (2.0*a_max);
            if (Ta < 0 || Td < 0)
                if (Ta < 0)
                    % û�м��ٶΣ�ֻ�м��ٶ�
                    Ta = 0; Tj1 = 0;
                    Td = 2*(q_1 - q_0) / (v_0 + v_1);
                    Tj2 = (j_max*(q_1 - q_0) - sqrt(j_max*(j_max*power(q_1 - q_0, 2) + power(v_1 + v_0, 2)*(v_1 - v_0)))) / (j_max*(v_1 + v_0));
                    a_lima = 0;
                    a_limd = -j_max*Tj2;
                    vlim = v0;
                    para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
                    return;
                elseif (Td < 0)
                    % û�м��ٶΣ�ֻ�м��ٶ�
                    Td = 0; Tj2 = 0;
                    Ta = 2*(q_1 - q_0) / (v_0 + v_1);
                    Tj1 = (j_max*(q_1 - q_0) - sqrt(j_max*(j_max*power(q_1 - q_0, 2)) - power(v_1 + v_0, 2)*(v_1 - v_0))) / (j_max*(v_1 + v_0));
                    a_lima = j_max*Tj1;
                    a_limd = 0;
                    vlim = v_0 + a_lima*(Ta - Tj1);
                    para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
                    return;
                end
            elseif (Ta >= 2*Tj && Td >= 2*Tj)
                % ���ٶκͼ��ٶζ��ܴﵽ�����ٶ�
                a_lima = a_max;
                a_limd = -a_max;
                vlim = v0 + a_lima*(Ta - Tj1);
                para = [Ta, Tv, Td, Tj1, Tj2, q_0, q_1, v_0, v_1, vlim, a_max, a_min, a_lima, a_limd, j_max, j_min];
                return;
            end
        end
    end
end
end

%% ����λ��
function q = S_position(t, Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin)
T = Ta + Tv + Td;
% ���ٶ�
if (t >= 0 && t < Tj1)
    q = q0 + v0*t + jmax*t^3/6;
elseif (t >= Tj1 && t < Ta - Tj1)
    q = q0 + v0*t +(alima/6)*(3*t^2 - 3*Tj1*t + Tj1^2);
elseif (t >= Ta - Tj1 && t < Ta)
    q = q0 + (vlim + v0)*(Ta/2) - vlim*(Ta - t) - jmin*((Ta - t)^3/6);
% ���ٶ�
elseif (t >= Ta && t < Ta + Tv)
    q = q0 + (vlim + v0)*(Ta/2) + vlim*(t - Ta);
% ���ٶ�
elseif (t >= Ta + Tv && t < T - Td + Tj2)
    q = q1 - (vlim + v1)*(Td/2) + vlim*(t - T + Td) - jmax*(power(t - T + Td, 3)/6);
elseif (t >= T - Td + Tj2 && t < T - Tj2)
    q = q1 - (vlim + v1)*(Td/2) + vlim*(t - T + Td) + (alimd/6)*(3*power(t - T + Td, 2) - 3*Tj2*(t - T + Td) + Tj2^2);
elseif (t>= T - Tj2) &&( floor(t) <= T)  %���ȳ�����
    q = q1 - v1*(T - t) - jmax*(power(T - t, 3)/6);
else
    q=q1;%�Լ��ӵ�
end
end


%% �����ٶ�
function qd = S_velocity(t, Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin)
T = Ta + Tv + Td;
if (t >= 0 && t < Tj1)
    qd = v0 + jmax*(t^2/2);
elseif (t >= Tj1 && t < Ta - Tj1)
    qd = v0 + alima*(t - Tj1/2);
elseif (t >= Ta - Tj1 && t < Ta)
    qd = vlim + jmin*(power(Ta - t, 2)/2);
% ���ٶ�
elseif (t >= Ta && t < Ta + Tv)
    qd = vlim;
% ���ٶ�
elseif (t >= Ta + Tv && t < T - Td + Tj2)
    qd = vlim - jmax*(power(t - T + Td, 2)/2);
elseif (t >= T - Td + Tj2 && t < T - Tj2)
    qd = vlim + alimd*(t - T + Td - Tj2/2);
elseif (t >= T - Tj2 && t <= T)
    qd = v1 + jmax*(power(t - T, 2)/2);
else
    qd= v1;%�Լ��ӵ�
end
end


%% ������ٶ�
function qdd = S_acceleration(t, Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin)
T = Ta + Tv + Td;
if (t >= 0 && t < Tj1)
    qdd = jmax*t;
elseif (t >= Tj1 && t < Ta - Tj1)
    qdd = alima;
elseif (t >= Ta - Tj1 && t < Ta)
    qdd = -jmin*(Ta - t);
% ���ٶ�
elseif (t >= Ta && t < Ta + Tv)
    qdd = 0;
% ���ٶ�
elseif (t >= Ta + Tv && t < T - Td + Tj2)
    qdd = -jmax*(t - T + Td);
elseif (t >= T - Td + Tj2 && t < T - Tj2)
    qdd = alimd;
elseif (t >= T - Tj2 && t <= T)
    qdd = -jmax*(T - t);
else 
    qdd=-jmax*(T - t); %�Լ��ӵ�
end
end


%% ����Ӽ��ٶ�
function qddd = S_jerk(t, Ta, Tv, Td, Tj1, Tj2, q0, q1, v0, v1, vlim, amax, amin, alima, alimd, jmax, jmin)
T = Ta + Tv + Td;
if (t >= 0 && t < Tj1)
    qddd = jmax;
elseif (t >= Tj1 && t < Ta - Tj1)
    qddd = 0;
elseif (t >= Ta - Tj1 && t < Ta)
    qddd = jmin;
% ���ٶ�
elseif (t >= Ta && t < Ta + Tv)
    qddd = 0;
% ���ٶ�
elseif (t >= Ta + Tv && t < T - Td + Tj2)
    qddd = -jmax;
elseif (t >= T - Td + Tj2 && t < T - Tj2)
    qddd = 0;
elseif (t >= T - Tj2 && t <= T)
    qddd = jmax
else
    qddd = jmax;%�Լ��ӵ�
end
end
% ��������������������������������
% ��Ȩ����������ΪCSDN������xuuyann����ԭ�����£���ѭ CC 4.0 BY-SA ��ȨЭ�飬ת���븽��ԭ�ĳ������Ӽ���������
% ԭ�����ӣ�https://blog.csdn.net/qq_26565435/article/details/94657852