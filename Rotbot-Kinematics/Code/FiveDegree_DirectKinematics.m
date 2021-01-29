function position = FiveDegree_DirectKinematics(theta1, theta2, theta3, theta4, theta5)
    %solve - �˶�ѧ����
    %
    % Syntax: aws = solve(theta1, theta2, theta3, theta4, theta5)
    % theta1 - �����ؽڽ�
    % theta2 - ��1�ؽڽ�
    % theta3 - ��2�ؽڽ�
    % theta4 - ��3�ؽڽ�
    % theta5 - ��ؽڽ�
    %
    % ����Ϊ����ؽڽ�
    % ���Ϊ�ռ�����
    % �����λ0�㣬���ҷ�Χ-90��~90��


    % clear;
    % clc;

    % ��е�۹��в���
    % ����ƫ��
    d1 = 0;
    d2 = 0;
    d3 = 0;
    d4 = 0; 
    d5 = 65.1509;
    % ���˳���
    a0 = 0;
    a1 = 10;
    a2 = 104;
    a3 = 88.52;
    a4 = 0;
    % ����Ťת��
    alpha0 = 0;
    alpha1 = 90;
    alpha2 = 0;
    alpha3 = 0;
    alpha4 = 90;
    % D-H����
    % i     alpha(i-1)     a(i-1)   d(i)    theta(i)
    % 1     0              0        0       theta1
    % 2     pi/2          10       0       theta2
    % 3     0              104      0       theta3
    % 4     0              88.52    0       theta4
    % 5     pi/2           0        65.1509 theta5

    % ������α任����
    T01 = modify_transfer(alpha0, a0, d1, theta1);
    T12 = modify_transfer(alpha1, a1, d2, theta2);
    T23 = modify_transfer(alpha2, a2, d3, theta3);
    T34 = modify_transfer(alpha3, a3, d4, theta4);
    T45 = modify_transfer(alpha4, a4, d5, theta5);
    T05 = T01 * T12 * T23 * T34 * T45;

    a = [a0 a1 a2 a3 d5];
    T = {T01, T12, T23, T34, T05};
    draw(a, T);

end