function makeAccelerometerPlots(accelData, titles, makePowerPlot, makePhasePlot)
    function userAccClean = cleanData(timestampsDesired, timestampsOrig, userAcc)
        cleanInds = ~isnan(userAcc);
        userAccClean = interp1(timestampsOrig(cleanInds), userAcc(cleanInds), timestampsDesired);
    end
    function make3PanePlot(xs, plotData, plotTitles, plotXlabel, plotYlabel, xLimits)
        f = figure;
        if nargin < 6
            xLimits = [];
        end
        
        p1 = subplot(131);
        plot(xs, plotData(:,1))
        xlabel(plotXlabel);
        ylabel(plotYlabel);
        if ~isempty(xLimits)
            xlim(xLimits);
        end
        title(plotTitles{1});
        
        p2 = subplot(132);
        plot(xs, plotData(:,2));
        xlabel(plotXlabel);
        ylabel(plotYlabel);
        title(plotTitles{2});
        if ~isempty(xLimits)
            xlim(xLimits);
        end
        
        p3 = subplot(133);
        plot(xs, plotData(:,3));
        xlabel(plotXlabel);
        ylabel(plotYlabel);
        title(plotTitles{3})
        if ~isempty(xLimits)
            xlim(xLimits);
        end
        linkaxes([p1, p2, p3]);
    end
if nargin < 2 || isempty(titles)
    titles = {'x-axis','y-axis','z-axis'};
end
if nargin < 3
    makePowerPlot = false;
end
if nargin < 4
    makePhasePlot = false;
end

timestampsDesired = linspace(accelData(1,1), accelData(end,1), size(accelData,1));
sampleRate = 1/(timestampsDesired(2) - timestampsDesired(1));

% the first column is the clock
accX = cleanData(timestampsDesired, accelData(:,1), accelData(:,2));
accY = cleanData(timestampsDesired, accelData(:,1), accelData(:,3));
accZ = cleanData(timestampsDesired, accelData(:,1), accelData(:,4));

make3PanePlot(timestampsDesired - timestampsDesired(1),...
    [accX' accY' accZ'],...
    titles,...
    'Time (s)',...
    'Angular Velocity (rad/s)');
if makePowerPlot
    freqs = linspace(-length(accX)/2,length(accX)/2-1+mod(length(accX),2),length(accX))*(sampleRate/length(accX));
    powerAccel = [1/length(accX)*fftshift(abs(fft(accX)))'...
        1/length(accY)*fftshift(abs(fft(accY)))'...
        1/length(accZ)*fftshift(abs(fft(accZ)))'];
    make3PanePlot(freqs, powerAccel, titles, 'Frequency (Hz)', 'Power Spectrum of Acceleration', [-5 5]);
end

if makePhasePlot
    freqs = linspace(-length(accX)/2,length(accX)/2-1+mod(length(accX),2),length(accX))*(sampleRate/length(accX));
    phaseAccel = [fftshift(angle(fft(accX)))'...
                  fftshift(angle(fft(accY)))'...
                  fftshift(angle(fft(accZ)))'];
    make3PanePlot(freqs, phaseAccel, titles, 'Frequency (Hz)', 'Phase Spectrum of Acceleration', [-5 5]);
end

end