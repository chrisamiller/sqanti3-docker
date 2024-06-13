FROM --platform=linux/x86_64 continuumio/miniconda3

RUN mkdir /app
WORKDIR /app

##install sqanti3
ENV SQVER 5.2.1
COPY v5.2.1.tar.gz /app/
#RUN wget https://github.com/ConesaLab/SQANTI3/archive/refs/tags/v$SQVER.tar.gz && \
RUN tar -xf v$SQVER.tar.gz && \
  rm v$SQVER.tar.gz && \
  rm -rf SQANTI3-$SQVER/.git && \
  rm -rf SQANTI3-$SQVER/example

#change a dependency version
RUN sed -i.bck 's/numpy/numpy==1.19.5/' /app/SQANTI3-$SQVER/SQANTI3.conda_env.yml

RUN conda update conda -y && \
    conda env create -f /app/SQANTI3-$SQVER/SQANTI3.conda_env.yml -y

# && \
#    conda clean --all --yes

RUN apt-get update && \
    apt-get install -y gcc && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV CCVER 29.0.1
RUN wget https://github.com/chrisamiller/cDNA_Cupcake/archive/refs/tags/v$CCVER.tar.gz && \
  tar xf v$CCVER.tar.gz && \
  rm v$CCVER.tar.gz && \
  rm -rf /app/cDNA_Cupcake-$CCVER/.git

SHELL ["/bin/bash", "-c"]
RUN source activate SQANTI3.env && \
  cd cDNA_Cupcake-$CCVER && \
  python setup.py build && \
  python setup.py install && \
  source deactivate
SHELL ["/bin/sh", "-c"]

ENV PYTHONPATH=$PYTHONPATH:/app/cDNA_Cupcake-$CCVER/sequence/

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
RUN source activate SQANTI3.env && \
    R -e 'install.packages(c("magrittr","ggplot2"),repos = "http://cran.us.r-project.org")' && \
  source deactivate
SHELL ["/bin/sh", "-c"]

# # Make python scripts executable
RUN chmod +x /app/SQANTI3-$SQVER/sqanti3_qc.py && \
    chmod +x /app/SQANTI3-$SQVER/sqanti3_filter.py


WORKDIR /root
