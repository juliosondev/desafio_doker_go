FROM golang:1.22-alpine AS builder

##DIRECTORIO  DO PROJECTO
WORKDIR /usr/src/app

##COPIAR OS ARQUIVOS DO PROJECTO
COPY . .

## INSTALAR O UPX PARA COMPRIMIR O BINARIO
RUN apk add --no-cache upx

## Instalar UPX para compressão
RUN apk add --no-cache upx

## Inicializar o módulo Go e instalar dependências
RUN go mod init fristGo && go mod tidy

## Compilar o binário sem símbolos de depuração
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o firstGo

## Comprimir o binário com UPX para ser mais leve ainda com valor em media de 1.04MB
RUN upx --best --lzma firstGo

##CRIAR A IMGEM LEVE
FROM scratch

##COPIAR O BINARIO DO PROJECTO
COPY --from=builder /usr/src/app/firstGo /firstGo

##COMANDO PARA INICIAR O SERVIDOR   
CMD [ "/firstGo" ]