% Read data from an Excel file
filename = 'temp_data.xlsx'; % Replace with your file name
data = readtable(filename);

% Extract columns: assume t, x, y, T are in respective columns
t = data{:, 1}; % First column: time (t)
y = data{:, 2}; % Second column: internal temperature x
x = data{:, 3}; % Third column: external temperature y
t1 = data{:, 4}; % Fourth column: t1
T = data{:, 5}; % Fifth column: temperature in cavity T 

% Plot x vs t
plot(t, x, 'r:', 'LineWidth', 3);
xlabel('t, min', 'FontSize',14);
ylabel('Temperature, ^{o}F','FontSize',14);
hold on
grid on;

% Plot T vs t1
plot(t1, T, 'k', 'LineWidth', 3);

% Plot y vs t
plot(t, y, 'b--', 'LineWidth', 3);
legend('interior', 'cavity','exterior')
