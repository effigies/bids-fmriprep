# Copyright (c) 2016, The developers of the Stanford CRN
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of crn_base nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This Dockerfile is to be built for testing purposes inside CircleCI,
# not for distribution within Docker hub.
# For that purpose, the Dockerfile is found in build/Dockerfile.

FROM poldracklab/neuroimaging-core:freesurfer-0.0.1

RUN curl -sSLO https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda2-latest-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm Miniconda2-latest-Linux-x86_64.sh
ENV PATH /usr/local/miniconda/bin:$PATH

# Create conda environment, use nipype's conda-forge channel
RUN conda config --add channels conda-forge && \
    conda install -y numpy scipy matplotlib && \
    pip install -e git+https://github.com/nipy/nipype.git@master#egg=nipype && \
    pip install -e git+https://github.com/incf/pybids.git@master#egg=pybids && \
    python -c "from matplotlib import font_manager"

COPY run_fmriprep.sh /run_fmriprep
COPY version /version

RUN pip install "fmriprep>=0.1.2a3"

ENTRYPOINT ["/run_fmriprep"]
