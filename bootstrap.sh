apt-get install -y nodejs
apt-get install -y curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm
rvm reinstall 2.3.0
gem install bundler
apt-get install -y git
apt-get install -y cmake
apt-get install -y libmysqlclient-dev
apt-get install -y ruby-mysql libmysqlclient-dev
sudo apt-get install -y postgresql postgresql-contrib libpq-dev
git clone https://github.com/zeromq/libzmq
cd libzmq
./autogen.sh && ./configure && make -j 4
make check && make install && sudo ldconfig
apt-get install -y graphicsmagick
wget http://download.redis.io/releases/redis-3.2.1.tar.gz
tar xzf redis-3.2.1.tar.gz
cd redis-3.2.1
make
apt-get install -y tcl

