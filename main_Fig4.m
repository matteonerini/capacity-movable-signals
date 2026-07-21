clear; clc;
rng(3);

% Parameters
Ns = [2,4,8];               % Number of antennas at the TX
K = 2;                      % Number of RXs
SNR_dBs = -10:5:10;         % SNR [dB]
nMonte = 1e4;               % Number of Monte Carlo simulations
PT = 1;                     % Transmit power (the sum rate is independent of PT and just depend on SNR)
s2 = PT ./ db2pow(SNR_dBs); % Noise power
fA = 10e9;                  % Frequency fA [Hz]
c = 299792458;              % Speed of light [m/s]
dA = c / fA;                % Antenna spacing [m]

Ls = 1:20;
f_min = fA;
f_max = f_min * 1.8;

SR_fix = nan(nMonte,length(SNR_dBs),length(Ns));
SR_mov_unc = nan(nMonte,length(SNR_dBs),length(Ns));
SR_mov_con = nan(nMonte,length(SNR_dBs),length(Ns));
for iMonte = 1:nMonte
    for iN = 1:length(Ns)
        N = Ns(iN);
        
        % Channel with fixed signals
        thetas = rand(K,1) * pi - pi/2;
        H_fix = exp(-1i*2*pi*(10 - ((1:N) - (N+1)/2) * dA .* sin(thetas)) * f_min / c);

        % Channel with movable signals (unconstrained)
        %f_mov_unc = fA / (N * abs(sin(thetas(1))-sin(thetas(2))));
        %H_mov_unc = exp(-1i*2*pi*(10 - ((1:N) - (N+1)/2) * dA .* sin(thetas)) * f_mov_unc / c);

        % Channel with movable signals (constrained)
        beta = pi*dA*(sin(thetas(1))-sin(thetas(2))) / c;
        Ls_filtered = Ls(mod(Ls, N) ~= 0);
        f_stars = Ls_filtered * fA / (N * abs(sin(thetas(1))-sin(thetas(2))));
        test = (f_stars >= f_min) & (f_stars <= f_max);
        idx = find(test, 1);
        if ~isempty(idx)
            f_mov_con = f_stars(idx);
        elseif abs(sin(N*f_min*beta)/sin(f_min*beta)) <= abs(sin(N*f_max*beta)/sin(f_max*beta))
            f_mov_con = f_min;
        else
            f_mov_con = f_max;
        end
        H_mov_con = exp(-1i*2*pi*(10 - ((1:N) - (N+1)/2) * dA .* sin(thetas)) * f_mov_con / c);

        for iSNR = 1:length(SNR_dBs)

            % Fixed signals with R-ZFBF
            F_fix = H_fix'/(H_fix*H_fix'+K/db2pow(SNR_dBs(iSNR))*eye(K));
            W_fix = sqrt(PT/K) * F_fix ./ vecnorm(F_fix);
            SR_fix(iMonte,iSNR,iN) = func_sum_rate(W_fix, H_fix, s2(iSNR));

            % Movable signals (unconstrained) with MBF
            %W_mov_unc = sqrt(PT/K) * H_mov_unc' ./ vecnorm(H_mov_unc');
            %SR_mov_unc(iMonte,iSNR,iN) = func_sum_rate(W_mov_unc, H_mov_unc, s2(iSNR));

            % Movable signals (constrained) with R-ZFBF
            F_mov_con = H_mov_con'/(H_mov_con*H_mov_con'+K/db2pow(SNR_dBs(iSNR))*eye(K));
            W_mov_con = sqrt(PT/K) * F_mov_con ./ vecnorm(F_mov_con);
            SR_mov_con(iMonte,iSNR,iN) = func_sum_rate(W_mov_con, H_mov_con, s2(iSNR));
        end
    end
end

SR_fix_mean = squeeze(mean(SR_fix));
SR_mov_unc_mean = squeeze(mean(SR_mov_unc));
SR_mov_con_mean = squeeze(mean(SR_mov_con));
SR_UB = K * log2(1 + db2pow(SNR_dBs)'.*Ns/K);

%% Plot
figure('DefaultAxesFontSize',12);
LineW = 1.8; MarkS = 8;
plot(SNR_dBs,SR_UB(:,3),'-p','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','UB'); % 'color','#00395e',
hold on;
plot(SNR_dBs,SR_UB(:,2),'-p','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','UB'); % 'color','#6c290d',
plot(SNR_dBs,SR_UB(:,1),'-p','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','UB'); % 'color','#7c5b0a',
%set(gca,'ColorOrderIndex',1)
%plot(SNR_dBs,SR_mov_unc_mean(:,3),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. (unc.)');
%plot(SNR_dBs,SR_mov_unc_mean(:,2),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. (unc.)');
%plot(SNR_dBs,SR_mov_unc_mean(:,1),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. (unc.)');
set(gca,'ColorOrderIndex',1)
plot(SNR_dBs,SR_mov_con_mean(:,3),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. Sig.');
plot(SNR_dBs,SR_mov_con_mean(:,2),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. Sig.');
plot(SNR_dBs,SR_mov_con_mean(:,1),'--d','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Mov. Sig.');
set(gca,'ColorOrderIndex',1)
plot(SNR_dBs,SR_fix_mean(:,3),':o','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Fix. Sig.,{\it N = 8}');
plot(SNR_dBs,SR_fix_mean(:,2),':o','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Fix. Sig.,{\it N = 4}');
plot(SNR_dBs,SR_fix_mean(:,1),':o','linewidth',LineW,'MarkerSize',MarkS,'DisplayName','Fix. Sig.,{\it N = 2}');
grid on;
set(gca,'GridLineStyle',':','GridAlpha',0.5,'LineWidth',1.2);
xlabel('SNR [dB]');
ylabel('Sum rate [bps/Hz]');
ylim([0,11])
legend('Location','northwest','NumColumns',4,'FontSize',12);
set(gcf, 'Color', [1,1,1]);
set(gca, 'LineWidth',1.5);

%% Functions
function SR = func_sum_rate(W, H, s2)
    alpha = sum(abs(H * W).^2,2);
    pow = abs(diag(H * W)).^2;
    SINR = pow ./ (alpha - pow + s2);
    SR = sum(log2(1 + SINR));
end