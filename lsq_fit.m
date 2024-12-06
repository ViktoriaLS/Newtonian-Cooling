clc
% Time and Temperature data
t = [1358.88; 1373.33; 1387.85; 1402.35; 1416.83; 1431.32; 1445.82; 1460.30;
    1474.80; 1489.27; 1503.73; 1518.25; 1532.75; 1547.23; 1561.73; 1576.20; 1590.70;
    1605.20];
T = [64.3; 64.3; 64.2; 64.1; 64; 63.9; 63.9; 63.9; 63.9; 63.8; 63.8; 63.8; 63.7; 63.7;
    63.7; 63.6; 63.5; 63.5];

% Scale time (subtract the mean)
t_mean = mean(t); % Mean of t
t_scaled = t - t_mean; % Centering

% Define the model function
modelFun = @(params, t) params(1) * exp(-params(2) * t) + params(3) * t + params(4);

% Initial guesses for the parameters [C, k, A, B]
initialGuess = [0.2, 0.025, 0, 10]; 

% Perform nonlinear curve fitting using lsqcurvefit
options = optimset('Display', 'off'); % Suppress output during fitting
paramsFit = lsqcurvefit(modelFun, initialGuess, t_scaled, T, [], [], options);

% Extract fitted parameters
C_fit = paramsFit(1);
k_fit = paramsFit(2);
A_fit = paramsFit(3);
B_fit = paramsFit(4);

% Display fitted parameters
fprintf('Fitted Parameters:\n');
fprintf('C = %.4f\n', C_fit);
fprintf('k = %.4f\n', k_fit);
fprintf('A = %.4f\n', A_fit);
fprintf('B = %.4f\n', B_fit);

% Generate fitted curve for visualization
T_fit = modelFun(paramsFit, t_scaled);

% Validation: Compute RMSE
rmse = sqrt(mean((T - T_fit).^2));
fprintf('RMSE: %.4f\n', rmse);

% Plot original data and fitted curve
figure(1)
plot(t, T, 'bo','LineWidth',3); hold on;
plot(t, T_fit, 'k-', 'LineWidth', 3, 'DisplayName', 'Fitted Curve');
xlabel('t, min');
ylabel('T, ^{o}F');
title('Data Fitting: Cavity Temperature vs Time');
%legend('Location', 'Best');
legend('observed','least squares fit')
grid on;

% Residual Analysis
residuals = T - T_fit;

figure(2);
plot(t, residuals, 'ko', 'LineWidth', 1.5);
xlabel('t, min');
ylabel('Residuals');
title('Residuals of the Fit');
grid on;
