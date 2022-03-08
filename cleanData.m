function [data] = cleanData(folder)
    VCO1Range = [63e6 0;102e6 15;];
    VCO2Range = [95e6 0;197e6 15;];
    VCO3Range = [198e6 0;364e6 15;];
    VCO4Range = [351e6 0;1544e6 15;];

    data = [];

    files = dir(fullfile(folder, "VC*"));
    for i = 1:length(files)
        baseName = files(i).name;
        fullName = fullfile(folder,baseName);
        dataIn = importdata(fullName);
        
        if contains(baseName, "VCO1")
            dataIn(:,1) = interp1(VCO1Range(:,2), VCO1Range(:,1), dataIn(:,1),'linear');
        elseif contains(baseName, "VCO2")
            dataIn(:,1) = interp1(VCO2Range(:,2), VCO2Range(:,1), dataIn(:,1),'linear');
        elseif contains(baseName, "VCO3")
            dataIn(:,1) = interp1(VCO3Range(:,2), VCO3Range(:,1), dataIn(:,1),'linear');
        elseif contains(baseName, "VCO4")
            dataIn(:,1) = interp1(VCO4Range(:,2), VCO4Range(:,1), dataIn(:,1),'linear');
        else
            error('File naming convention does not include VCOX designation!')
        end

        data = [data; dataIn];
    end
end