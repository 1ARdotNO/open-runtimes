FROM mcr.microsoft.com/powershell:7.4-ubuntu-22.04
SHELL ["pwsh", "-noninteractive", "-command"]

ENV OPEN_RUNTIMES_ENTRYPOINT=pode.ps1

#folders
RUN mkdir -p /usr/local/src/
RUN mkdir -p /usr/code
RUN mkdir -p /usr/workspace
RUN mkdir -p /usr/builds

WORKDIR /usr/local/src
COPY . .

#install pode
RUN Install-Module -Name Pode -RequiredVersion 2.10.0

#run pode


EXPOSE 3000