FROM python:3.6-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
     gcc \
     libc6-dev \
     git \
     make \
     pkg-config \
     swig \
     # To build (astrometry.net) without warnings, need:
     # zlib1g-dev \
     # libcfitsio-dev \
     # libcairo2-dev \
     # libjpeg-dev \
     # libnetpbm10-dev \
     # netpbm \
&& rm -rf /var/lib/apt/lists/*

# Create working dir /app
WORKDIR /app
ADD requirements.txt /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Install dependencies that require numpy to be installed to run setup.py
RUN pip install photutils
RUN pip install git+https://github.com/esheldon/fitsio.git#egg=fitsio

RUN pip install -v git+https://github.com/dstndstn/astrometry.net.git#egg=astrometry

# Clone and run in-place the tractor and legacypipe repositories.
RUN git clone https://github.com/dstndstn/tractor.git tractor-git
RUN (cd tractor-git; make)
RUN ln -s tractor-git/tractor .
RUN ln -s tractor-git/wise .

RUN git clone https://github.com/legacysurvey/legacypipe.git legacypipe-git
RUN ln -s legacypipe-git/py/legacypipe .

# Install a small (~6 MB) example
ADD demo-data-1 /app/demo-data-1

ENV PYTHONPATH ${PYTHONPATH}:.

# Can run this to generate a "pickle" file that caches the inputs to the time-consuming stage of the processing.
# RUN python legacypipe/runbrick.py --survey-dir demo-data-1 --outdir out-1 --brick 2420p090 --zoom 1800 2000 1800 2000     --no-wise --write-stage srcs --stage srcs

# Benchmark -- takes about 90 seconds to run.
CMD "python legacypipe/runbrick.py --survey-dir demo-data-1 --outdir out-1 --brick 2420p090 --zoom 1800 2000 1800 2000 --no-write --stage fitblobs"
