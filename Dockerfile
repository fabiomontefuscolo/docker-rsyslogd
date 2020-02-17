FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

RUN yum install -y                                                                    \
        rsyslog                                                                       \
    && yum --enablerepo='*' clean all

RUN {                                                                                 \
        echo '$WorkDirectory /var/lib/rsyslog';                                       \
        echo '$FileOwner root';                                                       \
        echo '$FileGroup adm';                                                        \
        echo '$FileCreateMode 0640';                                                  \
        echo '$DirCreateMode 0755';                                                   \
        echo '$Umask 0022';                                                           \
        echo 'include(file="/etc/rsyslog.d/*.conf" mode="optional")';                 \
        echo 'module(load="immark")';                                                 \
        echo 'module(load="imklog")';                                                 \
        echo '*.emerg :omusrmsg:*';                                                   \
    } > /etc/rsyslog.conf                                                             \
    && {                                                                              \
        echo 'module(load="imtcp")';                                                  \
        echo 'input(type="imtcp" port="514")';                                        \
        echo 'module(load="imudp")';                                                  \
        echo 'input(type="imudp" port="514")';                                        \
        echo 'module(load="imuxsock")';                                               \
        echo 'input(type="imuxsock" Socket="/run/rsyslog/dev/log" CreatePath="on")';  \
        echo '$ModLoad omstdout.so';                                                  \
        echo '*.* :omstdout:';                                                        \
    } > /etc/rsyslog.d/docker-cyrus.conf

ENV SYSLOG_SOCK=/run/rsyslog/dev/log
VOLUME /run

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["rsyslogd", "-n", "-f", "/etc/rsyslogd.conf", "-i", "/run/rsyslogd.pid"]
