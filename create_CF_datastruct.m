function out = create_CF_datastruct(type, varargin)


% -------------------------------------------------------------------------
% Reference: http://www.nodc.noaa.gov/data/formats/netcdf/v1.1/
% -------------------------------------------------------------------------

% Feature Type Descriptions
% point             A single data point (having no implied coordinate 
%                   relationship to other points). 
% timeSeries        A series of data points at the same spatial location 
%                   with monotonically increasing times.     
% trajectory        A series of data points along a path through space with 
%                   monotonically increasing times.   
% profile           An ordered set of data points along a vertical line at 
%                   a fixed horizontal position and fixed time. 
% timeSeriesProfile A series of profile features at the same horizontal 
%                   position with monotonically increasing times. 
% trajectoryProfile A series of profile features located at points ordered 
%                   along a trajectory. 
% swath             An array of data in "sensor coordinates". 
% grid              Data represented or projected on a regular or irregular 
%                   grid. 


% -------------------------------------------------------------------------

% Background on CF Feature Types
% 
% The netCDF conventions identify eight feature types, each one describing 
% a way of storing environmental data. These feature types are not based on 
% the kind of observing system, instrument type, or variable collected. 
% Instead, they are based on fundamental relationships among the 
% spatiotemporal coordinates. This approach allows for CF to provide 
% appropriate standards for representing very nearly all kinds of 
% environmental observations. Six of these are known as "discrete sampling 
% geometries" or "point observation types". These are supplemented by the 
% swath and grid feature types used for non-discrete data.
% 
% For most of the discrete sampling geometries, the relationship between 
% the data can be categorized in two ways:
% 
% The first representation is referred to as an Orthogonal Multidimensional 
% Array representation, in which variables of a dataset contain identical 
% coordinate values along an axis. An example could be the vertical 
% coordinates of variables measured on moored buoys with identical depth 
% levels . The depth coordinate variable would store the array of the 
% identical depth levels from the buoys. Therefore, if the depth levels for 
% the first buoy are [5,10,15, 20] and the second buoy are [5,10,15,20,25], 
% then the depth coordinate variable Z in the Orthogonal Multidimensional 
% Array representation would be a single dimensional array 
% Z = [5,10,15,20,25], and data value for the first buoy at z = 25 would be 
% marked as a missing value.
%
% The second representation is referred to as the Incomplete 
% Multidimensional Array representation. This representation is used when 
% the variables of a dataset contain different coordinate values along an 
% axis. This is a useful approach, for example, if multiple XBT profiles 
% with different vertical resolution or levels are to be stored in the same 
% netCDF file. A variable would need to be generated that would act as an 
% indexed array to the depth levels of all the profiles combined. For 
% example, if the depth levels for the first XBT are [11, 23, 35, 47, 59] 
% and for the second XBT are [12, 24, 36, 48, 50, 61, 65], then the new 
% depth variable containing data from both the XBTs would be two 
% dimensional array Z = [[11, 23, 35, 47, 59, _, _] 
% [12, 24, 36, 48, 50, 61]] where "_" is a missing value, and the data 
% values for the first XBT would be padded with missing values for indices 
% i = 5 & i = 6.
% 
% Apart from Orthogonal multidimensional array and incomplete 
% multidimensional array, CF allows two additional methods of packing data 
% in an array ? contiguous ragged array and indexed ragged array. While 
% there are benefits to using these representations over multidimensional 
% array representations, they are generally more complex. Multidimensional 
% representations can instead be used in all the cases where these 
% representations could be used, but are space inefficient. Where the 
% storage efficiency is important, contiguous ragged array representation 
% could be used instead. In this version, we have chosen to focus on the 
% multidimensional array approaches. We wanted to start with the simplest 
% representations first that we believe will handle most of the data that 
% we receive at NODC, and then move to more complex representations. Later 
% versions of the templates might include the contiguous ragged array 
% representation. So, if you feel that ragged arrays are the more 
% appropriate way to represent your data then please feel free to use them.
%     
    
    
% -------------------------------------------------------------------------
%                            GLOBAL ATTRIBUTES
% -------------------------------------------------------------------------

% Mandatory Information in order to be CF-conform 

% One sentence about the data contained within the file. 
out.DataInfo.title         = ''; % (string)

% The method of production of the original data. If it was model-generated, 
% source should name the model and its version, as specifically as could be 
% useful. If it is observational, source should characterize it (e.g.,
% "surface observation" or "radiosonde"). 
out.DataInfo.source        = ''; % (string)

% Any changes made to the file should be tracked here. (For example: 
% "2010-06-09; previous version's uuid; added attributes for the 
% calibration coefficients to the depth variable.") 
out.DataInfo.history       = [datestr(now, 26), '; create_CF_datastruct.m: Created data structure \n']; % (string)

% Published or web-based references that describe the data or methods used 
% to produce it. 
out.DataInfo.references    = ''; % (string)

% Miscellaneous information about the data, that cannot be described in any 
% of the other available attributes. 
out.DataInfo.comment       = ''; % (string)

% States that the CF convention is being used and what version. 
out.DataInfo.Conventions   = 'CF-1.6'; % (string)

% Indicates which controlled list of variable names has been used in the 
% "standard_name" attribute. Use of this attribute is recommended and their 
% value will be used by THREDDS in the variable mapping. If the file uses 
% the CF convention (and the Convention attribute indicates this), THREDDS 
% will assume the standard_name values are from the CF convention standard 
% name table. 
out.DataInfo.standard_name_vocabulary = ''; % (string)
% Since these templates comply with CF conventions, this attribute should 
% contain "NetCDF Climate and Forecast (CF) Metadata Convention Standard 
% Name Table Version X?, where X denotes the version number of the table. 

% The date or date and time when the file was created. Use ISO 8601 and 
% give date or date and time in UTC (ex., "yyyy-mm-dd" or 
% "yyyy-mm-ddThh:mn:ssZ"). This time stamp will never change, even when 
% modifying the file. 
out.DataInfo.date_created  = datestr(now); % (string)

% The date or date and time when the file was modified. Use ISO 8601 and 
% give date or date and time in UTC (ex., "yyyy-mm-dd" or 
% "yyyy-mm-ddThh:mn:ssZ").This time stamp will change any time information 
% is changed in this file. 
out.DataInfo.date_modified = datestr(now); % (string)

% Change these accordingly
% Name of the person who collected the data. 
out.DataInfo.creator_name  = 'Christof Lorenz'; % (string)

% The URL of the institution that collected the data. 
out.DataInfo.creator_url   =  ...
              'http://imk-ifu.fzk.de/staff_Christof_Lorenz.php'; % (string)
 
% Email address of the person or institution that collected the data. 
out.DataInfo.creator_email = 'Christof.Lorenz@kit.edu'; % (string)

% The institution of the person or group that collected the data. 
out.DataInfo.institution   = ...
    'Karlsruhe Institute of Technology, Institute of Meteorology and Climate Research (IMK-IFU)'; % (string)

% The scientific project that the data was collected under. 
out.DataInfo.project = ' '; % (string)

% Name of the person or group that distributes the data files. Use the 
% conventions described above when identifying persons and/or institutions 
% when applicable. 
out.DataInfo.publisher_name  = ''; % (string)

% URL of the person or group that distributes the data files. 
out.DataInfo.publisher_url   = ''; % (string)

% The email address of the person or group that distributes the data files. 
out.DataInfo.publisher_email = ''; % (string)



if strcmp(type, 'grid_3d')
    % Data represented or projected on a regular or irregular grid. 

    % ---------------------------------------------------------------------
    %                       GLOBAL ATTRIBUTES
    % ---------------------------------------------------------------------
    
    % Feature Type of the data according to the list at 
    % http://www.nodc.noaa.gov/data/formats/netcdf/v1.1/. See also the 
    % description at the beginning of this function.
    out.DataInfo.featureType   = 'grid'; % (string)
    
    % This attribute is used by THREDDS to identify the feature type, what
    % THREDDS calls a "dataType". The current choices are: Grid, Image, 
    % Station, Swath, and Trajectory. 
    out.DataInfo.cdm_data_type = 'grid'; % (string)
    
    % This attribute defines the units applied to the geospatial_lat_min
    % and geospatial_lat_max attributes. 
    out.DataInfo.geospatial_lat_min = NaN; % (float)
    out.DataInfo.geospatial_lat_max = NaN; % (float)
    out.DataInfo.geospatial_lon_min = NaN; % (float)
    out.DataInfo.geospatial_lon_max = NaN; % (float)
    
    % This attribute defines the units applied to the geospatial_lat_min 
    % and geospatial_lat_max attributes. 
    out.DataInfo.geospatial_lat_units      = ''; % (string)
    out.DataInfo.geospatial_lat_resolution = ''; % (string)
    out.DataInfo.geospatial_lon_units      = ''; % (string)
    out.DataInfo.geospatial_lon_resolution = ''; % (string)
    
    % ---------------------------------------------------------------------
    %                       VARIABLE ATTRIBUTES
    %  The different attributes are explained only for the first variable.
    % ---------------------------------------------------------------------
    
    % A free-text field to describe the variable. 
    out.Variables.lat.long_name      = ''; % (string)
    
    % Standardized field which uses the CF Standard Names 
    % (http://www.cfconventions.org/documents.html/). If a variables 
    % does not have an existing standard_name in the CF-managed list, this 
    % attribute should not be used. In these cases, a standard name can be 
    % proposed to the CF community for consideration and acceptance. 
    out.Variables.lat.standard_name  = 'latitude'; % (string)
    
    % Required for most all variables that represent dimensional 
    % quantities. The value should come from udunits
    % (http://www.unidata.ucar.edu/software/udunits/) authoritative 
    % vocabulary, which is documented in the CF standard name table with 
    % it's corresponding standard name. The udunits package includes a file 
    % udunits.dat which lists its supported unit names. 
    out.Variables.lat.units          = 'degrees_north'; % (string)
    
    % This attribute is specifically for the variables time, latitude, 
    % longitude, and altitude when they are identified as the coordinate
    % variables. The values of each variable coordinates axis are as 
    % follows: time = T, latitude = Y, longitude = X, and altitude = Z 
    out.Variables.lat.axis           = 'Y'; % (char)
    
    % Name of the variable which contains the vertices of the cell 
    % boundaries. This attribute must be present for all the coordinate 
    % variables which are used within cell_methods for representing 
    % non-point statistics 
    out.Variables.lat.bounds         = ''; % (string)
    
    out.Variables.lon.long_name      = '';
    out.Variables.lon.standard_name  = 'longitude';
    out.Variables.lon.units          = 'degrees_east';
    out.Variables.lon.axis           = 'X';
    out.Variables.lon.bounds         = '';
    
    out.Variables.time.long_name     = '';
    out.Variables.time.standard_name = 'time';
    out.Variables.time.calendar      = 'standard';
    out.Variables.time.units         = '';
    out.Variables.time.axis          = 'T';
    out.Variables.time.bounds        = '';
    
    for i = 1:length(varargin)
        out.Variables.(varargin{i}).long_name     = '';
        out.Variables.(varargin{i}).standard_name = '';
        out.Variables.(varargin{i}).units         = '';
        out.Variables.(varargin{i}).bounds        = '';
    
        % This attribute along with add_offset is used for unpacking data or 
        % for converting the data to CF valid units. CF places a lot of 
        % restrictions on the use of these attributes. Please read the CF 
        % documentation for best practices. 
        out.Variables.(varargin{i}).scale_factor  = 1; % (float)
    
        % This attribute along with scale_factor is used for unpacking data or 
        % for converting the data to CF valid units. CF places a lot of 
        % restrictions on the use of these attributes. Please read the CF 
        % documentation for best practices. 
        out.Variables.(varargin{i}).add_offset    = 0; % (float)
    
        % Maximum possible value of a variable. Note that if the data values 
        % are packed with scale_factor and add_offset, these values are packed 
        % too. 
        out.Variables.(varargin{i}).valid_max     = NaN; % (float)
        % Minimum possible value of a variable. Note that if the data values 
        % are packed with scale_factor and add_offset, these values are packed 
        % too. 
        out.Variables.(varargin{i}).valid_max     = NaN; % (float)
    
        % This attribute contains a space seperated list of all the coordinates 
        % corresponding to the variable. The list should contain all the 
        % auxiliary coordinate variables and optionally the coordinate 
        % variables. 
        out.Variables.(varargin{i}).coordinates   = 'time lat lon'; % (string)
    
        % Describes the horizontal coordinate system used by the data. The 
        % grid_mapping attribute should point to a variable which would contain 
        % the parameters corresponding to the coordinate system. There are 
        % typically several parameters associated with each coordinate system. 
        % CF defines a separate attributes for each of the parameters. Some 
        % examples are "semi_major_axis", "inverse_flattening", "false_easting" 
        out.Variables.(varargin{i}).grid_mapping  = ''; % (string)
    
        out.Variables.(varargin{i}).source        = ''; % (string)
        out.Variables.(varargin{i}).references    = ''; % (string)
        out.Variables.(varargin{i}).comment       = ''; % (string)
    
        % This value is considered to be a special value that indicates 
        % undefined or missing data, and is returned when reading values that 
        % were not written. 
        out.Variables.(varargin{i}).FillValue     = NaN; % (float)
    end
       
    
    out.Dimensions{1, 1}   = 'time';
    out.Dimensions{1, 2}   = 'lat';
    out.Dimensions{1, 3}   = 'lon';
    
    
elseif strcmp(type, 'grid_4d')
    
        % Data represented or projected on a regular or irregular grid. 

    % ---------------------------------------------------------------------
    %                       GLOBAL ATTRIBUTES
    % ---------------------------------------------------------------------
    
    % Feature Type of the data according to the list at 
    % http://www.nodc.noaa.gov/data/formats/netcdf/v1.1/. See also the 
    % description at the beginning of this function.
    out.DataInfo.featureType   = 'grid'; % (string)
    
    % This attribute is used by THREDDS to identify the feature type, what
    % THREDDS calls a "dataType". The current choices are: Grid, Image, 
    % Station, Swath, and Trajectory. 
    out.DataInfo.cdm_data_type = 'grid'; % (string)
    
    % This attribute defines the units applied to the geospatial_lat_min
    % and geospatial_lat_max attributes. 
    out.DataInfo.geospatial_lat_min = NaN; % (float)
    out.DataInfo.geospatial_lat_max = NaN; % (float)
    out.DataInfo.geospatial_lon_min = NaN; % (float)
    out.DataInfo.geospatial_lon_max = NaN; % (float)
    
    % This attribute defines the units applied to the geospatial_lat_min 
    % and geospatial_lat_max attributes. 
    out.DataInfo.geospatial_lat_units      = ''; % (string)
    out.DataInfo.geospatial_lat_resolution = ''; % (string)
    out.DataInfo.geospatial_lon_units      = ''; % (string)
    out.DataInfo.geospatial_lon_resolution = ''; % (string)
    
    % These attributes define the lowest and highest vertical measurements 
    % of the data set's bounding box. 
    out.DataInfo.geospatial_vertical_min   = NaN; % (float)
    out.DataInfo.geospatial_vertical_max   = NaN; % (float)
        
    % This defines the units applied to the geospatial_vertical_min and 
    % geospatial_vertical_max attributes.
    out.DataInfo.geospatial_vertical_units     = ''; %  (string)
   
    % This defines the resolution of the vertical axis values.
    out.DataInfo.geospatial_verticalresolution = ''; %  (string)
    
    % This attribute indicates which direction is positive (a value of "up" 
    % means that z increases up, like units of height, while a value of 
    % "down" means that z increases downward, like units of pressure or 
    % depth). 
    out.DataInfo.geospatial_vertical_positive  = ''; %  (string)
    
    % ---------------------------------------------------------------------
    %                       VARIABLE ATTRIBUTES
    %  The different attributes are explained only for the first variable.
    % ---------------------------------------------------------------------
    
    % A free-text field to describe the variable. 
    out.Variables.Lat.long_name      = ''; % (string)
    
    % Standardized field which uses the CF Standard Names 
    % (http://www.cfconventions.org/documents.html/). If a variables 
    % does not have an existing standard_name in the CF-managed list, this 
    % attribute should not be used. In these cases, a standard name can be 
    % proposed to the CF community for consideration and acceptance. 
    out.Variables.Lat.standard_name  = 'latitude'; % (string)
    
    % Required for most all variables that represent dimensional 
    % quantities. The value should come from udunits
    % (http://www.unidata.ucar.edu/software/udunits/) authoritative 
    % vocabulary, which is documented in the CF standard name table with 
    % it's corresponding standard name. The udunits package includes a file 
    % udunits.dat which lists its supported unit names. 
    out.Variables.Lat.units          = 'degrees_north'; % (string)
    
    % This attribute is specifically for the variables time, latitude, 
    % longitude, and altitude when they are identified as the coordinate
    % variables. The values of each variable coordinates axis are as 
    % follows: time = T, latitude = Y, longitude = X, and altitude = Z 
    out.Variables.Lat.axis           = 'Y'; % (char)
    
    % Name of the variable which contains the vertices of the cell 
    % boundaries. This attribute must be present for all the coordinate 
    % variables which are used within cell_methods for representing 
    % non-point statistics 
    out.Variables.Lat.bounds         = ''; % (string)
    
    out.Variables.Lon.long_name      = ''; % (string)
    out.Variables.Lon.standard_name  = 'longitude'; % (string)
    out.Variables.Lon.units          = 'degrees_east'; % (string)
    out.Variables.Lon.axis           = 'X'; % (string)
    out.Variables.Lon.bounds         = ''; % (string)
    
    out.Variables.time.long_name     = ''; % (string)
    out.Variables.time.standard_name = 'time'; % (string)
    out.Variables.time.calendar      = 'standard'; % (string)
    out.Variables.time.units         = ''; % (string)
    out.Variables.time.axis          = 'T'; % (string)
    out.Variables.time.bounds        = ''; % (string)
    
    if isempty(varargin{1})
        z_name = 'Z';
    else
        z_name = varargin{1};
    end
    
    out.Variables.(z_name).long_name      = '';
    out.Variables.(z_name).standard_name  = '';
    out.Variables.(z_name).units          = '';
    out.Variables.(z_name).axis           = 'Z';
    out.Variables.(z_name).bounds         = '';
    out.Variables.(z_name).positive       = '';


    for i = 1:length(varargin)
        out.Variables.(varargin{i}).long_name     = '';
        out.Variables.(varargin{i}).standard_name = '';
        out.Variables.(varargin{i}).units         = '';
        out.Variables.(varargin{i}).bounds        = '';
    
        % This attribute along with add_offset is used for unpacking data or 
        % for converting the data to CF valid units. CF places a lot of 
        % restrictions on the use of these attributes. Please read the CF 
        % documentation for best practices. 
        out.Variables.(varargin{i}).scale_factor  = 1; % (float)
    
        % This attribute along with scale_factor is used for unpacking data or 
        % for converting the data to CF valid units. CF places a lot of 
        % restrictions on the use of these attributes. Please read the CF 
        % documentation for best practices. 
        out.Variables.(varargin{i}).add_offset    = 0; % (float)
    
        % Maximum possible value of a variable. Note that if the data values 
        % are packed with scale_factor and add_offset, these values are packed 
        % too. 
        out.Variables.(varargin{i}).valid_max     = NaN; % (float)
        % Minimum possible value of a variable. Note that if the data values 
        % are packed with scale_factor and add_offset, these values are packed 
        % too. 
        out.Variables.(varargin{i}).valid_max     = NaN; % (float)
    
        % This attribute contains a space seperated list of all the coordinates 
        % corresponding to the variable. The list should contain all the 
        % auxiliary coordinate variables and optionally the coordinate 
        % variables. 
        out.Variables.(varargin{i}).coordinates   = ['time lat lon ', ...
                                                        z_name]; % (string)
    
        % Describes the horizontal coordinate system used by the data. The 
        % grid_mapping attribute should point to a variable which would contain 
        % the parameters corresponding to the coordinate system. There are 
        % typically several parameters associated with each coordinate system. 
        % CF defines a separate attributes for each of the parameters. Some 
        % examples are "semi_major_axis", "inverse_flattening", "false_easting" 
        out.Variables.(varargin{i}).grid_mapping  = ''; % (string)
    
        out.Variables.(varargin{i}).source        = ''; % (string)
        out.Variables.(varargin{i}).references    = ''; % (string)
        out.Variables.(varargin{i}).comment       = ''; % (string)
    
        % This value is considered to be a special value that indicates 
        % undefined or missing data, and is returned when reading values that 
        % were not written. 
        out.Variables.(varargin{i}).FillValue     = NaN; % (float)
    end
       
    
    out.Dimensions{1, 1} = 'time';
    out.Dimensions{1, 2} = 'lat';
    out.Dimensions{1, 3} = 'lon';
    out.Dimensions{1, 4} = z_name;
       
end
    
    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
% elseif strcmp(type, 'timeSeries')
%     % A series of data points at the same spatial location with 
%     % monotonically increasing times. 
%     out.DataInfo.featureType   = 'timeSeries';
%     out.DataInfo.cdm_data_type = 'Station';
%     
% elseif strcmp(type, 'point')
%     % A single data point (having no implied coordinate relationship to 
%     % other points). 
%     out.DataInfo.featureType   = 'point';
%     out.DataInfo.cdm_data_type = 'Station';
%     
% 
% 
% 
% 
% out.DataInfo.Center       = [];
% out.DataInfo.Name         = [];
% out.DataInfo.ShortName    = [];
% out.DataInfo.Version      = [];
% out.DataInfo.VariableName = [];
% out.DataInfo.Type         = [];
% out.DataInfo.Unit         = [];
% out.DataInfo.TempRes      = [];
% out.DataInfo.SpatRes      = [];
% out.DataInfo.MissingValue = [];
% out.DataInfo.Reference    = [];
% out.DataInfo.URL          = [];
% out.DataInfo.Contact      = [];
% out.DataInfo.Owner        = [];
% out.DataInfo.Date         = [];
% out.DataInfo.UserInfo     = [];
% out.DataInfo.History      = [];
% 
% if strcmp(type, 'spatial_2d')
%     out.Grid.Type         = [];
%     out.Grid.Projection   = [];
%     out.Grid.Lat          = [];
%     out.Grid.Lon          = [];
%     
%     out.DateTime          = [];
%     out.TimeStamp         = [];
% end
% 
% if strcmp(type, 'spatial_3d')
%     out.Grid.Type         = [];
%     out.Grid.Projection   = [];
%     out.Grid.LevelType    = [];
%     out.Grid.Lat          = [];
%     out.Grid.Lon          = [];
%     out.Grid.Levels       = [];
%     
%     out.DateTime          = [];
%     out.TimeStamp         = [];
% end
% 
% if strcmp(type, 'mask')
%     out.Grid.Type         = [];
%     out.Grid.Projection   = [];
%     out.Grid.Lat          = [];
%     out.Grid.Lon          = [];
%     
%     out.MaskInfo.IDs      = [];
%     out.MaskInfo.IDNames  = [];
% end
% 
% if strcmp(type, 'aggregated')
%     out.Aggregate.Mask     = [];
%     out.Aggregate.MaskName = [];
%     out.Aggregate.IDs      = [];
%     out.Aggregate.IDNames  = [];
%     
%     out.DateTime          = [];
%     out.TimeStamp         = [];
% end
% 
% if strcmp(type, 'point')
%     out.Coords.CoordSystem = [];
%     out.Coords.Lat         = [];
%     out.Coords.Lon         = [];
%     out.Coords.Height      = [];
%     
%     out.DateTime           = [];
%     out.TimeStamp          = [];
% end
% 
% if strcmp(type, 'measured')
%     out.Coords.CoordSystem = [];
%     out.Coords.Lat         = [];
%     out.Coords.Lon         = [];
%     out.Coords.Height      = [];
%     
%     out.DateTime           = [];
%     out.TimeStamp          = [];
% end
% 
% out.Data                   = [];
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%     % These attributes define the lowest and highest vertical measurements 
%     % of the data set's bounding box. 
%     out.DataInfo.geospatial_vertical_min   = NaN; % (float)
%     out.DataInfo.geospatial_vertical_max   = NaN; % (float)
%     
%     % This defines the units applied to the geospatial_vertical_min and 
%     % geospatial_vertical_max attributes.
%     out.DataInfo.geospatial_vertical_units     = ' '; %  (string)
%     
%     % This defines the resolution of the vertical axis values.
%     out.DataInfo.geospatial_verticalresolution = ' '; %  (string)
%     
%     % This attribute indicates which direction is positive (a value of "up" 
%     % means that z increases up, like units of height, while a value of 
%     % "down" means that z increases downward, like units of pressure or 
%     % depth). 
%     out.DataInfo.geospatial_vertical_positive  = ' '; %  (string)
%     
%     