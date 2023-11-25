FROM nginx

LABEL "Project"="JavaStack"
LABEL "Author"="Muhaned"

RUN rm -rf /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80