function aws = solves(theta1, theta2, theta3)
    %solve - �˶�ѧ����
    %
    % Syntax: aws = solve(theta1, theta2, theta3)
    % theta1 - �����ؽڽ�
    % theta2 - ��۹ؽڽ�
    % theta3 - С�۹ؽڽ�
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
    a3 = 143
    % ����Ťת��
    alpha0 = 0;
    alpha1 = pi/2;
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
    T01 = matrix(alpha0, a0, d1, theta1)
    T12 = matrix(alpha1, a1, d2, theta2)
    T23 = matrix(alpha2, a2, d3, theta3)
    T34 = matrix(alpha3, a3, d4, theta4)
    T03 = T01 * T12 * T23;
    T04 = T01 * T12 * T23 * T34;

    % ��̬ŷ����X-Y-Z
    beta = 180 / pi * atan2(-T04(3,1), sqrt(T04(1, 1) * T04(1, 1) + T04(2, 1) * T04(2, 1)));
    alpha = 180 / pi * atan2(T04(2, 1) / cos(beta), T04(1, 1) / cos(beta));
    gama = 180 / pi * atan2(T04(3, 2) / cos(beta), T04(3, 3) / cos(beta));

    if beta == 90
        alpha = 0;
        gama = 180 / pi * atan2(T04(1, 2), T04(2, 2));
    end
    if beta == -90
        alpha = 0;
        gama = -180 / pi * atan2(T04(1, 2), T04(2, 2));
    end

    % ������
    aws = [(T04(1:3, 4))' gama beta alpha] 
    disp("����Ϊ��")
    loc = T04(1:3, 4)
    disp("ŷ����Ϊ��")
    ori = [gama beta alpha]
    disp("�õ�����ڻ�����������ϵ�µ���α任����(������)��")
    R = [cos(theta1) sin(theta1) 0;
         -sin(theta1) cos(theta1) 0;
         0 0 1
        ];
    TT = T04;
    % TT(1:3, 1:3) = R;
    TT

    % % test
    % a = [a0 a1 a2 a3];
    % T = {T01, T12, T23, T34};
    % draw(a, T);



    % ��ͼ
    link1 = [a1; 0; 0]; % ��1������ϵ1�µı��
    link2 = [a2; 0; 0]; % ��2������ϵ2�µı��
    link3 = [a3; 0; 0]; % ��3������ϵ3�µı��
    d_1 = T01(1:3, 1:3) * link1; % ��1����������ϵ�µı��
    d_2 = d_1 + T01(1:3, 1:3) * T12(1:3, 1:3) * link2; % ��2����������ϵ�µı��
    d_3 = d_2 + T01(1:3, 1:3) * T12(1:3, 1:3) * T23(1:3, 1:3) * link3; % ��3����������ϵ�µı��

    hold on;
    grid on;
    view(45, 30);
    %axis([-200 200], [-200 200], [-200 200]);
    axis equal;
    set(get(gca, 'XLabel'), 'String', 'x��');
    set(get(gca, 'YLabel'), 'String', 'y��');
    set(get(gca, 'ZLabel'), 'String', 'z��');
    % axis([-100 100], [-100 100], [-200, 200]);
    plot3(0, 0, 0, 'o');
    plot3(d_1(1), d_1(2), d_1(3), 'o');
    plot3(d_2(1), d_2(2), d_2(3), 'o');
    plot3(d_3(1), d_3(2), d_3(3), 'o');
    % ����õ�ռ�����
    cod = ['(' num2str(d_3(1)) ',' num2str(d_3(2)) ',' num2str(d_3(3)) ')'];
    text(d_3(1), d_3(2), d_3(3), cod);
    % ����õ�ռ�����ϵ
    plot3([d_3(1) (d_3(1) + 100 * TT(1, 1))], [d_3(2) (d_3(2) + 100 * TT(2, 1))], [d_3(3) (d_3(3) + 100 * TT(3, 1))], 'LineStyle', '-.', 'LineWidth', 1, 'color', 'r'); % ��ɫ�㻮�߱�ʾx�᷽��
    plot3([d_3(1) (d_3(1) + 100 * TT(1, 2))], [d_3(2) (d_3(2) + 100 * TT(2, 2))], [d_3(3) (d_3(3) + 100 * TT(3, 2))], 'LineStyle', '-.', 'LineWidth', 1, 'color', 'g'); % ��ɫ�㻮�߱�ʾy�᷽��
    plot3([d_3(1) (d_3(1) + 100 * TT(1, 3))], [d_3(2) (d_3(2) + 100 * TT(2, 3))], [d_3(3) (d_3(3) + 100 * TT(3, 3))], 'LineStyle', '-.', 'LineWidth', 1, 'color', 'b'); % ��ɫ�㻮�߱�ʾz�᷽��

    plot3([0 d_1(1)], [0 d_1(2)], [0 d_1(3)], 'LineWidth', 3, 'color', 'r'); % ��������1�ú�ɫ��ʾ
    plot3([d_1(1) d_2(1)], [d_1(2) d_2(2)], [d_1(3) d_2(3)], 'LineWidth', 3, 'color', 'b'); % ����ۣ�����2����ɫ��ʾ
    plot3([d_2(1) d_3(1)], [d_2(2) d_3(2)], [d_2(3) d_3(3)], 'LineWidth', 3, 'color', 'g'); % ��С�ۣ�����3����ɫ��ʾ

end
