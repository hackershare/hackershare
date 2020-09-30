## PG extension install

### setup for ubuntu

* sudo apt install postgresql-server-dev-12

### zhparser

* https://github.com/amutu/zhparser#install

```
# scws
wget -q -O - http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2 | tar xf -

cd scws-1.2.3 ; ./configure ; make install

# zhparser
git clone https://github.com/amutu/zhparser.git

make && make install
```


### rum

* https://github.com/postgrespro/rum#installation

```
git clone https://github.com/postgrespro/rum
cd rum
make USE_PGXS=1
make USE_PGXS=1 install
make USE_PGXS=1 installcheck
```