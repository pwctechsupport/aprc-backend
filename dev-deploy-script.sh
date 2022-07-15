mkdir dev
cd dev
git clone git@bitbucket.org:alexaltech/pwc_backend.git
cd pwc_backend
git checkout develop
git pull origin develop
docker-compose build
docker-compose up -d