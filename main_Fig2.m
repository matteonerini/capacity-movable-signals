clear; clc;

N = [2,4,8];
SNR = 10;
R = log2(1 + SNR*N);

figure('DefaultAxesFontSize',12);
LineW = 1.8; MarkS = 8;
hold on;
plot([0,R(3)],[R(3),R(3)],'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 8}');
plot([0,R(2)],[R(2),R(2)],'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 4}');
plot([0,R(1)],[R(1),R(1)],'-','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','{\itN = 2}');
set(gca,'ColorOrderIndex',1)
plot([R(3),R(3)],[0,R(3)],'-','linewidth',LineW,'MarkerSize',MarkS,'HandleVisibility','off');
plot([R(2),R(2)],[0,R(2)],'-','linewidth',LineW,'MarkerSize',MarkS,'HandleVisibility','off');
plot([R(1),R(1)],[0,R(1)],'-','linewidth',LineW,'MarkerSize',MarkS,'HandleVisibility','off');
axis equal; grid on; box on;
set(gca,'GridLineStyle',':','GridAlpha',0.5,'LineWidth',1.2);
legend('Location','southwest','NumColumns',1,'FontSize',12);
xlabel('Rate user 1 [bps/Hz]');
ylabel('Rate user 2 [bps/Hz]');
xlim([0,7]);
ylim([0,7]);
set(gcf, 'Color', [1,1,1]);
set(gca, 'LineWidth',1.5);