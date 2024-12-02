-- GTA IPL Importer for 3ds Max 2020
-- This script imports IPL files and places DFF models from a specified root folder

-- Load required GTA Tools scripts
if DFFinInfo == undefined then fileIn (scriptspath+"\\GTA_Tools\\CharDFFimp.mse") quiet:true
else if DFFinInfo() != 051025 then fileIn (scriptspath+"\\GTA_Tools\\CharDFFimp.mse") quiet:true

if DFFoutInfo == undefined then fileIn (scriptspath+"\\GTA_Tools\\CharDFFexp.mse") quiet:true
else if DFFoutInfo() != 051012 then fileIn (scriptspath+"\\GTA_Tools\\CharDFFexp.mse") quiet:true

try ( fileIn (scriptspath+"\\GTA_Tools\\GTA_Helper_v31.ms") quiet:true ) catch()
try ( fileIn (scriptspath+"\\Startup\\GTA_Material.ms") quiet:true ) catch()

-- Global variables required by GTA Tools
Global SPscale = 1.0
Global Dummysize = 0.1
Global bonechain = #()

struct IPLObject
(
    modelName,
    pos,
    rot
)

rollout ImportIPLRollout "GTA IPL Importer" width:400 height:350
(
    group "File Paths"
    (
        edittext txt_iplPath "IPL File:" width:300 align:#left
        button btn_browseIPL "Browse IPL" width:80 align:#right offset:[0,-25]
        
        edittext txt_dffPath "DFF Root Folder:" width:300 align:#left
        button btn_browseDFF "Browse" width:80 align:#right offset:[0,-25]
    )
    
    group "Import Settings"
    (
        checkbox chk_createDummy "Create Dummy Objects for Missing Models" checked:true
        spinner spn_scale "Scale:" range:[0.001,1000,1] type:#float align:#left width:100
        radiobuttons textype "" labels:#("TGA", "BMP") align:#left
    )
    
    button btn_import "Import IPL" width:150 height:30 align:#center
    
    -- Function to parse IPL file
    fn parseIPLLine line =
    (
        local obj = undefined
        
        -- Remove leading/trailing whitespace
        line = trimRight (trimLeft line)
        
        -- Skip empty lines and comments
        if line.count == 0 or line[1] == "#" do return undefined
        
        -- Split by commas and/or spaces
        local parts = filterString line ", \t"
        parts = for p in parts where p.count > 0 collect (trimRight (trimLeft p))
        
        -- Check if we have enough parts for a valid object
        if parts.count >= 7 do
        (
            obj = IPLObject()
            
            -- Handle different IPL formats
            if parts.count >= 10 then -- GTA3/SA format (ID, ModelName, Interior, Pos, Rot)
            (
                obj.modelName = parts[2]
                obj.pos = point3 (parts[4] as float) (parts[5] as float) (parts[6] as float)
                obj.rot = eulerAngles (parts[7] as float) (parts[8] as float) (parts[9] as float)
            )
            else -- Simple format (ModelName, Pos, Rot)
            (
                obj.modelName = parts[1]
                obj.pos = point3 (parts[2] as float) (parts[3] as float) (parts[4] as float)
                obj.rot = eulerAngles (parts[5] as float) (parts[6] as float) (parts[7] as float)
            )
        )
        
        obj
    )
    
    -- Function to parse IPL file
    fn parseIPL filename =
    (
        local objects = #()
        local inInstSection = false
        
        try
        (
            local f = openFile filename mode:"r"
            
            while not eof f do
            (
                local line = readline f
                
                -- Handle section markers
                if (matchPattern line pattern:"*inst*") then
                (
                    inInstSection = true
                    continue
                )
                if (matchPattern line pattern:"*end*") then
                (
                    inInstSection = false
                    continue
                )
                
                -- Only parse lines in inst section or if no sections are used
                if not inInstSection and (matchPattern line pattern:"*inst*") then continue
                
                local obj = parseIPLLine line
                if obj != undefined do append objects obj
            )
            
            close f
        )
        catch
        (
            messageBox "Error reading IPL file!" title:"Error"
            if f != undefined do close f
            return #()
        )
        
        objects
    )
    
    -- Function to import DFF model
    fn importDFF dffPath scale =
    (
        local model = undefined
        try
        (
            local f = fopen dffPath "rb"
            if f != undefined then
            (
                local texExt = case textype.state of
                (
                    1: ".tga"
                    2: ".bmp"
                )
                
                model = DFFin f scale texExt Dummysize false false (getFilenameFile dffPath)
                fclose f
                gc()
            )
        )
        catch
        (
            format "Failed to import DFF: %\n" dffPath
        )
        
        model
    )
    
    -- Function to import all models
    fn importModels objects rootPath scale =
    (
        for obj in objects do
        (
            local dffPath = pathConfig.appendPath rootPath (obj.modelName + ".dff")
            local model = undefined
            
            if doesFileExist dffPath then
            (
                model = importDFF dffPath scale
            )
            else if chk_createDummy.checked then
            (
                model = dummy size:20
                model.name = obj.modelName + "_dummy"
            )
            
            if model != undefined do
            (
                model.pos = obj.pos * scale
                model.rotation = obj.rot
            )
        )
    )
    
    on btn_browseIPL pressed do
    (
        local filepath = getOpenFileName caption:"Select IPL File" types:"IPL File (*.ipl)|*.ipl|All Files (*.*)|*.*"
        if filepath != undefined do txt_iplPath.text = filepath
    )
    
    on btn_browseDFF pressed do
    (
        local folderpath = getSavePath caption:"Select DFF Root Folder"
        if folderpath != undefined do txt_dffPath.text = folderpath
    )
    
    on btn_import pressed do
    (
        if txt_iplPath.text == "" then
        (
            messageBox "Please select an IPL file!" title:"Error"
            return()
        )
        
        if txt_dffPath.text == "" then
        (
            messageBox "Please select DFF root folder!" title:"Error"
            return()
        )
        
        local objects = parseIPL txt_iplPath.text
        if objects.count > 0 then
        (
            importModels objects txt_dffPath.text spn_scale.value
            messageBox ("Successfully processed " + objects.count as string + " objects!") title:"Success"
        )
        else
        (
            messageBox "No valid objects found in IPL file!" title:"Warning"
        )
    )
)

-- Create and show the dialog
if ImportIPLRollout != undefined do destroyDialog ImportIPLRollout
createDialog ImportIPLRollout
