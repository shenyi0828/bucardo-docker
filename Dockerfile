FROM postgres:13-alpine

LABEL maintainer="shenyi0828@gmail.com"

# Bucardo version
ARG version
ENV BUCARDO_VERSION ${version}

# Install Requirements (Perl)
RUN apk add --no-cache curl make perl perl-dbi perl-dbd-pg perl-pod-parser perl-encode-locale perl-cgi; \
    curl -L https://cpan.metacpan.org/authors/id/T/TU/TURNSTEP/DBIx-Safe-1.2.5.tar.gz -o dbix-safe.tar.gz; \
    tar x -f dbix-safe.tar.gz && cd DBIx-Safe-1.2.5 && perl Makefile.PL && make && make install; \
    cd .. && rm -rf DBIx-Safe-1.2.5 && rm dbix-safe.tar.gz
    # && cpanm TIMB/DBI-1.643.tar.gz \
    # && cpanm TURNSTEP/DBD-Pg-3.15.0.tar.gz \
    # && cpanm DBIx::Safe

# Install Requirements (postgres pl/perl module)
RUN apk add --no-cache postgresql-plperl postgresql-plperl-contrib; \
    set -eux; \
    cp -rfL /usr/share/postgresql/extension/* /usr/local/share/postgresql/extension/ && \
    cp -rfL /usr/lib/postgresql/* /usr/local/lib/postgresql/

# 
ARG user=bucardo
ARG group=postgres
ARG uid=3000

# Bucardo is run with user `bucardo`, uid = 3000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN adduser -u ${uid} -G ${group} ${user} -s /bin/bash -D
ENV BUCARDO_HOME  /home/${user}
WORKDIR  ${BUCARDO_HOME}

RUN mkdir /var/run/bucardo && chown bucardo:postgres /var/run/bucardo; \
    mkdir /var/log/bucardo && chown bucardo:postgres /var/log/bucardo
    

# Install Bucardo
RUN set -eux; \
    curl -L https://bucardo.org/downloads/Bucardo-${BUCARDO_VERSION}.tar.gz -o bucardo.tar.gz; \
    tar x -f bucardo.tar.gz && cd Bucardo-${BUCARDO_VERSION} && perl Makefile.PL && make && make install; \
    cd .. && rm -rf Bucardo-${BUCARDO_VERSION} && rm bucardo.tar.gz
    

# COPY etc/pg_hba.conf /etc/postgresql/9.5/main/
COPY --chown=bucardo:postgres etc/bucardorc /etc/bucardorc
COPY --chown=bucardo:postgres script/initialize.sh script/initialize.sh
RUN chmod +x script/initialize.sh

# VOLUME "/media/bucardo"
# CMD ["/bin/bash","-c","/entrypoint.sh"]
