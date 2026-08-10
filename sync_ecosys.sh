#!/bin/bash
#
# Directory containing ROMS source code
ROMS_DIR=~/COAWST/COAWST_Eco/ROMS

ECO_DIR=${ROMS_DIR}/Nonlinear/Biology/reef_ecosys
MOD_DIR=${ROMS_DIR}/Modules
#
items=(
#  "test.txt"
  "mod_bivalve.F"
  "mod_coral.F"
  "mod_deb_model.F"
  "mod_decomposition.F"
  "mod_foodweb.F"
  "mod_geochem.F"
  "mod_macroalgae.F"
  "mod_reef_ecosys_param.F"
  "mod_reef_ecosys.F"
  "mod_seagrass.F"
  "mod_sedecosys.F"
)
items2=(
  "mod_aquaculture.F"
)
#
for item in "${items[@]}"; do
    echo "========================================"
    echo "ROMS to reef_ecosys: ${item}"
    rsync -avu ${ECO_DIR}/${item} src/${item}
    echo "----------------------------------------"
    echo "reef_ecosys to ROMS: ${item}"
    rsync -avu src/${item} ${ECO_DIR}/${item}
done
#
for item in "${items2[@]}"; do
    echo "========================================"
    echo "ROMS to reef_ecosys: ${item}"
    rsync -avu ${MOD_DIR}/${item} src/${item}
    echo "----------------------------------------"
    echo "reef_ecosys to ROMS: ${item}"
    rsync -avu src/${item} ${MOD_DIR}/${item}
done
#