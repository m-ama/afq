#! /usr/bin/env python

# Parse a config file and create a dtiInit params json file.
def parse_config(input_file, output_file, input_dir, output_dir):
    import json

    # Read the config json file
    with open(input_file, 'r') as jsonfile:
        config = json.load(jsonfile)

    # Rename the config key to params
    config['params'] = config.pop('config')

    # Handle the 'track' fields
    config['params']['track'] = {}
    config['params']['track']['algorithm']          = config['params']['track_algorithm']
    config['params']['track']['angleThresh']        = config['params']['track_angleThresh']
    config['params']['track']['faMaskThresh']       = config['params']['track_faMaskThresh']
    config['params']['track']['faThresh']           = config['params']['track_faThresh']
    config['params']['track']['lengthThreshMm']     = [config['params']['track_minLengthThreshMm'], config['params']['track_maxLengthThreshMm']]
    config['params']['track']['nfibers']            = config['params']['track_nfibers']
    config['params']['track']['offsetJitter']       = config['params']['track_offsetJitter']
    config['params']['track']['seedVoxelOffsets']   = [config['params']['track_seedVoxelOffset_1'], config['params']['track_seedVoxelOffset_2']]
    config['params']['track']['stepSizeMm']         = config['params']['track_stepSizeMm']
    config['params']['track']['wPuncture']          = config['params']['track_wPuncture']
    config['params']['track']['whichAlgorithm']     = config['params']['track_whichAlgorithm']
    config['params']['track']['whichInterp']        = config['params']['track_whichInterp']

    # Remove the other track_ fields
    del config['params']['track_algorithm']
    del config['params']['track_angleThresh']
    del config['params']['track_faMaskThresh']
    del config['params']['track_faThresh']
    del config['params']['track_maxLengthThreshMm']
    del config['params']['track_minLengthThreshMm']
    del config['params']['track_nfibers']
    del config['params']['track_offsetJitter']
    del config['params']['track_seedVoxelOffset_1']
    del config['params']['track_seedVoxelOffset_2']
    del config['params']['track_stepSizeMm']
    del config['params']['track_wPuncture']
    del config['params']['track_whichAlgorithm']
    del config['params']['track_whichInterp']

    # Handle cutoffLower and cutoffUpper
    config['params']['cutoff'] = [config['params']['cutoffLower'], config['params']['cutoffUpper'] ]

    # Remove cutoff fields
    del config['params']['cutoffUpper']
    del config['params']['cutoffLower']

    # Handle QMR fields
    config['metadata'] = {}
    config['metadata']['age']           = config['params']['qmr_meatadata_age']
    config['metadata']['sex']           = config['params']['qmr_metadata_sex']
    config['metadata']['age_comp']      = config['params']['qmr_metadata_age_comp']
    config['metadata']['ndirs']         = config['params']['qmr_metadata_ndirs']
    config['metadata']['bvalue']        = config['params']['qmr_metadata_bvalue']
    config['params']['runcontrolcomp']  = config['params']['qmr_runcontrolcomp']

    # Remove qmr fields
    del config['params']['qmr_meatadata_age']
    del config['params']['qmr_metadata_sex']
    del config['params']['qmr_metadata_age_comp']
    del config['params']['qmr_metadata_ndirs']
    del config['params']['qmr_metadata_bvalue']
    del config['params']['qmr_runcontrolcomp']

    # Add input directory for dtiInit
    config['input_dir'] = input_dir
    config['output_dir'] = output_dir

    # Write out the modified configuration
    with open(output_file, 'w') as config_json:
        json.dump(config, config_json, sort_keys=True, indent=4, separators=(',', ': '))

if __name__ == '__main__':

    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('--input_file', default='/flwywheel/v0/config.json', help='Full path to the input file.')
    ap.add_argument('--output_file', default='/flywheel/v0/json/dtiinit_params.json', help='Full path to the output file.')
    ap.add_argument('--input_dir', default='/flwywheel/v0/input', help='Full path to the input file.')
    ap.add_argument('--output_dir', default='/flywheel/v0/output', help='Full path to the output file.')
    args = ap.parse_args()

    parse_config(args.input_file, args.output_file, args.input_dir, args.output_dir)
