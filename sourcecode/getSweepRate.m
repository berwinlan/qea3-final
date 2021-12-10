function res = getSweepRate(datafile)
% % datafile: a string .mat file containing acceleration, orientation, and angular
% % velocity data, with sample rate 100 Hz

[MotionData] = ParseMatlabApp(datafile);

% Visualize accelerometer data
makeAccelerometerPlots([MotionData.t_AngVel,MotionData.AngVel])

% FFT of angular velocity
fs = 100;           % Hz
x_angvel = MotionData.AngVel(:,1);
y_angvel = MotionData.AngVel(:,2);
z_angvel = MotionData.AngVel(:,3);

angvels = [x_angvel, y_angvel, z_angvel];
labels = ["x", "y", "z"];
sweeps = zeros(3,1);

for i = 1:3
    figure();
    angvel = angvels(:,i);
    primary_freq = make_freq_plot(angvel, fs);
    sweeps_per_min = primary_freq * 60;
    sweeps(i) = sweeps_per_min;
    title(labels(:,i) + "\_angvel @ predicted rate of " + sweeps_per_min + " sweeps/min");
end

res = sweeps;