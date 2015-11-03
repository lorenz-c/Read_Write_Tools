function struct_out = add_levels(struct_in, z_name)



struct_out = struct_in;

% These attributes define the lowest and highest vertical measurements 
% of the data set's bounding box. 
struct_out.DataInfo.geospatial_vertical_min   = NaN; % (float)
struct_out.DataInfo.geospatial_vertical_max   = NaN; % (float)
%    
% This defines the units applied to the geospatial_vertical_min and 
% geospatial_vertical_max attributes.
struct_out.DataInfo.geospatial_vertical_units     = ' '; %  (string)
   
% This defines the resolution of the vertical axis values.
struct_out.DataInfo.geospatial_verticalresolution = ' '; %  (string)
    
% This attribute indicates which direction is positive (a value of "up" 
% means that z increases up, like units of height, while a value of 
% "down" means that z increases downward, like units of pressure or 
% depth). 
struct_out.DataInfo.geospatial_vertical_positive  = ' '; %  (string)


struct_out.Variables.(z_name).long_name      = ' ';
struct_out.Variables.(z_name).standard_name  = ' ';
struct_out.Variables.(z_name).units          = ' ';
struct_out.Variables.(z_name).axis           = 'Z';
struct_out.Variables.(z_name).bounds         = ' ';
struct_out.Variables.(z_name).positive       = ' ';
    
struct_out.Dimensions{1, end+1} =  z_name;


struct_out.DataInfo.history = strvcat(struct_out.DataInfo.history, ...
                                      [datestr(now) '; add_levels.m: Added vertical dimension']);

