Legendaries = {
    [-1433814131] = { model = 'MP_A_C_COUGAR_01', validOutfit = { 0, 1, 2 } },     -- Cougar
    [-915290938]  = { model = 'MP_A_C_BUFFALO_01', validOutfit = { 0, 1, 2 } },    -- Buffalo
    [-1754211037] = { model = 'MP_A_C_BUCK_01', validOutfit = { 2, 3, 4 } },       -- Buck
    [674287411]   = { model = 'MP_A_C_ALLIGATOR_01', validOutfit = { 0, 1, 2 } },  -- Alligator
    [-1149999295] = { model = 'MP_A_C_BEAVER_01', validOutfit = { 0, 1, 2 } },     -- Beaver
    [-781967776]  = { model = 'MP_A_C_ELK_01', validOutfit = { 1, 2, 3 } },        -- Elk
    [-1392359921] = { model = 'MP_A_C_WOLF_01', validOutfit = { 0, 1, 2 } },       -- Wolf
    [-1189368951] = { model = 'MP_A_C_PANTHER_01', validOutfit = { 0, 1, 2 } },    -- Panther
    [-511163808]  = { model = 'MP_A_C_BIGHORNRAM_01', validOutfit = { 0, 1, 2 } }, -- Ram
    [-117665949]  = { model = 'MP_A_C_MOOSE_01', validOutfit = { 1, 2, 3 } },      -- Moose
    [-1307757043] = { model = 'MP_A_C_COYOTE_01', validOutfit = { 0, 1, 2 } },     -- Coyote
    [-389300196]  = { model = 'MP_A_C_BOAR_01', validOutfit = { 0, 1, 2 } },       -- Boar
    [-551216071]  = { model = 'MP_A_C_BEAR_01', validOutfit = { 1, 2, 3 } },       -- Bear
    [-557149691]  = { model = 'MP_A_C_FOX_01', validOutfit = { 0, 1, 2 } },        -- Fox
}

function IsOutfitValidForHash(modelHash, outfit)
    local entry = Legendaries[modelHash]
    if not entry then
        return true -- The index does not exist in the Legendaries table, return true by default
    end

    for _, validOutfit in ipairs(entry.validOutfit) do
        if validOutfit == outfit then
            return true -- The outfit exists for the given index
        end
    end

    return false
end
