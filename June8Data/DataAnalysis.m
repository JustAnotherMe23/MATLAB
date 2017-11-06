clear;
clc;
close all;
format compact;

TitleFontSize = 25;
LabelFontSize = 16;

filename = input('Please enter the filename: ', 's');
rawData = xlsread(filename);

totalTime = rawData(1, 1);
labelUp = rawData(2, 1);
labelDown = rawData(3, 1);

[row, column] = size(rawData);
for a = 1: 1: row
    for b = 1: 1: 76
        if column < b
            rawData(a, b) = 0;
        elseif isnan(rawData(a, b))
            rawData(a, b) = 0;
        end
    end
end

linearData = sum(rawData);
Data = [linearData(2: 10); linearData(11: 19); linearData(20: 28); linearData(29: 37);...
    linearData(38: 46); linearData(47: 55); linearData(56: 64); linearData(65: 73)];

labels = {'Double Pick', 'Mis-Pick', 'Dropped Box', 'Flipper Jam', 'Phantom Double Pick', 'Mis-Recover',...
    'Mis-Label', 'Mis-Flip'};
rootLabels = {'Chute Vision Error', 'Suction Failure', 'Package Movement', 'Collision', 'Flipper Vision Error',...
    'Bar Code Fault', 'Bouncing', 'Flipper Handling', 'Stirring'};
colors = [ones(1, 2), linspace(1, 0, 5), zeros(1, 2); linspace(0, 1, 4), 1, linspace(1, 0, 4); zeros(1, 2), linspace(0, 1, 5), ones(1, 2)]';

occurences = countOcc(rawData(:, [2: end]));

errorTot = sum(Data');
rootTot = sum(Data);
[Data, subLabels, colors] = filterZeros(Data', rootLabels, colors);
[Data, subLabels, colors] = large2Small2(Data, subLabels, colors);
colors = [ones(1, 2), linspace(1, 0, 5), zeros(1, 2); linspace(0, 1, 4), 1, linspace(1, 0, 4); zeros(1, 2), linspace(0, 1, 5), ones(1, 2)]';

rootLabels = subLabels
[doublePick, doublePickLabels, doublePickColors] = filterZeroes(Data(:, 1), rootLabels, colors);
[misPick, misPickLabels, MisPickColors] = filterZeroes(Data(:, 2), rootLabels, colors);
[dropBox, dropBoxLabels, dropBoxColors] = filterZeroes(Data(:, 3), rootLabels, colors);
flipJamLabels = {'Off-Center Pick', 'Premature Release', rootLabels{1, 3:end}};
[flipJam, flipJamLabels, flipJamColors] = filterZeroes(Data(:, 4), flipJamLabels, colors);
[phantomDouble, phantomDoubleLabels, phantomDoubleColors] = filterZeroes(Data(:, 5), rootLabels, colors);
[misRecover, misRecoverLabels, misRecoverColors] = filterZeroes(Data(:, 6), rootLabels, colors);
[misLabel, misLabelLabels, misLabelColors] = filterZeroes(Data(:, 7), rootLabels, colors);
[loosePack, loosePackLabels, loosePackColors] = filterZeroes(Data(:, 8), rootLabels, colors);

[doublePick, doublePickLabels, doublePickColors] = large2Small(doublePick, doublePickLabels, doublePickColors);
[misPick, misPickLabels, misPickColors] = large2Small(misPick, misPickLabels, MisPickColors);
[dropBox, dropBoxLabels, dropBoxColors] = large2Small(dropBox, dropBoxLabels, dropBoxColors);
[flipJam, flipJamLabels, flipJamColors] = large2Small(flipJam, flipJamLabels, flipJamColors);
[phantomDouble, phantomDoubleLabels, phantomDoubleColors] = large2Small(phantomDouble, phantomDoubleLabels, phantomDoubleColors);
[misRecover, misRecoverLabels, misRecoverColors] = large2Small(misRecover, misRecoverLabels, misRecoverColors);
[misLabel, misLabelLabels, misLabelColors] = large2Small(misLabel, misLabelLabels, misLabelColors);
[loosePack, loosePackLabels, loosePackColors] = large2Small(loosePack, loosePackLabels, loosePackColors);

spaceColors = [linspace(0, 1, length(labels)); linspace(0, 1, length(labels)); linspace(0, 1, length(labels))]';
[Data, labels, spaceColors] = filterZeros(Data', labels, spaceColors);
[Data, labels, spaceColors] = large2Small2(Data, labels, spaceColors);
[rows, len] = size(labels);
Datacopy = Data .* 100 ./ totalTime;
b = bar(Datacopy, 'stacked');
t = title({'Comparison of Unproductive Time'; 'Consumption and Sources'});
set(gca, 'FontSize', LabelFontSize);
set(t, 'FontSize', TitleFontSize);
legend(subLabels);
set(gca, 'XTick', 1:len, 'XTickLabel', labels);
xtickangle(30);
OrderedLabels = labels
ylabel('Time (% Total)');
ylim([0, 14]);

for num = 1: 1: length(rootLabels)
    b(num).FaceColor = colors(num, :);
end

rootLabels = {'Chute Vision Error', 'Suction Failure', 'Package Movement', 'Collision', 'Flipper Vision Error',...
    'Bar Code Fault', 'Bouncing', 'Flipper Handling', 'Stirring'};
spaceColors = [linspace(0, 1, length(labels)); linspace(0, 1, length(labels)); linspace(0, 1, length(labels))]';
[rootTot, rootLabels, spaceColors] = filterZeroes(rootTot, rootLabels, colors);
[rootTot, rootLabels, spaceColors] = large2Small(rootTot, rootLabels, spaceColors);
OrderedRoots = rootLabels
len = length(rootLabels);

rootTotcopy = rootTot .* 100 ./ totalTime;
figure;
bar(rootTotcopy);
set(gca, 'XTick', 1:len, 'XTickLabel', rootLabels);
ylabel('Time (% Total)');
t = title('Time Consumption of Root Causes');
set(gca, 'FontSize', LabelFontSize);
xtickangle(30);
set(t, 'FontSize', TitleFontSize);

if length(doublePick) > 0
    figure;
    pie(doublePick);
    legend(doublePickLabels);
    t = title('Double Pick Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(doublePickColors);
end

if length(misPick) > 0
    figure;
    pie(misPick);
    legend(misPickLabels);
    t = title('Mis-Pick Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(misPickColors);
end

if length(dropBox) > 0
    figure;
    pie(dropBox);
    legend(dropBoxLabels);
    t = title('Parcel Drop Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(dropBoxColors);
end

if length(flipJam) > 0
    figure;
    pie(flipJam);
    legend(flipJamLabels);
    t = title('Flipper Jam Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(flipJamColors);
end

if length(phantomDouble) > 0
    figure;
    pie(phantomDouble);
    t = title('Phantom Double Breakdown');
    legend(phantomDoubleLabels);
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(phantomDoubleColors);
end

if length(misRecover) > 0
    figure;
    pie(misRecover);
    legend(misRecoverLabels);
    t = title('Mis-Recover Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(misRecoverColors);
end

if length(misLabel) > 0
    figure;
    pie(misLabel);
    legend(misLabelLabels)
    t = title('Mis-Label Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(misLabelColors);
end

if length(loosePack) > 0
    figure;
    pie(loosePack);
    legend(loosePackLabels);
    t = title('Mis-Flip Breakdown');
    set(gca, 'FontSize', LabelFontSize);
    set(t, 'FontSize', TitleFontSize);
    colormap(loosePackColors);
end

unusedTime = sum(sum(Data));
figure;
pie([unusedTime, totalTime - unusedTime]);
t = title('Productive vs Unproductive Time');
set(gca, 'FontSize', LabelFontSize);
set(t, 'FontSize', TitleFontSize);
legend('Unproductive Time', 'Productive Time');
colormap([0.6 0 0; 0 0.6 0]);

figure;
pie([labelDown, labelUp]);
t = title('Label Up vs Label Down');
set(gca, 'FontSize', LabelFontSize);
set(t, 'FontSize', TitleFontSize);
legend('Label Down', 'Label Up');
colormap([0 0 0.6; 0 0.6 0]);

errorTot
timePerOcc = errorTot ./ occurences
percentTime = errorTot ./ sum(totalTime) .* 100

perMinUp = labelUp / totalTime * 60
perMinDown = labelDown / totalTime * 60
MaxUp = labelUp / (totalTime - unusedTime) * 60
MaxDown = labelDown / (totalTime - unusedTime) * 60
% close all;