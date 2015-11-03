function out = copy_datastruct(inpt, in_type, out_type)

out = create_datastruct(out_type);

if isfield(inpt, 'DataInfo')
    if isfield(inpt.DataInfo, 'Center')
        out.DataInfo.Center = inpt.DataInfo.Center;
    end
    
    if isfield(inpt.DataInfo, 'Name')
        out.DataInfo.Name   = inpt.DataInfo.Name;
    end
    
    if isfield(inpt.DataInfo, 'ShortName')
        out.DataInfo.ShortName   = inpt.DataInfo.ShortName;
    end
    
    if isfield(inpt.DataInfo, 'Version')
        out.DataInfo.Version = inpt.DataInfo.Version;
    end
    
    if isfield(inpt.DataInfo, 'VariableName')
        out.DataInfo.VariableName   = inpt.DataInfo.VariableName;
    end
    
    if isfield(inpt.DataInfo, 'Type')
        out.DataInfo.Type = inpt.DataInfo.Type;
    end
    
    if isfield(inpt.DataInfo, 'Unit')
        out.DataInfo.Unit   = inpt.DataInfo.Unit;
    end
    
    if isfield(inpt.DataInfo, 'TempRes')
        out.DataInfo.TempRes = inpt.DataInfo.TempRes;
    end
    
    if isfield(inpt.DataInfo, 'SpatRes')
        out.DataInfo.SpatRes   = inpt.DataInfo.SpatRes;
    end
    
    if isfield(inpt.DataInfo, 'MissingValue')
        out.DataInfo.MissingValue   = inpt.DataInfo.MissingValue;
    end
    
    if isfield(inpt.DataInfo, 'Reference')
        out.DataInfo.Reference = inpt.DataInfo.Reference;
    end
    
    if isfield(inpt.DataInfo, 'URL')
        out.DataInfo.URL   = inpt.DataInfo.URL;
    end
    
    if isfield(inpt.DataInfo, 'Contact')
        out.DataInfo.Contact   = inpt.DataInfo.Contact;
    end
    
    if isfield(inpt.DataInfo, 'UserInfo')
        out.DataInfo.UserInfo  = inpt.DataInfo.UserInfo;
    end
    
    if isfield(inpt.DataInfo, 'History')
        out.DataInfo.History  = inpt.DataInfo.History;
    end
    
end

if strcmp(in_type, 'spatial_2d')
    if strcmp(out_type, 'spatial_2d')
        if isfield(inpt.Grid, 'Type')
            out.Grid.Type = inpt.Grid.Type;
        end
        if isfield(inpt.Grid, 'Projection')
            out.Grid.Projection = inpt.Grid.Projection;
        end
        if isfield(inpt.Grid, 'Lat')
            out.Grid.Lat = inpt.Grid.Lat;
        end
         if isfield(inpt.Grid, 'Lon')
            out.Grid.Lon = inpt.Grid.Lon;
         end
    end
end

if strcmp(in_type, 'aggregated')
    if strcmp(out_type, 'aggregated')
        if isfield(inpt.Aggregate, 'Mask')
            out.Aggregate.Mask = inpt.Aggregare.Mask;
        end
        if isfield(inpt.Aggregate, 'IDs')
            out.Aggregate.IDs = inpt.Aggregare.IDs;
        end
        if isfield(inpt.Aggregate, 'IDNames')
            out.Aggregate.Names = inpt.Aggregare.Names;
        end
    end
end

if strcmp(in_type, 'points')
    if strcmp(out_type, 'points')
        if isfield(inpt.Coords, 'CoordSystem')
            out.Coords.CoordSystem = inpt.Coords.CoordSystem;
        end
        if isfield(inpt.Coords, 'Lat')
            out.Coords.Lat     = inpt.Coords.Lat;
        end
        if isfield(inpt.Coords, 'Lon')
            out.Coords.Lon     = inpt.Coords.Lon;
        end
        if isfield(inpt.Coords, 'Heights')
            out.Coords.Heights = inpt.Coords.Heights;
        end
    end
end






