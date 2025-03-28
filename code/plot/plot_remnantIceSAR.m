%Plots the sea surface salinity from Seaglider and Wave Glider in the remnant ice area 
%overlaid on concurrent SAR imagery. Need to manually adjust the alpha
%value of the overlying salinity axis to see the SAR image underneath
% close all

saveFigs = false;
saveDir = [rootPath, 'figures/fig4/'];

[~, colors] = defineSODAconstants;

clim_salt = [25.5, 26.5];

fntsz = 14;

%Outline the zoom-in box
% minlon = -149; maxlon = -143; minlat = 72.75; maxlat = 75.55;
minlon = -149; maxlon = -146.5; minlat = 72.5; maxlat = 73.2;
pt1 = [minlon, minlat]; pt2 = [maxlon, minlat]; pt3 = [maxlon, maxlat]; pt4 = [minlon, maxlat];
pts = [pt1(1), pt2(1), pt3(1), pt4(1); pt1(2), pt2(2), pt3(2), pt4(2)];

%This code can add a line outlining the zoom-in area to a larger scale map
% linpts = [pts'; pts(:, 1)'];
% m_line(linpts(:, 1), linpts(:, 2), 'color', 'w', 'linewidth', 1, 'linestyle', '--')

%Set up map projection
m_proj('lambert', 'lon', [minlon maxlon], 'lat', [minlat maxlat]);


%% First plot - Seaglider profiles

saveName = 'remnantIceSAR_seaglider';

%Load SAR image
fileName = 'WG_20180925_RS2_SCWA_100m.mat'; load(fileName); 

% Load data structure of all profiles
% profiles = loadProfiles;
inRegionMask = zeros(size(profiles.times));
inRegionMask(profiles.lats >= minlat & profiles.lats <= maxlat ...
    & profiles.lons >= minlon & profiles.lons <= maxlon) = 1;
profNums = find(inRegionMask == 1 & profiles.qualFlag == 1);

titleText = ['SAR image from ', datestr([fileName(8:9), ' ', fileName(10:11), ' ', fileName(4:7)], 'dd mmm'),...
    sprintf('\n'), 'Seaglider data from ', datestr(min(profiles.times(profNums)), 'dd mmm')];%, ' to ',  datestr(max(profiles.times(profNums)), 'dd mmm')];

%First axis, for plotting the SAR image
figure(1); set(gcf, 'color', 'w', 'pos', [125  182  1371   765]); % [560   686   409   262])
ax1 = axes; subplot(2,3,4, ax1)
m_pcolor(LON_grid, LAT_grid, A_grid);
shading flat
colormap(ax1, gray)
caxis([0 0.2])
hold on
m_grid('xtick', [], 'ytick', [], 'xticklabels', [], 'yticklabels', [], 'linestyle', 'none')
ps1 = get(gca, 'pos');

%Second axis, for plotting the sea surface salinity
ax2 = axes; subplot(2,3,4, ax2)
m_scatter(profiles.lons(profNums), profiles.lats(profNums), 100, 'w') 
hold on
h3 = m_scatter(profiles.lons(profNums), profiles.lats(profNums), 60, nanmean(profiles.SA(1:5, profNums)), 'filled');
caxis(clim_salt)
cmocean('haline')
% cb = colorbar;
% ylabel(cb, ['Absolute salinity (g/kg)']) 
% set(cb, 'location', 'southoutside', 'fontsize', 14)
m_grid('fontsize', fntsz-2)

m_text(-148.9, 73.15, titleText, 'fontsize', fntsz, 'color', 'w')
m_text(-148.9, 72.6, 'Sea ice', 'fontsize', fntsz, 'fontweight', 'bold', 'color', [0.93,0.69,0.13])
m_text(-147.1, 72.65, ['Open', sprintf('\n'), 'water'], 'fontsize', fntsz, 'fontweight', 'bold', 'color', [0.93,0.69,0.13])
text(-0.075,0.95,'d','Units','normalized','FontSize',14, 'fontweight', 'bold')

%Make the axes the same size
set(ax1, 'pos', ps1)
set(ax2, 'pos', ps1)

if saveFigs    
    print([saveDir, saveName],'-dpng')
    saveas(gcf, [saveDir, saveName, '.fig'])
end

%%  Second plot - Wave Glider transect 

saveName = 'remnantIceSAR_waveglider';

%Load SAR image
fileName = 'WG_20180921_RS2_SCWA_100m.mat'; load(fileName); 

% Load and plot data from Wave Glider 153 - the only Wave Glider that
% recorded salinity at 0.2 m as well as 9 m
% wvdata = loadWaveglider;
vehicleNums = find(wvdata.vehicle == 153);
times = wvdata.times(vehicleNums); lons = wvdata.lons(vehicleNums); lats = wvdata.lats(vehicleNums);
temps = wvdata.temps(vehicleNums, :); salts = wvdata.salts(vehicleNums, :);

%Calculate conservative temperature, absolute salinity, density
[SA, ~, ~] = gsw_SA_Sstar_from_SP(salts, gsw_p_from_z(-wvdata.depths(vehicleNums, :), repmat(lats, [1, 3])), lons, lats);
CT = gsw_CT_from_t(SA, temps, gsw_p_from_z(-wvdata.depths(vehicleNums, :),repmat(lats, [1, 3])));

%Select data from Wave Glider crossing the front using time bounds
startTime = datenum('sept 19 2018'); %
startTime_transect = datenum('sept 22 2018') + .07;
endTime = datenum('sept 22 2018') + .55;
[~, startInd] = min(abs(times - startTime));
[~, startInd_transect] = min(abs(times - startTime_transect));
[~, endInd] = min(abs(times - endTime));

titleText = ['SAR image from ', datestr([fileName(8:9), ' ', fileName(10:11), ' ', fileName(4:7)], 'dd mmm'),...
    sprintf('\n'), 'Wave Glider data from ', datestr(startTime, 'dd mmm'), ' to ',  datestr(endTime, 'dd mmm')];

%First axis, for plotting SAR imagery
% figure; set(gcf, 'color', 'w', 'pos', [560   686   409   262])
ax3 = axes; subplot(2, 3, 1, ax3);
m_pcolor(LON_grid, LAT_grid, A_grid);
shading flat
colormap(ax3, gray)
caxis([0 0.2])
hold on
m_grid('xtick', [], 'ytick', [], 'xticklabels', [], 'yticklabels', [], 'linestyle', 'none')
ps2 = get(gca, 'pos');

%Second axis, for plotting Wave Glider sea surface salinity
ax4 = axes; subplot(2, 3, 1, ax4);
m_scatter(lons(startInd_transect:endInd), lats(startInd_transect:endInd), 100, 'w') 
hold on
h3 = m_scatter(lons(startInd:endInd), lats(startInd:endInd), 60, SA(startInd:endInd, 2), 'filled');

caxis(clim_salt)
cmocean('haline')
cb = colorbar;
ylabel(cb, ['Absolute salinity (g/kg)']) 
set(cb, 'location', 'southoutside', 'fontsize', fntsz);
m_text(-148.95, 73.15, titleText, 'fontsize', fntsz, 'color', 'w')
m_text(-148.9, 72.6, 'Sea ice', 'fontsize', fntsz, 'fontweight', 'bold', 'color', [0.93,0.69,0.13])
m_text(-147.1, 72.65, ['Open', sprintf('\n'), 'water'], 'fontsize', fntsz, 'fontweight', 'bold', 'color', colors.yellow)
text(-0.075,0.95,'a','Units','normalized','FontSize',14, 'fontweight', 'bold')

m_grid('fontsize', fntsz - 2)

%Make the axes the same size
set(ax3, 'pos', ps2)
set(ax4, 'pos', ps2)

if saveFigs  
    if ~exist(saveDir, 'dir'); mkdir(saveDir); end
    print([saveDir, saveName],'-dpng')
    saveas(gcf, [saveDir, saveName, '.fig'])
end

clearvars -except rootPath ibcao AMSR2 profiles wvdata metData
