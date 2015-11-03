function [varnme, descr] = varnme2cf(innme)

if strcmpi(innme, 'Total Evapotranspiration')
    varnme = 'Evap';
    descr  = 'Total evapotranspiration';
elseif strcmpi(innme, 'Total Precipitation')
    varnme = 'Precip';
    descr  = 'Precipitation rate';
end

