function [] = datastruct2netcdf(inpt, outnme)
% The function converts a datastructure into a netcdf-file.
% Currently it supports daily and monthly datasets, depending on the number
% of columns of inpt:
% - 3 columns: monthly data 
% - 4 columns: daily data
% Latitude and Longitude must be provided as well. If these are not known,
% the output file does not match the netcdf-conventions. For such data, use
% the function mat2netcdf.
%--------------------------------------------------------------------------
% Input (required):
% - inpt  {m x 3}      Cell array which contains monthly input fields. 
%                      The first two columns must contain month and year,
%                      the third column must contain the (i x j) data field
%         {m x 4}      Cell array which contains daily input fields. 
%                      The first three columns must contain day, month, and
%                      year, the fourth column must contain the data field 
% - theta    i         Vector containing the latitudes of the fields
% - lambda   j         Vector containing the longitudes of the fields
%--------------------------------------------------------------------------
% Author: Christof Lorenz
% Date:   January 2013
%--------------------------------------------------------------------------
% Uses: 
%--------------------------------------------------------------------------


% Get temporal resolution of the datastructure
TempRes  = inpt.DataInfo.TempRes;

% Check the type of the datastructure
DataType = inpt.DataInfo.Type;

if ~strcmp(inpt.DataInfo.Type, 'single_map')
    % Get the first date of the datastructure
    date_first = inpt.DateTime(1, :);
    
    % For daily, monthly, and annual data, convert yyyy/mm/dd/hh/mm/ss into
    % days since date_first
    for i = 1:length(inpt.DateTime)
        dys1(i, 1) = daysact(inpt.TimeStamp(1), inpt.TimeStamp(i));
        dys2(i, 1) = daysact(datestr(inpt.TimeStamp(1)), datestr(inpt.TimeStamp(i)));
    
        if dys1(i) ~= dys2(i)
            error('DateTime does not match TimeStamps!')
        end
    end
    
    if strcmp(DataType, 'spatial_2d')
        nr_vars = size(inpt.DataInfo.VariableName, 1);
        nr_levs = 1;
        nr_tsps = length(dys1);
    end   
    
else
    nr_vars = size(inpt.Data, 2);
    nr_levs = 1;
    nr_tsps = 1;
end

% Get the Meta-Data
MetaData = inpt.DataInfo;

if ~isempty(MetaData.History)
    History  = [MetaData.History; ...
                [datestr(now), '; datastruct2netcdf.m: conversion to netcdf4']];
    
else
    History  = [datestr(now), '; datastruct2netcdf.m: conversion to netcdf4'];
end
hst_string = History{:};

% Set the missing values in each variable matrix to 1e+20
if nr_vars == 1
    bigmat = inpt.Data;
    
    if ~isnan(MetaData.MissingValue)
        bigmat(bigmat == mval) = 1e+20;
    elseif isnan(MetaData.MissingValue)
        bigmat(isnan(bigmat))  = 1e+20;
    end
    
    varnme = MetaData.VariableName;
    
    if ~isempty(varnme)
        % For each variable name, get the COARDS-conform short name
        [varnme_short, descr] = varnme2cf(varnme);
    else
        varnme_short = 'Z';
        descr        = 'Undefined variable';
    end
    
    lambda = inpt.Grid.Lon;
    theta  = inpt.Grid.Lat;
    
else    
    
    for i = 1:nr_vars
        bigmat{i} = inpt.Data{i};

        if ~isnan(MetaData.MissingValue)
            bigmat{i}(bigmat{i} == mval) = 1e+20;
        elseif isnan(MetaData.MissingValue)
            bigmat{i}(isnan(bigmat{i}))  = 1e+20;
        end
    
        % Get the variable names
        varnme = MetaData.VariableName(i, :);
    
        if ~isempty(varnme)
            % For each variable name, get the COARDS-conform short name
            [varnme_short{i}, descr{i}] = varnme2cf(varnme);
        else
            varnme_short{i} = 'Z';
            descr{i}        = 'Undefined variable';
        end
    
        lambda = inpt.Grid.Lon;
        theta  = inpt.Grid.Lat;
    end
end
    
    
% Create a netcdf-file
cmode = netcdf.getConstant('NETCDF4');
cmode = bitor(cmode,netcdf.getConstant('CLASSIC_MODEL'));
ncid  = netcdf.create(outnme, cmode);

% Define the dimension ids
time_dim_id = netcdf.defDim(ncid, 'time', length(dys1));
lon_dim_id  = netcdf.defDim(ncid, 'lon', length(lambda));
lat_dim_id  = netcdf.defDim(ncid, 'lat', length(theta));

% Define the variable ids
time_var_id = netcdf.defVar(ncid, 'time', 'double', time_dim_id);
lon_var_id  = netcdf.defVar(ncid, 'lon', 'double', lon_dim_id);
lat_var_id  = netcdf.defVar(ncid, 'lat', 'double', lat_dim_id);

% Set the attributes of the variables
netcdf.putAtt(ncid, time_var_id, '_CoordinateAxisType', 'Time');
netcdf.putAtt(ncid, time_var_id, 'long_name', 'time');
netcdf.putAtt(ncid, time_var_id, 'axis', 'T');
netcdf.putAtt(ncid, time_var_id, 'calendar', 'standard');
netcdf.putAtt(ncid, time_var_id, 'units', ['days since ', datestr(date_first, 'yyyy-mm-dd HH:MM:SS')]);

netcdf.putAtt(ncid, lon_var_id, 'units', 'degrees_east');
netcdf.putAtt(ncid, lon_var_id, 'long_name', 'longitude');
netcdf.putAtt(ncid, lon_var_id, 'axis', 'X');
netcdf.putAtt(ncid, lon_var_id, '_CoordinateAxisType', 'Lon');
    
netcdf.putAtt(ncid, lat_var_id, 'units', 'degrees_north');
netcdf.putAtt(ncid, lat_var_id, 'long_name', 'latitude');
netcdf.putAtt(ncid, lat_var_id, 'axis', 'Y');
netcdf.putAtt(ncid, lat_var_id, '_CoordinateAxisType', 'Lat');


if strcmp(DataType, 'spatial_2d')
    if nr_vars == 1
        data_var_id = netcdf.defVar(ncid, varnme_short, 'double', ...
                                [lon_dim_id lat_dim_id time_dim_id]);                             

        netcdf.putAtt(ncid, data_var_id, 'long_name', descr);
        netcdf.putAtt(ncid, data_var_id, '_FillValue', 1e+20);
        netcdf.putAtt(ncid, data_var_id, 'missing_value', 1e+20);
        netcdf.putAtt(ncid, data_var_id, 'units', MetaData.Unit);
        
    else
        for i = 1:nr_vars
            data_var_id(i) = netcdf.defVar(ncid, varnme_short{i}, 'double', ...
                                [lat_dim_id lon_dim_id time_dim_id]);                             

            netcdf.putAtt(ncid, data_var_id(i), 'long_name', descr{i});
            netcdf.putAtt(ncid, data_var_id(i), '_FillValue', 1e+20);
            netcdf.putAtt(ncid, data_var_id(i), 'missing_value', 1e+20);
            netcdf.putAtt(ncid, data_var_id(i), 'units', MetaData.Unit(i, :));
        end
    end
end


% Get the variable id for GLOBAL Attributes
varid_glbl       = netcdf.getConstant('GLOBAL');

% Sewt the GLOBAL Attributes
netcdf.putAtt(ncid, varid_glbl, 'creation_date', datestr(now));
netcdf.putAtt(ncid, varid_glbl, 'institution', MetaData.Center);
netcdf.putAtt(ncid, varid_glbl, 'history', hst_string);
netcdf.putAtt(ncid, varid_glbl, 'title', MetaData.Name);
netcdf.putAtt(ncid, varid_glbl, 'references', MetaData.Reference);
netcdf.putAtt(ncid, varid_glbl, 'Conventions', 'CF-1.6');

if isempty(MetaData.UserInfo)
    netcdf.putAtt(ncid, varid_glbl, 'comment', ' ');
else
    netcdf.putAtt(ncid, varid_glbl, 'comment', UserInfo{:});
end

if ~isempty(MetaData.ShortName)
    netcdf.putAtt(ncid, varid_glbl, 'shortname', MetaData.ShortName);
end

if ~isempty(MetaData.Version)
    netcdf.putAtt(ncid, varid_glbl, 'version', MetaData.Version);
end

if ~isempty(MetaData.URL)
    netcdf.putAtt(ncid, varid_glbl, 'url', MetaData.URL);
end

if ~isempty(MetaData.Owner)
    netcdf.putAtt(ncid, varid_glbl, 'owner', MetaData.Owner);
end

if ~isempty(MetaData.Contact)
    netcdf.putAtt(ncid, varid_glbl, 'contact', MetaData.Contact);
end



netcdf.endDef(ncid);


% Write the variables to the netcdf-file
netcdf.putVar(ncid, time_var_id, dys1);
netcdf.putVar(ncid, lon_var_id,  lambda);
netcdf.putVar(ncid, lat_var_id,  theta);

if nr_vars == 1
    netcdf.putVar(ncid, data_var_id, permute(bigmat, [3 2 1]));
else
    for i = 1:nr_vars
        netcdf.putVar(ncid, data_var_id(i), bigmat{i});
    end
end

netcdf.close(ncid);

fprintf('Done \n')

















