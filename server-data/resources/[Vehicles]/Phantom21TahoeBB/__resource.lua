resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Assets template by Albo1125.
-- Look in the meta_templates folder for the default meta file entries when installing vehicles/peds into custom slots.
-- You can (un)comment or add/remove files depending on which ones you use.
-- Documentation of available data files for FiveM: https://wiki.fivem.net/wiki/Data_files

files {
	'carcols.meta',
        'vehicles.meta',
	'carvariations.meta'

	
}
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

client_script 'vehicle_names.lua'