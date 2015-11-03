function out = create_datastruct(type)

out.DataInfo.Center       = [];
out.DataInfo.Name         = [];
out.DataInfo.ShortName    = [];
out.DataInfo.Version      = [];
out.DataInfo.VariableName = [];
out.DataInfo.Type         = [];
out.DataInfo.Unit         = [];
out.DataInfo.TempRes      = [];
out.DataInfo.SpatRes      = [];
out.DataInfo.MissingValue = [];
out.DataInfo.Reference    = [];
out.DataInfo.URL          = [];
out.DataInfo.Contact      = [];
out.DataInfo.Owner        = [];
out.DataInfo.Date         = [];
out.DataInfo.UserInfo     = [];
out.DataInfo.History      = [];

if strcmp(type, 'spatial_2d')
    out.Grid.Type         = [];
    out.Grid.Projection   = [];
    out.Grid.Lat          = [];
    out.Grid.Lon          = [];
    
    out.DateTime          = [];
    out.TimeStamp         = [];
end

if strcmp(type, 'spatial_3d')
    out.Grid.Type         = [];
    out.Grid.Projection   = [];
    out.Grid.LevelType    = [];
    out.Grid.Lat          = [];
    out.Grid.Lon          = [];
    out.Grid.Levels       = [];
    
    out.DateTime          = [];
    out.TimeStamp         = [];
end

if strcmp(type, 'mask')
    out.Grid.Type         = [];
    out.Grid.Projection   = [];
    out.Grid.Lat          = [];
    out.Grid.Lon          = [];
    
    out.MaskInfo.IDs      = [];
    out.MaskInfo.IDNames  = [];
end

if strcmp(type, 'aggregated')
    out.Aggregate.Mask     = [];
    out.Aggregate.MaskName = [];
    out.Aggregate.IDs      = [];
    out.Aggregate.IDNames  = [];
    
    out.DateTime          = [];
    out.TimeStamp         = [];
end

if strcmp(type, 'point')
    out.Coords.CoordSystem = [];
    out.Coords.Lat         = [];
    out.Coords.Lon         = [];
    out.Coords.Height      = [];
    
    out.DateTime           = [];
    out.TimeStamp          = [];
end

if strcmp(type, 'measured')
    out.Coords.CoordSystem = [];
    out.Coords.Lat         = [];
    out.Coords.Lon         = [];
    out.Coords.Height      = [];
    
    out.DateTime           = [];
    out.TimeStamp          = [];
end

out.Data                   = [];