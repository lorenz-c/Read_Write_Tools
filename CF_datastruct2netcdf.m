function [] = CF_datastruct2netcdf(inpt, outnme, varargin)
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

% Get the unit of the time-variable
tme_units = inpt.Variables.time.units;

% Get the dimensions
dims = inpt.Dimensions;

% Get the variables
vars = fieldnames(inpt.Variables);

% Find the time dimension
tme_indx = ismember(vars, 'time');

if isempty(tme_indx)
    error('CF_datastruct2netcdf.m: No time vector present!')
end

% Get the first date
date_first = inpt.Data.time(1, :);

% For daily, monthly, and annual data, convert yyyy/mm/dd/hh/mm/ss into
% days since date_first
for i = 1:length(inpt.TimeStamp)    
    dys(i) = daysact(inpt.TimeStamp(1), inpt.TimeStamp(i));
end

% Get Lat/Lon from the input structure
lambda = inpt.Data.lon;
theta  = inpt.Data.lat;

% Number of variables to be exported
if isempty(varargin)
    
    for i = 1:length(dims)
        dim_ids(i) = find(ismember(vars, dims{i}));
    end
    
    % Remove the dimension variables
    vars(dim_ids, :) = [];
else
    vars = varargin;
end

% Get some MetaData
MetaData = inpt.DataInfo;

           
% Create a netcdf-file
cmode = netcdf.getConstant('NETCDF4');
cmode = bitor(cmode,netcdf.getConstant('CLASSIC_MODEL'));
ncid  = netcdf.create(outnme, cmode);

% First, get the variable ID for the GLOBAL Attributes
varid_glbl = netcdf.getConstant('GLOBAL');
% Get the names of all global attributes in the input structure
glbl_Atts = fieldnames(MetaData);
% Update the file history
MetaData.history = strcat(MetaData.history, ...
                    [datestr(now), '; CF_datastruct2netcdf.m: conversion to netcdf \n'])
                
% Copy the names and the corresponding values to the output file
for i = 1:length(glbl_Atts)
    netcdf.putAtt(ncid, varid_glbl, glbl_Atts{i}, MetaData.(glbl_Atts{i}));
end


                
% Define the dimension ids
time_dim_id = netcdf.defDim(ncid, 'time', length(dys));
lon_dim_id  = netcdf.defDim(ncid, 'lon', length(lambda));
lat_dim_id  = netcdf.defDim(ncid, 'lat', length(theta));

% Define the variable ids
time_var_id = netcdf.defVar(ncid, 'time', 'double', time_dim_id);
lon_var_id  = netcdf.defVar(ncid, 'lon', 'double', lon_dim_id);
lat_var_id  = netcdf.defVar(ncid, 'lat', 'double', lat_dim_id);                
                
% Set the attributes for the different dimension variables
% 1. The time-variable
time_Atts = fieldnames(inpt.Variables.time);
for i = 1:length(time_Atts) 
    if strcmp(time_Atts{i}, 'units')
        netcdf.putAtt(ncid, time_var_id, time_Atts{i}, ...
              ['days since ', datestr(date_first, 'yyyy-mm-dd HH:MM:SS')]);
    else
        netcdf.putAtt(ncid, time_var_id, time_Atts{i}, ...
                                       inpt.Variables.time.(time_Atts{i}));    
    end
end               
                
% 2. Latitude
lat_Atts = fieldnames(inpt.Variables.lat);
for i = 1:length(lat_Atts)
    netcdf.putAtt(ncid, lat_var_id, lat_Atts{i}, ...
                                         inpt.Variables.lat.(lat_Atts{i}));   
end
 % 3. Longitude
lon_Atts = fieldnames(inpt.Variables.lon);
for i = 1:length(lon_Atts)
    netcdf.putAtt(ncid, lon_var_id, lon_Atts{i}, ...
                                         inpt.Variables.lon.(lon_Atts{i}));   
end

% Now, create a variable in the netcdf-file for each variable in the input
% structure (...or according to varargin)
for i = 1:length(vars)
    
    if isfield(inpt.Variables.(vars{i}), 'FillValue')
        mval = inpt.Variables.(vars{i}).FillValue;
    elseif isfield(inpt.Variables.(vars{i}), 'missingValue')
        mval = inpt.Variables.(vars{i}).missingValue;
    else
        warning('No missing values defined!')
    end
    
    bigmat{i} = inpt.Data.(vars{i});
    
    if ~isnan(mval)
        bigmat{i}(bigmat{i} == mval) = 1e+20;
    elseif isnan(mval)
        bigmat{i}(isnan(bigmat{i}))  = 1e+20;
    end
    
    % Create a variable ID for each variable
    data_var_id(i) = netcdf.defVar(ncid, vars{i}, 'double', ...
                                      [lon_dim_id lat_dim_id time_dim_id]);
    % Get the variable attributes for the current variable
    data_Atts      = fieldnames(inpt.Variables.(vars{i}));
    
    for j = 1:length(data_Atts)
        if strcmp(data_Atts{j}, 'FillValue')
            netcdf.putAtt(ncid, data_var_id(i), '_FillValue', 1e+20);
        else
            netcdf.putAtt(ncid, data_var_id(i), data_Atts{j}, ...
                              inpt.Variables.(vars{i}).(data_Atts{j}));
        end
    end
end




netcdf.endDef(ncid);

% Write the variables to the netcdf-file
netcdf.putVar(ncid, time_var_id, dys);
netcdf.putVar(ncid, lon_var_id,  lambda);
netcdf.putVar(ncid, lat_var_id,  theta);

for i = 1:length(vars)
    netcdf.putVar(ncid, data_var_id(i), permute(bigmat{i}, [3 2 1]));
end

netcdf.close(ncid);



fprintf('Done \n')

















