# benchmark
Docker image for benchmarking the legacypipe/tractor code

```
docker run dstndstn/benchmark:v1
```


Or, alternatively, on a typical Ubuntu dev machine, do:

```
# Install library dependencies
sudo apt-get install swig zlib1g-dev libcfitsio-dev libcairo2-dev \
     libjpeg-dev libnetpbm10-dev netpbm

# Install python dependencies
sudo pip install numpy
sudo pip install scipy
sudo pip install matplotlib
sudo pip install astropy
sudo pip install photutils
sudo pip install git+https://github.com/esheldon/fitsio.git#egg=fitsio
sudo pip install -v git+https://github.com/dstndstn/astrometry.net.git#egg=astrometry

# Clone and run in-place the tractor and legacypipe repositories.
git clone https://github.com/dstndstn/tractor.git tractor-git
(cd tractor-git; make)
ln -s tractor-git/tractor .
ln -s tractor-git/wise .

git clone https://github.com/legacysurvey/legacypipe.git legacypipe-git
ln -s legacypipe-git/py/legacypipe .

# Clone this repo to get the demo data.
git clone https://github.com/dstndstn/benchmark.git
ln -s benchmark/demo-data-1 .

# Use python packages in the current directory
export PYTHONPATH=${PYTHONPATH}:.

# Can run this to generate a "pickle" file that caches the inputs to the time-consuming stage of the processing.
python legacypipe/runbrick.py --survey-dir demo-data-1 --outdir out-1 --brick 2420p090 --zoom 1800 2000 1800 2000 --no-wise --write-stage srcs --stage srcs

# Benchmark -- takes about 90 seconds to run.
python legacypipe/runbrick.py --survey-dir demo-data-1 --outdir out-1 --brick 2420p090 --zoom 1800 2000 1800 2000 --no-write --stage fitblobs
```
