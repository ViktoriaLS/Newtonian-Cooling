%REVISION (12/28/24): LOAD DATA FROM EXCEL
M = readmatrix("temp_data.xlsx");
tColumn = M(:,1);
yColumn = M(:,2);
xColumn = M(:,3);
teColumn = M(:,4);
TColumn = M(:,5);

t = tColumn(52:67);
y = yColumn(52:67);
x = xColumn(52:67);
te = teColumn(41:52);
Te = TColumn(41:52);

%Initialize variables
num_elements = numel(Te);
t_l = create_t_l(t, num_elements);
t_g = create_t_g(t, num_elements);

y_l = interp1(t, y, t_l, 'linear'); 
y_g = interp1(t, y, t_g, 'linear');

r = zeros(1, 1000);
s = zeros(1, 1000);
resultR = zeros(1, 1000);
resultS = zeros(1, 1000);
fixedS = 0.0042;
fixedR = 0.02162;

% Call functions
r = ValueTolerance(r, 0.05, 0.0001);
s = ValueTolerance(s, 0.05, 0.0001);
resultR = relError_StaticS(r, fixedS, resultR, te, Te, t_l, t_g, y_l, y_g, x);
resultS = relError_StaticR(fixedR, s, resultS, te, Te, t_l, t_g, y_l, y_g, x);

%REVISION (12/28/24): AUTO FIND MIN VALUES
[minR,minDimR] = min(resultR, [], 'all');
[minS,minDimS] = min(resultS, [], 'all');

% Display results
disp('Initial Conditions are:');
disp(['T = ', num2str(Te(1))]);
disp(['Fixed r = ', num2str(fixedR)]);
disp(['Fixed s = ', num2str(fixedS)]);
disp(' ');
disp(['Minimum Relative Error (with fixed s): ', num2str(resultR(minDimR)), ' with an r value of: ', num2str(r(minDimR))]);
disp(['Minimum Relative Error (with fixed r): ', num2str(resultS(minDimS)), ' with an s value of: ', num2str(s(minDimS))]);

% Function definitions
function r = ValueTolerance(r, initial, changeBy)
    length = numel(r);
    middle = floor(length / 2);
    r(middle) = initial;
    for i = middle + 1:length
        r(i) = r(i-1) + changeBy;
    end
    for i = middle - 1:-1:1
        r(i) = r(i+1) - changeBy;
    end
end
%REVISION (12/28/24): MULTIPLE X VALUES
function rExit = relError_StaticS(r, s, rExit, te, Te, t_l, t_g, y_l, y_g, x)
    m = zeros(1, numel(Te));
    y1 = zeros(1, numel(Te));
    error_array = zeros(numel(x), numel(Te)); % Adjust for multiple x values
    
    for i = 1:numel(Te)
        m(i) = (y_g(i) - y_l(i)) / (t_g(i) - t_l(i));
        y1(i) = y_l(i) + m(i) * (te(i) - t_l(i));
    end
    
    for j = 1:numel(x) % Loop through each x value
        T = zeros(1, numel(Te)); % Reset T for each x value
        T(1) = Te(1);
        for loop = 1:numel(r)
            for i = 1:numel(Te)-1
                T(i + 1) = T(i) + r(loop) * (te(i + 1) - te(i)) * (x(j) - T(i)) - s * (te(i + 1) - te(i)) * (T(i) - y1(i));
            end
            
            for k = 1:numel(T)
                error_array(j, k) = abs(T(k) - Te(k));
            end
            
            error_sum = sum(error_array(j, :) .^ 2);
            error_nrm = sqrt(error_sum);
            
            Te_sum = sum(Te .^ 2);
            Te_nrm = sqrt(Te_sum);
            
            rExit(loop) = error_nrm / Te_nrm;
        end
    end
end

%REVISION (12/28/24): MULTIPLE X VALUES
function rExit = relError_StaticR(r, s, rExit, te, Te, t_l, t_g, y_l, y_g, x)
    m = zeros(1, numel(Te));
    y1 = zeros(1, numel(Te));
    error_array = zeros(numel(x), numel(Te)); % Adjust for multiple x values
    
    for i = 1:numel(Te)
        m(i) = (y_g(i) - y_l(i)) / (t_g(i) - t_l(i));
        y1(i) = y_l(i) + m(i) * (te(i) - t_l(i));
    end
    
    for j = 1:numel(x) % Loop through each x value
        T = zeros(1, numel(Te)); % Reset T for each x value
        T(1) = Te(1);
        for loop = 1:numel(s)
            for i = 1:numel(Te)-1
                T(i + 1) = T(i) + r * (te(i + 1) - te(i)) * (x(j) - T(i)) - s(loop) * (te(i + 1) - te(i)) * (T(i) - y1(i));
            end
            
            for k = 1:numel(T)
                error_array(j, k) = abs(T(k) - Te(k));
            end
            
            error_sum = sum(error_array(j, :) .^ 2);
            error_nrm = sqrt(error_sum);
            
            Te_sum = sum(Te .^ 2);
            Te_nrm = sqrt(Te_sum);
            
            rExit(loop) = error_nrm / Te_nrm;
        end
    end
end

function t_l = create_t_l(t, num_elements)
    % Calculate the step size based on desired number of elements
    step = floor(length(t) / num_elements);
    
    % Generate indices based on the step size
    indices_to_keep = 1:step:length(t);
    
    % Ensure the exact number of elements required
    t_l = t(indices_to_keep);
    
    % If t_l has more elements than needed, trim it
    if length(t_l) > num_elements
        t_l = t_l(1:num_elements);
    end
end

function t_g = create_t_g(t, num_elements)
    % Calculate the step size based on desired number of elements
    step = floor(length(t) / num_elements);
    
    % Generate indices by starting from the second element
    indices_to_keep = 2:step:length(t);
    
    % Ensure the exact number of elements required
    t_g = t(indices_to_keep);
    
    % If t_g has more elements than needed, trim it
    if length(t_g) > num_elements
        t_g = t_g(1:num_elements);
    end
end
