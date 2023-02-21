FROM nginx:latest
COPY index.html /usr/share/nginx/html
COPY quickstart.sh /
CMD ["/quickstart.sh"]
