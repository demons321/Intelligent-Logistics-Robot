function angle = FourDegree_InverseKinematics(px, py, pz)
    % FourDegree_InverseKinematics - �˶�ѧ���
    %
    % ���뵥λ��Ϊmm
    % Syntax: angle = myFuFourDegree_InverseKinematicsn(px, py, pz)
    % px   - Ŀ��ռ�����x
    % py   - Ŀ��ռ�����y
    % pz   - Ŀ��ռ�����z
    % 
    % angle- ����Ƕȼ�


    % ���幤��
    syms nx ny nz ox oy oz ax ay az
    nx = px / sqrt(px^2 + py^2)
    ny = py /sqrt(px^2 + py^2)
    nz = 0;
    ox = -py /sqrt(px^2 + py^2);
    oy = px / sqrt(px^2 + py^2);
    oz = 0;
    ax = 0;
    ay = 0;
    az = 1;
    % ����ؽڽ�
    syms theta1 theta2 theta3 theta4

    % ��е�۹��в���
    % ����ƫ��
    d1 = 0;
    d2 = 0;
    d3 = 0;
    d4 = 0; 

    % ���˳���
    a0 = 0;
    a1 = 10.5;
    a2 = 104;
    a3 = 88.52;

    % ����Ťת��
    alpha0 = 0;
    alpha1 = 90;
    alpha2 = 0;
    alpha3 = 0;

    % D-H����
    % i     alpha(i-1)     a(i-1)   d(i)    theta(i)
    % 1     0              0        0       theta1
    % 2     pi/2           10.5     0       90 - theta2
    % 3     0              104      0       -theta3
    % 4     0              88.52    0       -theta4

    % ������α任����
    T01 = modify_transfer(alpha0, a0, d1, -theta1);
    T12 = modify_transfer(alpha1, a1, d2, 90 - theta2);
    T23 = modify_transfer(alpha2, a2, d3, -theta3);
    T34 = modify_transfer(alpha3, a3, d4, -theta4);
    T04 = T01 * T12 * T23 * T34;
    TBW = T04; % ��е����ؽ�����ڻ�������̬����
    % ���㹤����Ի�����̬
    syms a4 d5 % a4��ʾx���ϵ�ƫ����,d5��ʾz���ƫ����
    a4 = 138;
    d5 = -35;
    TWT = modify_transfer(-90, a4, d5, 0) % ��������ϵ�����ؽ�
    TBT = TBW * TWT; % ��������ϵ��Ի���
    simplify(TBT)

    Ttool = [nx ox ax px;
             ny oy ay py;
             nz oz az pz;
             0  0  0  1];

    T1 = inv(T01) * Ttool;
    T2 = T12 * T23 * T34 * TWT;
    L = simplify(T1);
    R = simplify(T2);

    % theta1���   (2,1)-> ny * c1 + nx * s1 = 0
    theta1 = atand(-ny / nx)
    % theta234  (3,1)-> c234  = 0
    theta234 = 90;
    % (1,4)(3,4)  
    % L(1, 4) = px * cosd(theta1) - a0 * cosd(theta1) - py * sind(theta1)
    % L(3, 4) = pz
    eqn1 = (px * cosd(theta1) - a0 * cosd(theta1) - py * sind(theta1)) + d5 * cosd(theta234) - a4 * sind(theta234) - a1
    eqn2 = (pz) - a4 * cosd(theta234) - d5 * sind(theta234)
    % theta3���
    % theta234 
    condition1 = (eqn1^2 + eqn2^2 - a2^2 - a3^2) / (2 * a2 * a3);
    if condition1 <= 1 && condition1 >= -1
        theta3_1 = acosd(condition1);
        theta3_2 = -theta3_1;
        % theta2���
        % theta3 = theta3_1ʱ
        ry = a3 * sind(theta3_1);
        rx = a3 * cosd(theta3_1) + a2;
        r = sqrt(rx^2 + ry^2);
        theta2_1 = atan2d((eqn1 / r), sqrt(1 - (eqn1 / r)^2)) - atan2d(ry, rx);
        theta2_2 = atan2d((eqn1 / r), -sqrt(1 - (eqn1 / r)^2)) - atan2d(ry, rx);
        % theta3 = theta3_2ʱ(�˽���)
        ry = a3 * sind(theta3_2);
        rx = a3 * cosd(theta3_2) + a2;
        r = sqrt(rx^2 + ry^2);
        theta2_3 = atan2d((eqn1 / r), sqrt(1 - (eqn1 / r)^2)) - atan2d(ry, rx);
        theta2_4 = atan2d((eqn1 / r), -sqrt(1 - (eqn1 / r)^2)) - atan2d(ry, rx);
        % theta4���
        % theta234 = theta234_1ʱ����theta3 = theta3_1ʱ����theta2 = theta2_1ʱ
        theta4_1 = theta234 - theta3_1 - theta2_1;
        % theta234 = theta234_1ʱ����theta3 = theta3_1ʱ����theta2 = theta2_2ʱ
        theta4_2 = theta234 - theta3_1 - theta2_2;
        % theta234 = theta234_1ʱ����theta3 = theta3_2ʱ����theta2 = theta2_3ʱ
        theta4_3 = theta234 - theta3_2 - theta2_3;
        % theta234 = theta234_1ʱ����theta3 = theta3_2ʱ����theta2 = theta2_4ʱ
        theta4_4 = theta234 - theta3_2 - theta2_4;
    else
        disp('����ץȡ��Χ');
    end
    % ����⼯
    angle = [
      theta1 theta2_1 theta3_1 theta4_1;
    %   theta1 theta2_2 theta3_1 theta4_2;
      theta1 theta2_3 theta3_2 theta4_3;
    %   theta1 theta2_4 theta3_2 theta4_4;
    ]
    FourDegree_DirectKinematics(angle(1,1), angle(1,2), angle(1,3), angle(1,4)) % ȡ��һ��
    % FourDegree_DirectKinematics(ans(2,1), ans(2,2), ans(2,3), ans(2,4))

end


