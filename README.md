# GTA IPL Importer for 3ds Max 2020

I've created a new IPL importer script with improved organization and error handling. This script imports IPL files and places DFF models from a specified root folder.
Here are the key features:

## Dependencies:
* Loads required GTA Tools scripts (CharDFFimp.mse, CharDFFexp.mse, GTA_Helper_v31.ms)
* Sets up necessary global variables
## User Interface:
* File path selection for IPL and DFF root folder
* Scale control
* Texture type selection (TGA/BMP)
* Option to create dummy objects for missing models
## IPL Parsing:
* Supports multiple IPL formats:
** GTA III/SA: ID, ModelName, Interior, PosX, PosY, PosZ, RotX, RotY, RotZ, LOD
** Simple: ModelName, PosX, PosY, PosZ, RotX, RotY, RotZ
* Handles inst/end sections
* Skips comments and empty lines
## DFF Import:
* Uses GTA Tools' DFF importer
* Supports both TGA and BMP textures
* Creates dummy objects for missing models (optional)
To use the script:

1. Make sure all GTA Tools scripts are properly installed
2. Run the script in 3ds Max 2020
3. In the dialog:
* Select your IPL file
* Choose the folder containing your DFF files
* Adjust scale if needed
* Select texture type (TGA/BMP)
* Click "Import IPL"
The script will import your models and place them according to the IPL file's specifications. If any DFF files are missing, it can create dummy objects to mark their positions.
