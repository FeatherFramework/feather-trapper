function RoundToTwoDecimals(num)
    local rounded = math.floor(num * 100 + 0.5) / 100
    if rounded == math.floor(rounded) then
        return tostring(math.floor(rounded))
    else
        return string.format("%.2f", rounded)
    end
end

function Dump(o, indent)
    indent = indent or '' -- default value for indentation if not provided
    if type(o) == 'table' then
        local s = '{\n'
        local innerIndent = indent .. '  ' -- increase indentation for nested tables
        for k, v in pairs(o) do
            if type(k) == 'string' then
                k = '"' .. k .. '"'
            end
            s = s .. innerIndent .. '[' .. k .. '] = ' .. Dump(v, innerIndent) .. ',\n'
        end
        return s .. indent .. '}'
    elseif type(o) == 'string' then
        return '"' .. o .. '"'
    else
        return tostring(o)
    end
end
