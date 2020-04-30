FROM postgres:12.2
RUN apt-get update

RUN apt-get install -y postgresql-server-dev-all postgresql-common git build-essential sudo
RUN git clone https://github.com/RhodiumToad/ip4r.git && cd ip4r/ && make && make install
RUN git clone https://github.com/citusdata/postgresql-hll.git && cd postgresql-hll/ && make && sudo make install

# Give postgres user sudo privileges
RUN usermod -a -G sudo postgres; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER postgres
WORKDIR /var/lib/postgresql

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432
