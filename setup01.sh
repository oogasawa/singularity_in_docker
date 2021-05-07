

# https://stackoverflow.com/questions/34408298/how-to-run-nvm-command-from-bash-script
install_nodejs() {
	mkdir -p ~/local/src
	cd ~/local/src
	
	sudo apt remove -y nodejs nodejs-doc libnode64
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	. $HOME/.nvm/nvm.sh
	. $HOME/.nvm/bash_completion
	nvm install v14.16.1
	nvm use v14.16.1

	npm install -g typescript @types/node ts-node
	npm install -g typedoc jsdoc 
	npm install -g pkg yarn
	npm install -g tslint
}


install_GCC() {
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt install -y gcc-9 g++-9
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100
}



install_anaconda() {

	# Install Anaconda
	# https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/debian/Dockerfile
	
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion
	sudo apt-get clean
	
	wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O ~/anaconda.sh 
	/bin/bash ~/anaconda.sh -b #-p /opt/conda #-b means batch mode, which skips licence agreement prompts.
	# rm ~/anaconda.sh
	# ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
	# echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc 
	# echo "conda activate base" >> ~/.bashrc 
	# find /opt/conda/ -follow -type f -name '*.a' -delete 
	# find /opt/conda/ -follow -type f -name '*.js.map' -delete 
	# /opt/conda/bin/conda clean -afy
}


# https://github.com/oogasawa/docker_bio/blob/main/Dockerfile
install_python_packages() {
	conda update -y -n base -c defaults conda --force && conda update -y --all
	conda config --add channels bioconda
	conda config --add channels conda-forge
	# conda install -y -c bioconda gffutils pyvcf dendropy genepop trimal eigensoft pysam
	# conda remove -y numpy
	conda install -y -c numpy pandas
	pip install  pygenomics # pygraphviz
}


install_R() {

	# Install dependencies
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get install -y git wget build-essential unzip graphviz
	sudo apt-get install -y libgraphviz-dev pkg-config swig libx11-dev libgsl0-dev
	sudo apt-get install -y libopenblas-dev liblapacke-dev
	sudo apt-get install -y gfortran libreadline-dev libxt-dev libbz2-dev liblzma-dev libpcre2-dev libpcre3-dev
	sudo apt-get install -y libcurl4-nss-dev libiconv-hook-dev

	mkdir -p ~/local/src
	cd ~/local/src

	# Install PCRE (Perl-compatible regular expression library)
	wget https://ftp.pcre.org/pub/pcre/pcre2-10.36.tar.gz
	tar zxvf pcre2-10.36.tar.gz
	cd pcre2-10.36
	./configure
	make -j 4
	sudo make install

	# Install R
	R_VERSION=4.0.5
	R_MAJOR=4
	
	if [ -e R-${R_VERSION}.tar.gz ]; then
		echo "R-${R_VERSION}.tar.gz already exists."
	else
		wget https://cran.ism.ac.jp/src/base/R-${R_MAJOR}/R-${R_VERSION}.tar.gz
	fi
	tar xzvf R-${R_VERSION}.tar.gz
	cd R-${R_VERSION}
	
	./configure --prefix=$HOME/local --x-includes=/usr/include/X11 --x-libraries=/usr/lib/X11 --enable-R-shlib
	make -j 4
	make install
}

# https://biowize.wordpress.com/2013/05/23/batch-installation-of-r-packages/
install_R_packages() {

	# Install R packages
	Rscript -e 'install.packages("ggplot2", repos="https://cran.ism.ac.jp")'
	Rscript -e 'install.packages("gridextra", repos="https://cran.ism.ac.jp")'
	# Rscript -e 'install.packages("rpy2", repos="https://cran.ism.ac.jp")'

	pip install rpy2
}


install_biotools() {
	# sudo apt-get install -y samtools mafft muscle raxml tabix
	sudo apt-get install -y plink1.9
}


install_BioinformaticsWithPython2ndEd() {
	git clone https://github.com/PacktPublishing/Bioinformatics-with-Python-Cookbook-Second-Edition.git
}



# ---

# Install basic analysis tools.
# https://raw.githubusercontent.com/PacktPublishing/Bioinformatics-with-Python-Cookbook-Second-Edition/master/docker/Dockerfile

function main {
	install_GCC
	install_anaconda
	install_python_packages
	install_R
	install_R_packages
	install_nodejs
	install_biotools
	# install_BioinformaticsWithPython2ndEd
}


main
