

```{r}

library(tictoc)
tic()
bookdown::render_book("index.Rmd")
toc()

docker run -it --rm -u rstudio \
  -v $(pwd):/home/rstudio/multivariate \
  mattocci/myenv:4.0.2 bash

docker run --rm -v $(pwd):/home/rstudio/afec \
  -p 8787:8787 \
  -e PASSWORD=test \
  mattocci/myenv:4.0.2

docker run -it --rm -u rstudio \
  -v $(pwd):/home/rstudio/multivariate \
  mattocci/myenv:4.0.2 bash

docker run -it --rm -u rstudio \
  -v /mnt/c/Users/'Masatoshi Katabuchi'/Dropbox/multivariate:/home/rstudio/multivariate \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -e DISPLAY=$DISPLAY \
  mattocci/myenv:4.0.2 bash


```
