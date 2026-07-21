clear; clc;

N = [2,4,8];
SNR = 10;
P1 = linspace(0,SNR)';
R1 = log2(1 + P1.*N);
R2 = log2(1 + (SNR-P1).*N);

figure('DefaultAxesFontSize',12);
LineW = 1.8; MarkS = 8;
hold on;
plot(R1(:,3),R2(:,3),'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 8}');
plot(R1(:,2),R2(:,2),'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 4}');
plot(R1(:,1),R2(:,1),'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 2}');
axis equal; grid on; box on;
set(gca,'GridLineStyle',':','GridAlpha',0.5,'LineWidth',1.2);
legend('Location','southwest','NumColumns',1,'FontSize',12);
xlabel('Rate user 1 [bps/Hz]');
ylabel('Rate user 2 [bps/Hz]');
xlim([0,7]);
ylim([0,7]);
set(gcf, 'Color', [1,1,1]);
set(gca, 'LineWidth',1.5);