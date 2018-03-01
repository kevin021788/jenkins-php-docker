# Official images are cool.
FROM jenkins
MAINTAINER limx <715557344@qq.com>

# Jenkins is using jenkins user, we need root to install things.
USER root

RUN mkdir -p /tmp/WEB-INF/plugins

# Install required jenkins plugins.
RUN curl -L https://updates.jenkins-ci.org/latest/checkstyle.hpi -o /tmp/WEB-INF/plugins/checkstyle.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/cloverphp.hpi -o /tmp/WEB-INF/plugins/cloverphp.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/crap4j.hpi -o /tmp/WEB-INF/plugins/crap4j.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/dry.hpi -o /tmp/WEB-INF/plugins/dry.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/htmlpublisher.hpi -o /tmp/WEB-INF/plugins/htmlpublisher.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/jdepend.hpi -o /tmp/WEB-INF/plugins/jdepend.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/plot.hpi -o /tmp/WEB-INF/plugins/plot.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/pmd.hpi -o /tmp/WEB-INF/plugins/pmd.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/violations.hpi -o /tmp/WEB-INF/plugins/violations.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/xunit.hpi -o /tmp/WEB-INF/plugins/xunit.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/git-client.hpi -o /tmp/WEB-INF/plugins/git-client.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/scm-api.hpi -o /tmp/WEB-INF/plugins/scm-api.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/git.hpi -o /tmp/WEB-INF/plugins/git.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/bitbucket.hpi -o /tmp/WEB-INF/plugins/bitbucket.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/publish-over-ssh.hpi -o /tmp/WEB-INF/plugins/publish-over-ssh.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/greenballs.hpi -o /tmp/WEB-INF/plugins/greenballs.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/htmlpublisher.hpi -o /tmp/WEB-INF/plugins/htmlpublisher.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/workflow-aggregator.hpi -o /tmp/WEB-INF/plugins/workflow-aggregator.hpi && \
  curl -L https://updates.jenkins-ci.org/latest/ansicolor.hpi -o /tmp/WEB-INF/plugins/ansicolor.hpi

# Install Docker plugin for docker deploy.
RUN curl -L https://updates.jenkins-ci.org/latest/docker-build-publish.hpi -o /tmp/WEB-INF/plugins/docker-build-publish.hpi

# Update 
RUN apt-get update

# Install php packages.
RUN apt-get -y -f install zip libpcre3-dev gcc make re2c vim zsh

RUN apt-get -y -f install php7.0 php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dev \
php7.0-gd php7.0-json php7.0-ldap php7.0-mysql php7.0-odbc php7.0-opcache \
php7.0-xml php7.0-fpm php7.0-mbstring php7.0-mcrypt php7.0-zip php7.0-redis php-pear

# Install php phalcon.
RUN mkdir /home/php && \ 
  cd /home/php && \
  git clone https://github.com/phalcon/cphalcon.git --depth=1 && \
  cd /home/php/cphalcon/build && \
  ./install

# Install php swoole.
RUN pecl install swoole

COPY ext-phalcon.ini /etc/php/7.0/mods-available/
COPY ext-swoole.ini /etc/php/7.0/mods-available/

RUN ln -s /etc/php/7.0/mods-available/ext-phalcon.ini /etc/php/7.0/cli/conf.d/ext-phalcon.ini && \
  ln -s /etc/php/7.0/mods-available/ext-swoole.ini /etc/php/7.0/cli/conf.d/ext-swoole.ini && \
  ln -s /etc/php/7.0/mods-available/ext-phalcon.ini /etc/php/7.0/fpm/conf.d/ext-phalcon.ini && \
  ln -s /etc/php/7.0/mods-available/ext-swoole.ini /etc/php/7.0/fpm/conf.d/ext-swoole.ini

RUN php -m

# Add all to the war file.
RUN cd /tmp; \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/checkstyle.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/cloverphp.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/crap4j.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/dry.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/htmlpublisher.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/jdepend.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/plot.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/pmd.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/violations.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/xunit.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/docker-build-publish.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/git-client.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/scm-api.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/git.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/bitbucket.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/publish-over-ssh.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/greenballs.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/htmlpublisher.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/workflow-aggregator.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/ansicolor.hpi


# Install docker
RUN apt-get -y -f install docker

# Create a jenkins "HOME" for composer files.
RUN mkdir /home/jenkins
RUN chown jenkins:jenkins /home/jenkins

USER jenkins

#### This don't work as $JENKINS_HOME is a volume ####
# Install php template.
#RUN mkdir "$JENKINS_HOME/jobs/php-template"
#RUN curl -L https://raw.github.com/sebastianbergmann/php-jenkins-template/master/config.xml -o "$JENKINS_HOME/jobs/php-template/config.xml"
####                sad panda is sad              ####


# Install composer, yes we can't install it in $JENKINS_HOME :(
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/jenkins
RUN /home/jenkins/composer.phar config -g repo.packagist composer https://packagist.laravel-china.org

# Install required php tools.
RUN /home/jenkins/composer.phar --working-dir="/home/jenkins" -n require phing/phing:2.* notfloran/phing-composer-security-checker:~1.0 \
    phploc/phploc:* phpunit/phpunit:~4.0 pdepend/pdepend:~2.0 phpmd/phpmd:~2.2 sebastian/phpcpd:* \
    squizlabs/php_codesniffer:* mayflower/php-codebrowser:~1.1 codeception/codeception:*
#RUN echo "export PATH=$PATH:/home/jenkins/.composer/vendor/bin" >> $JENKINS_HOME/.bashrc # Keep dreaming!

USER root
RUN mkdir /home/bin
RUN cp /home/jenkins/composer.phar /home/jenkins/vendor/bin/composer
RUN apt-get clean -y

# Go back to jenkins user.
USER jenkins
