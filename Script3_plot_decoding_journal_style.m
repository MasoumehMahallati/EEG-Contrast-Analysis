clc;
clear;
close all;
rng(42);   % get_sig_stats uses permutations internally - fix the seed so
           % results are identical every time you run this script.
%% Plot
tic;
load long_data1, load long_data2, load long_data3, load long_data4
load short_data1, load short_data2, load short_data3, load short_data4
alpha = 0.1;               % for cluster
q_fdr = 0.1;               % for FDR
minRun = 3;                % for cluster
nPerm = 1000;               % for cluster
%% _________________________ Late mask (Long ISI) __________________
baseline_long1 = long_data1(:,1:200);      %  baseline
baseline_long2 = long_data2(:,1:200);      %  baseline
baseline_long3 = long_data3(:,1:200);      %  baseline
baseline_long4 = long_data4(:,1:200);      %  baseline

statsLate1 = get_sig_stats(long_data1, baseline_long1, alpha, q_fdr, minRun, nPerm);
statsLate2 = get_sig_stats(long_data2, baseline_long2, alpha, q_fdr, minRun, nPerm);
statsLate3 = get_sig_stats(long_data3, baseline_long3, alpha, q_fdr, minRun, nPerm);
statsLate4 = get_sig_stats(long_data4, baseline_long4, alpha, q_fdr, minRun, nPerm);

%% _____________________ Early mask (Short ISI) _______________________
baseline_short1 = short_data1(:,1:200);      %  baseline
baseline_short2 = short_data2(:,1:200);      %  baseline
baseline_short3 = short_data3(:,1:200);      %  baseline
baseline_short4 = short_data4(:,1:200);      %  baseline

statsEarly1 = get_sig_stats(short_data1, baseline_short1, alpha, q_fdr, minRun, nPerm);
statsEarly2 = get_sig_stats(short_data2, baseline_short2, alpha, q_fdr, minRun, nPerm);
statsEarly3 = get_sig_stats(short_data3, baseline_short3, alpha, q_fdr, minRun, nPerm);
statsEarly4 = get_sig_stats(short_data4, baseline_short4, alpha, q_fdr, minRun, nPerm);

%% _______________________ Plots (journal-ready version) _________________
time = linspace(-200, 1000, size(long_data1,2));

% ---- Smoothed means and SEMs ----
meanLate1 = movmean(mean(long_data1,1), 20); meanLate2 = movmean(mean(long_data2,1), 20);
meanLate3 = movmean(mean(long_data3,1), 20); meanLate4 = movmean(mean(long_data4,1), 20);
SemLate1  = movmean(std(long_data1,0,1)/sqrt(size(long_data1,1)), 20);
SemLate2  = movmean(std(long_data2,0,1)/sqrt(size(long_data2,1)), 20);
SemLate3  = movmean(std(long_data3,0,1)/sqrt(size(long_data3,1)), 20);
SemLate4  = movmean(std(long_data4,0,1)/sqrt(size(long_data4,1)), 20);

meanEarly1 = movmean(mean(short_data1,1), 20); meanEarly2 = movmean(mean(short_data2,1), 20);
meanEarly3 = movmean(mean(short_data3,1), 20); meanEarly4 = movmean(mean(short_data4,1), 20);
SemEarly1  = movmean(std(short_data1,0,1)/sqrt(size(short_data1,1)), 20);
SemEarly2  = movmean(std(short_data2,0,1)/sqrt(size(short_data2,1)), 20);
SemEarly3  = movmean(std(short_data3,0,1)/sqrt(size(short_data3,1)), 20);
SemEarly4  = movmean(std(short_data4,0,1)/sqrt(size(short_data4,1)), 20);

% ---- Colors matched to the Early/Late mask RT & accuracy figures ----
% Late mask family: sequential BLUE (same hue as "Late mask" bars), by contrast
lateC100  = [0.02 0.11 0.30];   % darkest / 100% contrast
lateC25   = [0.03 0.32 0.61];
lateC12_5 = [0.30 0.60 0.80];
lateC6_2  = [0.68 0.85 0.95];   % lightest / 6.2% contrast

% Early mask family: sequential ORANGE (same hue as "Early mask" bars), by contrast
earlyC100  = [0.50 0.15 0.02];  % darkest / 100% contrast
earlyC25   = [0.85 0.33 0.05];  % close to the RT/accuracy figure's orange
earlyC12_5 = [0.95 0.55 0.25];
earlyC6_2  = [0.99 0.80 0.60];  % lightest / 6.2% contrast

fig = figure('Units','centimeters','Position',[2 2 18 7.5],'Color','w');
t = tiledlayout(fig,1,2,'TileSpacing','compact','Padding','compact');

%% ---- Panel A: Late mask ----
nexttile; hold on;
fill([time, fliplr(time)],[meanLate1+SemLate1, fliplr(meanLate1-SemLate1)],lateC100 ,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanLate2+SemLate2, fliplr(meanLate2-SemLate2)],lateC25  ,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanLate3+SemLate3, fliplr(meanLate3-SemLate3)],lateC12_5,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanLate4+SemLate4, fliplr(meanLate4-SemLate4)],lateC6_2 ,'EdgeColor','none','FaceAlpha',0.15);

pL1 = plot(time, meanLate1,'Color',lateC100 ,'LineWidth',1.6);
pL2 = plot(time, meanLate2,'Color',lateC25  ,'LineWidth',1.6);
pL3 = plot(time, meanLate3,'Color',lateC12_5,'LineWidth',1.6);
pL4 = plot(time, meanLate4,'Color',lateC6_2 ,'LineWidth',1.6);

y1=46; y2=45.5; y3=45; y4=44.5;
plot(time(statsLate1.sig_cluster), y1*ones(1,sum(statsLate1.sig_cluster)),'.','Color',lateC100 ,'MarkerSize',8)
plot(time(statsLate2.sig_cluster), y2*ones(1,sum(statsLate2.sig_cluster)),'.','Color',lateC25  ,'MarkerSize',8)
plot(time(statsLate3.sig_cluster), y3*ones(1,sum(statsLate3.sig_cluster)),'.','Color',lateC12_5,'MarkerSize',8)
plot(time(statsLate4.sig_cluster), y4*ones(1,sum(statsLate4.sig_cluster)),'.','Color',lateC6_2 ,'MarkerSize',8)

xline(0,'--','Color',[0.5 0.5 0.5],'LineWidth',0.75);
yline(50,'--','Color',[0.6 0.6 0.6],'LineWidth',0.75);

% Onset/peak glyphs + numeric labels for BOTH 100% and 25% contrast curves.
% extraYOffset staggers the two curves' labels vertically so they don't
% collide when their onset/peak times land close together.
s1 = addOnsetPeakGlyphs(time, meanLate1, statsLate1.sig_cluster, lateC100);
s2 = addOnsetPeakGlyphs(time, meanLate2, statsLate2.sig_cluster, lateC25);
addStatsBox({s1, s2}, {'100 %','25 %'}, {lateC100, lateC25});

xlabel('Time (ms)','FontName','Arial','FontWeight','bold','FontSize',10);
ylabel('Decoding Accuracy (%)','FontName','Arial','FontWeight','bold','FontSize',10);
title('Late mask','FontName','Arial','FontWeight','bold','FontSize',10);
ax1 = gca; ax1.FontName='Arial'; ax1.FontSize=9; ax1.LineWidth=0.75; ax1.TickDir='out'; ax1.Box='off';
xticks(-200:200:1000); ylim([44 60]); xlim([-200 1000]);
text(-0.15,1.05,'A','Units','normalized','FontName','Arial','FontWeight','bold','FontSize',12);

legend([pL1 pL2 pL3 pL4],{'100 %','25 %','12.5 %','6.2 %'}, ...
    'FontName','Arial','FontSize',8,'Location','northeast','Box','off');

%% ---- Panel B: Early mask ----
nexttile; hold on;
fill([time, fliplr(time)],[meanEarly1+SemEarly1, fliplr(meanEarly1-SemEarly1)],earlyC100 ,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanEarly2+SemEarly2, fliplr(meanEarly2-SemEarly2)],earlyC25  ,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanEarly3+SemEarly3, fliplr(meanEarly3-SemEarly3)],earlyC12_5,'EdgeColor','none','FaceAlpha',0.15);
fill([time, fliplr(time)],[meanEarly4+SemEarly4, fliplr(meanEarly4-SemEarly4)],earlyC6_2 ,'EdgeColor','none','FaceAlpha',0.15);

pE1 = plot(time, meanEarly1,'Color',earlyC100 ,'LineWidth',1.6);
pE2 = plot(time, meanEarly2,'Color',earlyC25  ,'LineWidth',1.6);
pE3 = plot(time, meanEarly3,'Color',earlyC12_5,'LineWidth',1.6);
pE4 = plot(time, meanEarly4,'Color',earlyC6_2 ,'LineWidth',1.6);

plot(time(statsEarly1.sig_cluster), y1*ones(1,sum(statsEarly1.sig_cluster)),'.','Color',earlyC100 ,'MarkerSize',8)
plot(time(statsEarly2.sig_cluster), y2*ones(1,sum(statsEarly2.sig_cluster)),'.','Color',earlyC25  ,'MarkerSize',8)
plot(time(statsEarly3.sig_cluster), y3*ones(1,sum(statsEarly3.sig_cluster)),'.','Color',earlyC12_5,'MarkerSize',8)
plot(time(statsEarly4.sig_cluster), y4*ones(1,sum(statsEarly4.sig_cluster)),'.','Color',earlyC6_2 ,'MarkerSize',8)

xline(0,'--','Color',[0.5 0.5 0.5],'LineWidth',0.75);
yline(50,'--','Color',[0.6 0.6 0.6],'LineWidth',0.75);

s1 = addOnsetPeakGlyphs(time, meanEarly1, statsEarly1.sig_cluster, earlyC100);
s2 = addOnsetPeakGlyphs(time, meanEarly2, statsEarly2.sig_cluster, earlyC25);
addStatsBox({s1, s2}, {'100 %','25 %'}, {earlyC100, earlyC25});

xlabel('Time (ms)','FontName','Arial','FontWeight','bold','FontSize',10);
title('Early mask','FontName','Arial','FontWeight','bold','FontSize',10);
ax2 = gca; ax2.FontName='Arial'; ax2.FontSize=9; ax2.LineWidth=0.75; ax2.TickDir='out'; ax2.Box='off';
xticks(-200:200:1000); ylim([44 60]); xlim([-200 1000]);
text(-0.1,1.05,'B','Units','normalized','FontName','Arial','FontWeight','bold','FontSize',12);

legend([pE1 pE2 pE3 pE4],{'100 %','25 %','12.5 %','6.2 %'}, ...
    'FontName','Arial','FontSize',8,'Location','northeast','Box','off');

%% ---- Export as vector PDF (backup 600 DPI TIFF) ----
set(fig,'PaperPositionMode','auto');
exportgraphics(fig,'Decoding_EarlyLateMask.pdf','ContentType','vector');
exportgraphics(fig,'Decoding_EarlyLateMask.tiff','Resolution',600);
toc;
%% ================= Local function: onset (triangle) / peak (diamond) markers only =================
function s = addOnsetPeakGlyphs(time, meanCurve, sigCluster, curveColor)
% Marks the onset of the first significant cluster with an upward triangle,
% and the peak decoding value WITHIN that cluster with a diamond -- both at
% their TRUE data position, unlabeled (no floating text tied to the curve,
% which is what was causing labels to collide when two curves' events fell
% close together in time). Returns the actual numbers so they can be
% reported separately in a stats box (see addStatsBox below) instead of
% competing for space on the plot itself.
%
% s: struct with fields onsetTime, peakTime, peakVal (all NaN if the curve
% had no significant cluster).

    s = struct('onsetTime', NaN, 'peakTime', NaN, 'peakVal', NaN);
    sigIdx = find(sigCluster);
    if isempty(sigIdx)
        warning('No significant cluster found - onset/peak markers skipped.');
        return
    end

    onsetTime = time(sigIdx(1));
    [~, oIdx] = min(abs(time - onsetTime));
    onsetY = meanCurve(oIdx);
    plot(onsetTime, onsetY + 0.4, '^', 'MarkerSize', 7, ...
        'MarkerFaceColor', curveColor, 'MarkerEdgeColor', curveColor, 'HandleVisibility','off');

    [pkVal, pkRel] = max(meanCurve(sigIdx));
    pkTime = time(sigIdx(pkRel));
    plot(pkTime, pkVal + 0.4, 'd', 'MarkerSize', 7, ...
        'MarkerFaceColor', curveColor, 'MarkerEdgeColor', curveColor, 'HandleVisibility','off');

    s.onsetTime = onsetTime;
    s.peakTime  = pkTime;
    s.peakVal   = pkVal;
end

%% ================= Local function: stats box (guaranteed non-overlapping) =================
function addStatsBox(statsList, curveLabels, curveColors)
% Reports onset/peak numbers as a small stacked text block in the top-left
% of the axes, using fixed axes-normalized line spacing -- NOT tied to
% where the data points fall, so it can never overlap no matter how close
% together two curves' actual onset/peak times happen to be. Curves with
% no significant cluster (NaN fields) are skipped.
%
% Uses the triangle/diamond symbols INLINE (via TeX \Delta and
% \diamondsuit) instead of spelling out "onset"/"peak" in words, which
% keeps each line short enough to sit clear of the color legend in the
% opposite corner.

    yStart = 0.92;
    yStep  = 0.065;
    lineIdx = 0;
    for i = 1:numel(statsList)
        s = statsList{i};
        if isnan(s.onsetTime)
            continue
        end
        yPos = yStart - lineIdx*yStep;
        txt = sprintf('%s: \\Delta%.0f  \\diamondsuit%.0f (%.1f%%)', ...
            curveLabels{i}, s.onsetTime, s.peakTime, s.peakVal);
        text(0.02, yPos, txt, 'Units','normalized', 'FontName','Arial', ...
            'FontSize',7.5, 'Color', curveColors{i}, 'Interpreter','tex', ...
            'HandleVisibility','off');
        lineIdx = lineIdx + 1;
    end
end