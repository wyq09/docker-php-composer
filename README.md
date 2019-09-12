# docker-php-composer

add alias for your .bashrc or .zshrc

<code>alias docker_composer='docker run --rm -it -v $(pwd):/usr/src/app -v ~/.composer:/home/composer/.composer -v ~/.ssh/id_rsa:/home/composer/.ssh/id_rsa:ro wuyq/php-composer:latest'</code>
