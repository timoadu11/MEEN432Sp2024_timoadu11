out = sim("MEEN432P4.slx","Stoptime",string(3600));
X = out.X.signals.values;
Y = out.Y.signals.values;
t = out.X.time;
path.width = 15;
path.l_st = 900;
path.radius = 200;
%out = out.SOC.signals.values;
simout = sim("MEEN432P4.slx",'StopTime','3600');

stats = raceStat(X,Y,t,path,simout);

disp(stats)


% Define track parameters
radius = 200;           % Radius of curved sections
straight_length = 900;  % Length of straightaway sections
track_width = 15;       % Width of the track

% Generate curved sections
theta1 = linspace(3*pi/2, pi/2, 1000);  % First curved section (270 to 90 degrees)
x1 = radius * cos(theta1);
y1 = radius * sin(theta1);

theta2 = linspace(-pi/2, -3*pi/2, 1000);  % Second curved section (90 to 270 degrees)
x2 = -radius * cos(theta2) + straight_length;
y2 = -radius * sin(theta2);

% Generate straightaway sections
x3 = linspace(0,straight_length, 1000);  % First straightaway
y3 = -200*ones(size(x3));

x4 = linspace(straight_length,0, 1000);  % Second straightaway
y4 = 200*ones(size(x4));

% Combine all sections
x = [x3,fliplr(x2), (x4), fliplr(x1)];
y = [y3,fliplr(y2), (y4), fliplr(y1)];
x = x - x(1);
y = y - y(1);

figure;
hold on
set(gca, 'Color', [.2, .48, .32]);
plot(x, y, 'LineWidth', 8,'Color',[ 0 0 0]);
xlim([-300, 1200]); 
ylim([-75, 500]);
hold off
title('Race Track');
xlabel('X-axis(m)');
ylabel('Y-axis(m)');
axis equal;  


vehicle_length = 50;  
vehicle_width = 20;  
x_vehicle = [0, vehicle_length, vehicle_length, 0, 0];
y_vehicle = [-vehicle_width/2, -vehicle_width/2, vehicle_width/2, vehicle_width/2, -vehicle_width/2];
initial_orientation = 0;
vehicle_patch = patch('XData', x_vehicle, 'YData', y_vehicle, 'FaceColor', 'b', 'EdgeColor', 'c');

for i = 2:length(X)
    set(vehicle_patch, 'XData', x_vehicle + X(i), 'YData', y_vehicle + Y(i));
    if i > 2
        orientation = atan2(Y(i) - Y(i-1), X(i) - X(i-1));
    else
        orientation = atan2(Y(2) - Y(1), X(2) - X(1));
    end
    rotate(vehicle_patch, [0, 0, 1], rad2deg(orientation - initial_orientation), [X(i), Y(i), 0]);
    pause(0.001); 
end
