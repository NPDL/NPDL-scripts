#!/bin/bash

# Configuration file for NPDL Scripts
# ===================================

# Automatically export variables
set -a

# Dependency setup
# -----------------

# Required dependencies, and suggested versions:
# - FSL (5.0.9)
# - Freesurfer (5.3.0)
# - HCP Workbench (1.1.1)
# - Mricron (2014-08-04)
# - Python (2.7) [docopt, matplotlib, nibabel, numpy, gdist]
# - Imagemagick

# Optional:
# - FSL-Fix (1.062 beta)
#   - R (> 3.2.0) [kernlab, ROCR, class, party, e1071, randomForest]
#   - MATLAB
# - ICA-AROMA (0.3_beta)

# Assign directory paths below according to your setup.

# FSL setup.
FSLDIR=
source $FSLDIR/etc/fslconf/fsl.sh

# Freesurfer setup.
# Note: An updated ``mris_convert`` command is needed for ``postrecon`` to
# work. Specifically we need the "--cras_correction" option. 
# A Centos6 binary is included in ``lib``.
FREESURFER_HOME=
source $FREESURFER_HOME/SetUpFreeSurfer.sh
doublebufferflag=1 # Needed to make tksurfer work, as of 10/16/14

# HCP Workbench setup.
WB_DIR=
PATH=$PATH:$WB_DIR/bin_rh_linux64

# Mricron setup.
MRICRON_DIR=
PATH=$PATH:$MRICRON_DIR

# Script-specific setup
# ---------------------

# General settings
if [[ -z $NPDL_SCRIPT_DIR ]]; then
  NPDL_SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
fi
PATH=$PATH:$NPDL_SCRIPT_DIR/bin
source $NPDL_SCRIPT_DIR/lib/npdl_funcs.sh

# Set default SUBJECTS_DIR. Important because many functions rely on the
# existence of 32k_fs_LR surfaces.
SUBJECTS_DIR=$NPDL_SCRIPT_DIR/subjects

# ``parfetch`` configuration variables.
# Assign according to your setup.
PF_SERVER_ADDR=
PF_PORT=22
PF_LAB_DIR=

# ``preproc`` configuration variables.
# Assign Fix/Aroma variables or leave empty if not installed.
FIX_DIR=
FIX_RDATA=
AROMA_DIR=
PRPRC_TEMP=$NPDL_SCRIPT_DIR/etc/preproc_template_design.fsf

# Add python utilities to python path
PYTHONPATH=$PYTHONPATH:$NPDL_SCRIPT_DIR/lib

# ------------------------------------------------------------------------------

# Check environment
# -----------------

if [[ ! -d $FSLDIR || ! -d $FREESURFER_HOME || ! -d $WB_DIR || ! -d $MRICRON_DIR ]]; then
  echo "WARNING: Dependency paths not configured." >&2
fi

if [[ -z $PF_SERVER_ADDR || -z $PF_PORT || -z $PF_LAB_DIR ]]; then
  echo "WARNING: parfetch environment variables not configured." >&2
fi
