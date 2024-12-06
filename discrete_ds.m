% Initialize variables
x = 65.8;
y = [53.2, 53.1, 53.1, 52.9, 52.9, 52.9, 52.9, 52.7, 52.7, 52.7, 52.7, 52.5, 52.5, 52.5, 52.5, 52];
t = [1481, 1492, 1503, 1514, 1526, 1537, 1548, 1559, 1571, 1582, 1593, 1604, 1616, 1627, 1638, 1649];
te = [1489.27, 1503.73, 1518.25, 1532.75, 1547.23, 1561.73, 1576.20, 1590.70, 1605.20, 1619.67, 1634.15, 1648.65];
Te = [63.8, 63.8, 63.8, 63.7, 63.7, 63.7, 63.6, 63.5, 63.5, 63.4, 63.4, 63.3];
t_l = [1481, 1503, 1514, 1526, 1537, 1559, 1571, 1582, 1604, 1616, 1627, 1638];
t_g = [1492, 1514, 1526, 1537, 1548, 1571, 1582, 1593, 1616, 1927, 1638, 1649];
y_l = [53.2, 53.1, 52.9, 52.9, 52.9, 52.7, 52.7, 52.7, 52.5, 52.5, 52.5, 52.5];
y_g = [53.1, 52.9, 52.9, 52.9, 52.9, 52.7, 52.7, 52.7, 52.5, 52.5, 52.5, 52.5];
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

% Display results
disp('Initial Conditions are:');
disp('T = 63.8');
disp(['Fixed r = ', num2str(fixedR)]);
disp(['Fixed s = ', num2str(fixedS)]);
disp(' ');
disp(['Minimum Relative Error (with fixed s): ', num2str(resultR(197)), ' with an r value of: ', num2str(r(197))]);
disp(['Minimum Relative Error (with fixed r): ', num2str(resultS(46)), ' with an s value of: ', num2str(s(46))]);

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

function rExit = relError_StaticS(r, s, rExit, te, Te, t_l, t_g, y_l, y_g, x)
    m = zeros(1, numel(Te));
    y1 = zeros(1, numel(Te));
    T = zeros(1, 12);
    error_array = zeros(1, numel(Te));
    
    for i = 1:numel(Te)
        m(i) = (y_g(i) - y_l(i)) / (t_g(i) - t_l(i));
        y1(i) = y_l(i) + m(i) * (te(i) - t_l(i));
    end
    
    T(1) = 63.8;
    loop = 1;
    
    while loop <= numel(r)
        for i = 1:11
            T(i + 1) = T(i) + r(loop) * (te(i + 1) - te(i)) * (x - T(i)) - s * (te(i + 1) - te(i)) * (T(i) - y1(i));
        end
        
        for k = 1:numel(T)
            error_array(k) = abs(T(k) - Te(k));
        end
        
        error_array = error_array .^ 2;
        error_sum = sum(error_array);
        error_nrm = sqrt(error_sum);
        
        Te_squared = Te .^ 2;
        Te_sum = sum(Te_squared);
        Te_nrm = sqrt(Te_sum);
        
        rExit(loop) = error_nrm / Te_nrm;
        loop = loop + 1;
    end
end

function rExit = relError_StaticR(r, s, rExit, te, Te, t_l, t_g, y_l, y_g, x)
    m = zeros(1, numel(Te));
    y1 = zeros(1, numel(Te));
    T = zeros(1, 12);
    error_array = zeros(1, numel(Te));
    
    for i = 1:numel(Te)
        m(i) = (y_g(i) - y_l(i)) / (t_g(i) - t_l(i));
        y1(i) = y_l(i) + m(i) * (te(i) - t_l(i));
    end
    
    T(1) = 63.8;
    loop = 1;
    
    while loop <= numel(s)
        for i = 1:11
            T(i + 1) = T(i) + r * (te(i + 1) - te(i)) * (x - T(i)) - s(loop) * (te(i + 1) - te(i)) * (T(i) - y1(i));
        end
        
        for k = 1:numel(T)
            error_array(k) = abs(T(k) - Te(k));
        end
        
        error_array = error_array .^ 2;
        error_sum = sum(error_array);
        error_nrm = sqrt(error_sum);
        
        Te_squared = Te .^ 2;
        Te_sum = sum(Te_squared);
        Te_nrm = sqrt(Te_sum);
        
        rExit(loop) = error_nrm / Te_nrm;
        loop = loop + 1;
    end
end