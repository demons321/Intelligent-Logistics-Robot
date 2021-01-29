function position = ThreeDegree_DirectKinematics(theta1, theta2, theta3)
    %solve - �˶�ѧ����
    %
    % s���뵥λ��Ϊ�Ƕ���
    % Syntax: aws = solve(theta1, theta2, theta3, theta4, theta5) 
    % theta1 - �����ؽڽ�
    % theta2 - ��1�ؽڽ�
    % theta3 - ��2�ؽڽ�
    %
    % ����Ϊ�����ؽڽ�
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
    % ���˳���
    a0 = 0;
    a1 = 14.8366;
    a2 = 150;
    a3 = 143;
    % ����Ťת��
    alpha0 = 0;
    alpha1 = 90;
    alpha2 = 0;
    alpha3 = 0;
    % D-H����
    % i     alpha(i-1)     a(i-1)   d(i)    theta(i)
    % 1     0              0        0       theta1
    % 2     pi/2           14.8366  0       theta2
    % 3     0              150      0       theta3
    % 4     0              143      0       theta4(= -theta2 - theta3)

    theta4 = -(theta2 + theta3);

    % ������α任����
    T01 = modify_transfer(alpha0, a0, d1, theta1);
    T12 = modify_transfer(alpha1, a1, d2, theta2);
    T23 = modify_transfer(alpha2, a2, d3, theta3);
    T34 = modify_transfer(alpha3, a3, d4, theta4);
    T04 = T01 * T12 * T23 * T34;

    % ������
    TT = T04

    % ��ͼ
    a = [a0 a1 a2 a3];
    T = {T01, T12, T23, TT};
    draw(a, T);
end